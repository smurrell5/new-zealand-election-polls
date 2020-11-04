# 2020 Election Polling data, transformed to match the other data set


url <- paste0("https://en.wikipedia.org/wiki/Opinion_polling_for_the_2020_New_Zealand_general_election")

h <- read_html(url)

tab <- h %>% html_nodes("table")

tt_data <- tab[[1]] %>% html_table

tt_data2 <- tt_data[-c(3, 9, 13, 17, 20, 23, 28, 36, 39, 44, 46, 49, 51, 52, 54, 60),] %>%
  rename("Date" = "Date[nb 1]") %>%
  select(-c(TOP, MRI, NCP, ANZ, Lead)) %>%
  setNames(c("Year", "Pollster", "Sample Size",
             "National", "Labour", "NZ_First", "Green", "ACT")) %>%
  pivot_longer(cols = c(Labour, National, NZ_First, Green, ACT), names_to = "Party", values_to = "VotingIntention") %>%
  mutate(VotingIntention = as.numeric(as.character(VotingIntention))) %>%
  drop_na()

tt_data3 <- tt_data2[-c(106:230),]