mo_12 <- fread("E:/purges_12_16_20/mo/mo_12/StateWide_VotersList_07012012_5-53-33 AM.txt",
               select = c("County",
                          "Voter ID",
                          "First Name",
                          "Middle Name",
                          "Last Name",
                          "House Number",
                          "Pre Direction",
                          "Street Name",
                          "Street Type",
                          "Post Direction",
                          "Residential City",
                          "Residential State",
                          "Residential ZipCode",
                          "Birthdate",
                          "Registration Date"))

colnames(mo_12) <- clean_names(mo_12)

mo_12 <- clean_streets(mo_12, c("house_number",
                                "pre_direction",
                                "street_name",
                                "street_type",
                                "post_direction")) %>% 
  rename(city = residential_city,
         state = residential_state,
         zip = residential_zipcode,
         dob = birthdate,
         reg_date = registration_date) %>% 
  mutate_at(vars(dob, reg_date), ~ as.character(as.Date(., "%m/%d/%Y")))

################################################

mo_16 <- fread("E:/purges_12_16_20/mo/mo_17/StateWide_VotersList_01292017_11-05-22 AM.txt",
               select = c("County",
                          "Voter ID",
                          "First Name",
                          "Middle Name",
                          "Last Name",
                          "House Number",
                          "Pre Direction",
                          "Street Name",
                          "Street Type",
                          "Post Direction",
                          "Residential City",
                          "Residential State",
                          "Residential ZipCode",
                          "Birthdate",
                          "Registration Date"))

colnames(mo_16) <- clean_names(mo_16)

mo_16 <- clean_streets(mo_16, c("house_number",
                                "pre_direction",
                                "street_name",
                                "street_type",
                                "post_direction")) %>% 
  rename(city = residential_city,
         state = residential_state,
         zip = residential_zipcode,
         dob = birthdate,
         reg_date = registration_date) %>% 
  mutate_at(vars(dob, reg_date), ~ as.character(as.Date(., "%m/%d/%Y")))

mo_12$purged <- !(mo_12$voter_id %in% mo_16$voter_id)
dbWriteTable(db_full, value = mo_12, name = "MO_12", overwrite = T, append = F)
rm(mo_12)
################################################

mo_20 <- read_tsv("E:/purges_12_16_20/mo/mo_20/PSR_VotersList_02032020_8-29-31 AM.txt") %>% 
  select("County",
         "Voter ID",
         "First Name",
         "Middle Name",
         "Last Name",
         "House Number",
         "Pre Direction",
         "Street Name",
         "Street Type",
         "Post Direction",
         "Residential City",
         "Residential State",
         "Residential ZipCode",
         "Birthdate",
         "Registration Date")

colnames(mo_20) <- clean_names(mo_20)

mo_20 <- clean_streets(mo_20, c("house_number",
                                "pre_direction",
                                "street_name",
                                "street_type",
                                "post_direction")) %>% 
  rename(city = residential_city,
         state = residential_state,
         zip = residential_zipcode,
         dob = birthdate,
         reg_date = registration_date) %>% 
  mutate_at(vars(dob, reg_date), ~ as.character(as.Date(., "%m/%d/%Y")))

mo_16$purged <- !(mo_16$voter_id %in% mo_20$voter_id)
dbWriteTable(db_full, value = mo_16, name = "MO_16", overwrite = T, append = F)
dbWriteTable(db_full, value = mo_20, name = "MO_20", overwrite = T, append = F)