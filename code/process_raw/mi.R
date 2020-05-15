cleanup()
mi_20 <- fread("E:/purges_12_16_20/mi/EntireStateVoters_Custom_20200405.csv",
               select = c("LAST_NAME", "FIRST_NAME", "MIDDLE_NAME",
                          "YEAR_OF_BIRTH", "GENDER", "REGISTRATION_DATE",
                          "STREET_NUMBER_PREFIX", "STREET_NUMBER",
                          "STREET_NUMBER_SUFFIX", "DIRECTION_PREFIX",
                          "STREET_NAME", "STREET_TYPE", "DIRECTION_SUFFIX",
                          "CITY", "ZIP_CODE", "VOTER_IDENTIFICATION_NUMBER",
                          "COUNTY_NAME", "VOTER_STATUS_TYPE_CODE"),
               nrows = 1000) %>% 
  filter(VOTER_STATUS_TYPE_CODE != "C")

colnames(mi_20) <- clean_names(mi_20)

mi_20 <- clean_streets(mi_20, c("street_number_prefix", "street_number", "street_number_suffix",
                                "direction_prefix", "street_name", "street_type", "direction_suffix"))

mi_20 <- mi_20 %>% 
  mutate(dob = as.character(make_date(year_of_birth)),
         reg_date = as.character(as.Date(registration_date)),
         state = "MI") %>% 
  select(-year_of_birth, -registration_date, -voter_status_type_code) %>% 
  rename(county = county_name,
         voter_id = voter_identification_number)
