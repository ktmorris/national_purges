

ma_12 <- fread("E:/purges_12_16_20/ma/MA-2012-1/voter_extract_20120508/statewide_voter.txt")

colnames(ma_12) <- c("Row Number",
                     "City/Town Code",
                     "City/Town Name",
                     "County Name",
                     "Voter ID",
                     "Last Name",
                     "First Name",
                     "Middle Name",
                     "Title",
                     "Residential Address - Street No.",
                     "Residential Address - Street No. Suffix",
                     "Residential Address - Street Name",
                     "Residential Address - Apt. No.",
                     "Residential Address - Zip Code",
                     "Mailing Address - Street Address",
                     "Mailing Address - Apt. No.",
                     "Mailing Address - City/Town",
                     "Mailing Address - State",
                     "Mailing Address - Zip Code",
                     "Party Affiliation",
                     "Gender",
                     "Date of Birth",
                     "Registration Date",
                     "Ward Number",
                     "Precinct Number",
                     "Congressional District ",
                     "Senatorial District",
                     "State Representative District",
                     "Voter Status")
colnames(ma_12) <- clean_names(ma_12)

ma_12 <- ma_12 %>% 
  select(city = city_town_name,
         county = county_name,
         voter_id,
         last_name,
         first_name,
         middle_name,
         residential_address___street_no_,
         residential_address___street_name,
         zip = residential_address___zip_code,
         party = party_affiliation,
         gender,
         dob = date_of_birth,
         reg_date = registration_date)

ma_12 <- clean_streets(ma_12, c("residential_address___street_no_",
                                "residential_address___street_name")) %>% 
  mutate_at(vars(dob, reg_date), ~ as.character(as.Date(paste0(substring(., 1, 7),
           ifelse(as.integer(substring(., 8)) < 13, "20", "19"),
           substring(., 8)), "%d-%b-%Y"))) %>% 
  mutate(party = ifelse(party %in% c("D", "R", "U"), party, "O"),
         state = "MA")

#################

ma_16 <- fread("E:/purges_12_16_20/ma/MA-2017-1-PartialProcess/MA_20171-EDBVoters.txt")

colnames(ma_16) <- clean_names(ma_16)

ma_16 <- ma_16 %>% 
  select(voter_id = statevoterid,
         first_name = firstname,
         middle_name = middlename,
         last_name = lastname,
         gender,
         party,
         dob = birthdate,
         reg_date = regdate,
         street = resaddressline,
         city = rescity,
         state = resstate,
         zip = reszip,
         county) %>% 
  mutate(party = ifelse(party %in% c("Democratic", "Republican"),
                        substring(party, 1, 1),
                        ifelse(party == "Non-Partisan", "U", "O"))) %>% 
  mutate_at(vars(dob, reg_date), ~ substring(., 1, 10))

ma_12$purged <- !(ma_12$voter_id %in% ma_16$voter_id)
dbWriteTable(db_full, value = ma_12, name = "MA_12", overwrite = T, append = F)

rm(ma_12)
#################

ma_20 <- fread("E:/purges_12_16_20/ma/MA-2020-1-PartialProcess/MA_20201_MidExportVoters.tab")

colnames(ma_20) <- clean_names(ma_20)

ma_20 <- ma_20 %>% 
  select(voter_id = statevoterid,
         first_name = firstname,
         middle_name = middlename,
         last_name = lastname,
         gender,
         party,
         dob = birthdate,
         reg_date = regdate,
         street = resaddressline,
         city = rescity,
         state = resstate,
         zip = reszip,
         county = fips) %>% 
  mutate(party = ifelse(party %in% c("Democratic", "Republican"),
                        substring(party, 1, 1),
                        ifelse(party == "Non-Partisan", "U", "O"))) %>% 
  mutate_at(vars(dob, reg_date), ~ as.character(as.Date(., "%m/%d/%Y")))

ma_16$purged <- !(ma_16$voter_id %in% ma_20$voter_id)
dbWriteTable(db_full, value = ma_16, name = "MA_16", overwrite = T, append = F)
dbWriteTable(db_full, value = ma_20, name = "MA_20", overwrite = T, append = F)