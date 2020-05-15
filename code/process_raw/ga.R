ga_12 <- fread("E:/purges_12_16_20/ga/GA-2012-1/DailyVoterBase_Delimited.txt",
               select = c("County_Code", "Registration_Number",
                          "Last_Name", "First_Name", "Middle_Maiden_Name",
                          "Residence_House_Number", "Residence_Street_name",
                          "Residence_Street_Suffix",
                          "Residence_City", "Residence_Zip5",
                          "Residence_Zip4",
                          "Birthdate", "Registration_Date",
                          "Race", "Gender", "Party_Last_Voted"))

colnames(ga_12) <- clean_names(ga_12)

ga_12 <- clean_streets(ga_12, c("residence_house_number", "residence_street_name",
                                "residence_street_suffix")) %>% 
  mutate(dob = as.character(make_date(year = (birthdate / 10000))),
         race = ifelse(race == "W", "White",
                       ifelse(race == "B", "Black",
                              ifelse(race == "H", "Latino",
                                     ifelse(race == "A", "Asian", "Other")))),
         party = ifelse(party_last_voted == "D", "D",
                        ifelse(party_last_voted == "R", "R",
                               ifelse(party_last_voted == "", "U", "O"))),
         state = "GA",
         registration_date = as.character(as.Date(as.character(registration_date), "%Y%m%d")),
         zip = paste0(str_pad(residence_zip5, width = 5, pad = "0", side = "left"),
                      str_pad(residence_zip4, width = 4, pad = "0", side = "left"))) %>% 
  select(-party_last_voted, -birthdate,
         -residence_zip5, -residence_zip4) %>% 
  rename(city = residence_city,
         middle_name = middle_maiden_name,
         county = county_code,
         reg_date = registration_date,
         voter_id = registration_number)

###################

ga_16 <- fread("E:/purges_12_16_20/ga/ga_090716/Georgia_Daily_VoterBase.txt",
               select = c("COUNTY_CODE", "REGISTRATION_NUMBER",
                          "LAST_NAME", "FIRST_NAME", "MIDDLE_MAIDEN_NAME",
                          "RESIDENCE_HOUSE_NUMBER", "RESIDENCE_STREET_NAME",
                          "RESIDENCE_STREET_SUFFIX",
                          "RESIDENCE_CITY", "RESIDENCE_ZIPCODE",
                          "BIRTHDATE", "REGISTRATION_DATE",
                          "RACE_DESC", "GENDER", "PARTY_LAST_VOTED"))

colnames(ga_16) <- clean_names(ga_16)

ga_16 <- clean_streets(ga_16, c("residence_house_number", "residence_street_name",
                                "residence_street_suffix")) %>% 
  mutate(dob = as.character(make_date(year = birthdate)),
         race = ifelse(race_desc == "White not of Hispanic Origin", "White",
                       ifelse(race_desc == "Black not of Hispanic Origin", "Black",
                              ifelse(race_desc == "Hispanic", "Latino",
                                     ifelse(race_desc == "Asian or Pacific Islander", "Asian",
                                            ifelse(race_desc %in% c(
                                              "American Indian or Alaskan Native",
                                              "Other",
                                              "Unknown",
                                              ""
                                            ), "Other", race_desc))))),
         party = ifelse(party_last_voted == "D", "D",
                        ifelse(party_last_voted == "R", "R",
                               ifelse(party_last_voted == "", "U", "O"))),
         state = "GA",
         registration_date = as.character(as.Date(as.character(registration_date), "%Y%m%d"))) %>% 
  select(-party_last_voted, -birthdate,
         -race_desc) %>% 
  rename(city = residence_city,
         zip = residence_zipcode,
         middle_name = middle_maiden_name,
         county = county_code,
         reg_date = registration_date,
         voter_id = registration_number)

ga_12$purged <- !(ga_12$voter_id %in% ga_16$voter_id)

dbWriteTable(db_full, name = "GA_12", value = ga_12, overwrite = T, append = F)
rm(ga_12)

###################
ga_20 <- fread("E:/purges_12_16_20/ga/GA-2019-3/Georgia_Daily_VoterBase.txt",
               select = c("COUNTY_CODE", "REGISTRATION_NUMBER",
                          "LAST_NAME", "FIRST_NAME", "MIDDLE_MAIDEN_NAME",
                          "RESIDENCE_HOUSE_NUMBER", "RESIDENCE_STREET_NAME",
                          "RESIDENCE_STREET_SUFFIX",
                          "RESIDENCE_CITY", "RESIDENCE_ZIPCODE",
                          "BIRTHDATE", "REGISTRATION_DATE",
                          "RACE_DESC", "GENDER", "PARTY_LAST_VOTED"))

colnames(ga_20) <- clean_names(ga_20)

ga_20 <- clean_streets(ga_20, c("residence_house_number", "residence_street_name",
                                "residence_street_suffix")) %>% 
  mutate(dob = as.character(make_date(year = birthdate)),
         race = ifelse(race_desc == "White not of Hispanic Origin", "White",
                       ifelse(race_desc == "Black not of Hispanic Origin", "Black",
                              ifelse(race_desc == "Hispanic", "Latino",
                                     ifelse(race_desc == "Asian or Pacific Islander", "Asian",
                                            ifelse(race_desc %in% c(
                                              "American Indian or Alaskan Native",
                                              "Other",
                                              "Unknown",
                                              ""
                                            ), "Other", race_desc))))),
         party = ifelse(party_last_voted == "D", "D",
                        ifelse(party_last_voted == "R", "R",
                               ifelse(party_last_voted == "", "U", "O"))),
         state = "GA",
         registration_date = as.character(as.Date(as.character(registration_date), "%Y%m%d"))) %>% 
  select(-party_last_voted, -birthdate,
         -race_desc) %>% 
  rename(city = residence_city,
         zip = residence_zipcode,
         middle_name = middle_maiden_name,
         county = county_code,
         reg_date = registration_date,
         voter_id = registration_number)

ga_16$purged <- !(ga_16$voter_id %in% ga_20$voter_id)

dbWriteTable(db_full, name = "GA_16", value = ga_16, overwrite = T, append = F)
dbWriteTable(db_full, name = "GA_20", value = ga_20, overwrite = T, append = F)


#### if you move do you keep your id?

inner1 <- inner_join(ga_16, ga_20, by = c("voter_id", "first_name", "last_name", "dob"))
j <- mean(inner1$county.x == inner1$county.y)
saveRDS(j, "./temp/share_ga_same_id_different_county.rds")
##### can ids be re-assigned?

inner1 <- inner_join(ga_16, ga_20, by = c("voter_id"))
j <- mean(inner1$dob.x == inner1$dob.y, na.rm = T)
saveRDS(j, "./temp/share_ga_same_id_same_dob.rds")
######## do invidivuals get new ids?

inner1 <- inner_join(ga_16, ga_20, by = c("first_name", "last_name", "street", "city", "dob"),
                     na_matches = "never")
j <- mean(inner1$voter_id.x != inner1$voter_id.y)
saveRDS(j, "./temp/share_ga_different_id_same_name_street.rds")

j <- mean(filter(inner1, reg_date.x != reg_date.y)$voter_id.x == filter(inner1, reg_date.x != reg_date.y)$voter_id.y)
saveRDS(j, "./temp/share_ga_same_id_street_different_reg_date.rds")

## hmmm... about 23% of the time that someone re-registers at the same address, they get new voter id