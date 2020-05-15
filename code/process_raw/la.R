
la_12 <- fread("E:/purges_12_16_20/la/LA-2012-1/LAvoter071712.txt")

colnames(la_12) <- clean_names(la_12)

la_12 <- la_12 %>% 
  select(first_name = personal_firstname,
         middle_name = personal_middlename,
         last_name = personal_lastname,
         residence_housenumber, residence_streetdirection, residence_streetname,
         city = residence_city,
         state = residence_state,
         zip = residence_zipcode5,
         gender = personal_sex,
         race = personal_race,
         party = registration_politicalpartygroup,
         dob = personal_age,
         reg_date = registration_date,
         voter_id = registration_number,
         county = jurisdiction_parish)

la_12 <- clean_streets(la_12, c("residence_housenumber", "residence_streetdirection", "residence_streetname")) %>% 
  mutate(party = substring(party, 1, 1),
         reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
         dob = as.character(make_date(year = (2012 - dob))))

#########################
la_16 <- fread("E:/purges_12_16_20/la/LA-2017-1/LA-2017-1/Holly_Daigle_--_17-00762.4dde6b7d-bd0f-4437-954b-0a6bf629b9df.txt")

colnames(la_16) <- clean_names(la_16)

la_16 <- la_16 %>% 
  select(first_name = personal_firstname,
         middle_name = personal_middlename,
         last_name = personal_lastname,
         residence_housenumber, residence_streetdirection, residence_streetname,
         city = residence_city,
         state = residence_state,
         zip = residence_zipcode5,
         gender = personal_sex,
         race = personal_race,
         party = registration_politicalpartycode,
         dob = personal_age,
         reg_date = registration_date,
         voter_id = registration_number,
         county = jurisdiction_parish)

la_16 <- clean_streets(la_16, c("residence_housenumber", "residence_streetdirection", "residence_streetname")) %>% 
  mutate(party = ifelse(party %in% c("DEM", "REP"), substring(party, 1, 1),
                        ifelse(party == "NOPTY", "U", "O")),
         reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
         dob = as.character(make_date(year = (2017 - dob))))

la_12$purged <- !(la_12$voter_id %in% la_16$voter_id)

dbWriteTable(db_full, value = la_12, name = "LA_12", overwrite = T, append = F)

rm(la_12)

#########################
la_20 <- fread("E:/purges_12_16_20/la/LA-2020-1/20-02629.txt")

colnames(la_20) <- clean_names(la_20)

la_20 <- la_20 %>% 
  select(first_name = personal_firstname,
         middle_name = personal_middlename,
         last_name = personal_lastname,
         residence_housenumber, residence_streetdirection, residence_streetname,
         city = residence_city,
         state = residence_state,
         zip = residence_zipcode5,
         gender = personal_sex,
         race = personal_race,
         party = registration_politicalpartycode,
         dob = personal_age,
         reg_date = registration_date,
         voter_id = registration_number,
         county = jurisdiction_parish)

la_20 <- clean_streets(la_20, c("residence_housenumber", "residence_streetdirection", "residence_streetname")) %>% 
  mutate(party = ifelse(party %in% c("DEM", "REP"), substring(party, 1, 1),
                        ifelse(party == "NOPTY", "U", "O")),
         reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
         dob = as.character(make_date(year = (2017 - dob))))

la_16$purged <- !(la_16$voter_id %in% la_20$voter_id)

dbWriteTable(db_full, value = la_16, name = "LA_16", overwrite = T, append = F)
dbWriteTable(db_full, value = la_20, name = "LA_20", overwrite = T, append = F)