library(readxl)

dat <- list.files("raw_data", full.names = TRUE)

dat <- grep("TRANSFERS", dat, value = TRUE, ignore.case = TRUE)

res <- lapply(dat, function(file) readxl::read_excel(file, skip = 1))

lapply(res, colnames)

res_2022 <- res[[4]]

colnames(res_2022) <- ifelse(
    !is.na(res_2022[1, ]),
    as.character(res_2022[1, ]),
    colnames(res_2022)
)

res_2022 <- res_2022[-1, ]

res_2022 <- janitor::clean_names(res_2022)

res_2022 <- res_2022 %>%
    mutate(
        council = case_when(
            grepl("Hospital", council) ~ "Freetown City",
            TRUE ~ council
        )
    )

res_2022 <- res_2022 %>%
    group_by(council) %>%
    # drop nat tot
    filter(council != "NATIONAL TOTAL") %>%
    mutate(across(
        support_to_ward_committees:grand_total,
        ~ {
            as.numeric(.)
        }
    )) %>%
    summarise(across(
        everything(),
        ~ {
            sum(., na.rm = TRUE)
        }
    ))

# Check for row and col totals

res_2022 <- res_2022 %>%
    rowwise() %>%
    mutate(
        row_total = round(
            sum(
                c_across(support_to_ward_committees:unconditional_block_grant),
                na.rm = TRUE
            ),
            3
        )
    )

all(res_2022$row_total == round(res_2022$grand_total, 3))

res_2022 <- res_2022 %>%
    mutate(year = 2022)
