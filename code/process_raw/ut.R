cleanup()

ut_12 <- read_csv("E:/purges_12_16_20/ut/UT-2012-1/Utah-6-12-12.txt")

colnames(ut_12) <- clean_names(ut_12)

ut_12 <- ut_12 %>% 
  select(voter_id,
         last_name,
         first_name,
         middle_name,
         reg_date = registration_date,
         party,
         county = county_id,
         house_number, direction_prefix, street, direction_suffix, street_type,
         city,
         zip,
         dob)

ut_12 <- clean_streets(ut_12, c("house_number", "direction_prefix",
                                "street", "direction_suffix", "street_type")) %>% 
  mutate(state = "UT",
         party = ifelse(party == "Democratic", "D",
                        ifelse(party == "Republican", "R",
                               ifelse(party == "Unaffiliated", "U", "O")))) %>% 
  mutate_at(vars(dob, reg_date), ~ as.character(as.Date(., "%m/%d/%Y")))

####################

ut_16 <- read_csv("E:/purges_12_16_20/ut/UT-2016-2-160816/voters.txt")

colnames(ut_16) <- clean_names(ut_16)

ut_16 <- ut_16 %>% 
  select(voter_id,
         last_name,
         first_name,
         middle_name,
         reg_date = registration_date,
         party,
         county = county_id,
         house_number, direction_prefix, street, direction_suffix, street_type,
         city,
         zip)

ut_16 <- clean_streets(ut_16, c("house_number", "direction_prefix",
                                "street", "direction_suffix", "street_type")) %>% 
  mutate(state = "UT",
         party = ifelse(party == "Democratic", "D",
                        ifelse(party == "Republican", "R",
                               ifelse(party == "Unaffiliated", "U", "O")))) %>% 
  mutate_at(vars(reg_date), ~ as.character(as.Date(., "%m/%d/%Y")))

ut_12$purged <- !(ut_12$voter_id %in% ut_16$voter_id)
dbWriteTable(db_full, value = ut_12, name = "UT_12", overwrite = T, append = F)
