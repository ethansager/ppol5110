# Load required packages
if (!('pacman' %in% rownames(installed.packages()))) {
  install.packages('pacman')
}
pacman::p_load(pdftools, tidyverse, stringr)

pdf_path <- "raw_data/Poverty Mapping_Sierra Leone_FINAL.pdf"

# 1. Extract text from the PDF
pdf_text <- pdf_text(pdf_path)

# 2. Locate the page containing "Table 6"
page_num <- which(str_detect(pdf_text, "Table 6: Poverty Estimates"))


# 3. Extract text from that page (and possibly the next if table spans pages)
table_text <- paste(pdf_text[page_num:(page_num + 1)], collapse = "\n")

# 4. Split into lines and clean
lines <- str_split(table_text, "\n")[[1]] |>
    str_trim() |>
    discard(~ .x == "")

# 5. Identify table start and end using keywords
start <- which(str_detect(lines, regex("^Table 6", ignore_case = TRUE))) + 1
end <- which(str_detect(lines, regex("^Table 7", ignore_case = TRUE))) - 1
table_lines <- lines[start:end]

# 6. Remove header notes and merge wrapped lines
# Combine continuation lines (rough heuristic)
table_lines <- str_replace_all(table_lines, "\\s{2,}", ",") # replace 2+ spaces with comma


clean_poverty_vec <- function(v) {
    trim <- function(x) gsub("^\\s+|\\s+$", "", x)

    parsed_rows <- lapply(v, function(s) {
        tokens <- trim(strsplit(s, ",", fixed = TRUE)[[1]])
        # numeric detection: strip parentheses and attempt numeric conversion
        stripped <- gsub("[()]", "", tokens)
        nums <- suppressWarnings(as.numeric(stripped))
        is_num <- !is.na(nums)
        area_tokens <- tokens[!is_num]
        area <- if (length(area_tokens) > 0) {
            paste(area_tokens, collapse = ",")
        } else {
            NA_character_
        }
        # detect if numeric tokens were ALL parenthesized -> likely SE row
        orig_paren <- grepl("^\\(.*\\)$", tokens)
        is_se <- length(is_num) > 0 && all(orig_paren[is_num])
        list(area = area, nums = nums[is_num], is_se = is_se, raw = tokens)
    })

    # keep only rows that contain numeric values (drop header rows)
    rows <- parsed_rows[sapply(parsed_rows, function(rr) length(rr$nums) > 0)]
    used <- rep(FALSE, length(rows))
    out <- list()

    for (i in seq_along(rows)) {
        if (used[i]) {
            next
        }
        r <- rows[[i]]

        if (!r$is_se) {
            # prefer pairing with next row if it's an SE row, otherwise previous
            j <- NA_integer_
            if (i < length(rows) && rows[[i + 1]]$is_se) {
                j <- i + 1
            } else if (i > 1 && rows[[i - 1]]$is_se && !used[i - 1]) {
                j <- i - 1
            }

            if (!is.na(j)) {
                se_row <- rows[[j]]
                used[c(i, j)] <- TRUE
            } else {
                se_row <- list(
                    nums = rep(NA_real_, length(r$nums)),
                    area = NA_character_
                )
                used[i] <- TRUE
            }
            area <- if (!is.na(r$area)) {
                r$area
            } else if (!is.na(se_row$area)) {
                se_row$area
            } else {
                NA_character_
            }
            estimates <- r$nums
            ses <- se_row$nums
        } else {
            # r is an SE row: find adjacent estimate row
            j <- NA_integer_
            if (i < length(rows) && !rows[[i + 1]]$is_se) {
                j <- i + 1
            } else if (i > 1 && !rows[[i - 1]]$is_se && !used[i - 1]) {
                j <- i - 1
            }

            if (!is.na(j)) {
                est_row <- rows[[j]]
                used[c(i, j)] <- TRUE
            } else {
                est_row <- list(
                    nums = rep(NA_real_, length(r$nums)),
                    area = NA_character_
                )
                used[i] <- TRUE
            }
            area <- if (!is.na(est_row$area)) {
                est_row$area
            } else if (!is.na(r$area)) {
                r$area
            } else {
                NA_character_
            }
            estimates <- est_row$nums
            ses <- r$nums
        }

        # ensure length 4 (pad with NA if needed)
        if (length(estimates) < 4) {
            estimates <- c(estimates, rep(NA_real_, 4 - length(estimates)))
        }
        if (length(ses) < 4) {
            ses <- c(ses, rep(NA_real_, 4 - length(ses)))
        }

        out[[length(out) + 1]] <- data.frame(
            area = area,
            total_sim = estimates[1],
            total_direct = estimates[2],
            extreme_sim = estimates[3],
            extreme_direct = estimates[4],
            total_sim_se = ses[1],
            total_direct_se = ses[2],
            extreme_sim_se = ses[3],
            extreme_direct_se = ses[4],
            stringsAsFactors = FALSE
        )
    }

    df <- do.call(rbind, out)
    df$area <- trim(gsub("^,|,$", "", df$area))
    rownames(df) <- NULL
    df
}

clean_table <- clean_poverty_vec(table_lines)

# 7. Write raw version to CSV
haven::write_dta(clean_table, "analysis/00_dta/poverty_estimates_2020.dta")
