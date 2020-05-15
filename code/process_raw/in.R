in_12 <- fread("E:/purges_12_16_20/in/IN-2012-1/Statewide_VoterInformation_NonPublic.txt",
               select = c("REGISTRATION_DATE", "GENDER",
                          "DOB", "FIRST_NAME", "MIDDLE_NAME", "LAST_NAME",
                          "FULL_ADDRESS",
                          "CITY", "STATE", "ZIP",
                          "LEGACY_IDENTIFICATION_NUMBER",
                          "IDENTIFICATION_NUMBER",
                          "Locality"))
colnames(in_12) <- clean_names(in_12)

in_12 <- in_12 %>% 
  rename(reg_date = registration_date,
         street = full_address,
         old_voter_id = legacy_identification_number,
         voter_id = identification_number,
         county = locality) %>% 
  mutate_at(vars(reg_date, dob), ~ substring(., 1, 10))

############################
in_16 <- read_csv("E:/purges_12_16_20/in/IN-2017-1/Statewide_VoterInformation_NonPublic03272017/Statewide_VoterInformation_NonPublic.txt")


in_16 <- in_16 %>% 
  select("REGISTRATION_DATE", "GENDER",
         "DOB", "FIRST_NAME", "MIDDLE_NAME", "LAST_NAME",
         "FULL_ADDRESS",
         "CITY", "STATE", "ZIP",
         "LEGACY_IDENTIFICATION_NUMBER",
         "IDENTIFICATION_NUMBER",
         "Locality")

colnames(in_16) <- clean_names(in_16)

in_16 <- in_16 %>% 
  rename(reg_date = registration_date,
         street = full_address,
         old_voter_id = legacy_identification_number,
         voter_id = identification_number,
         county = locality) %>% 
  mutate(reg_date = substring(reg_date, 1, 10),
         dob = as.character(dob))

in_12$purged <- !(in_12$voter_id %in% in_16$voter_id)
dbWriteTable(db_full, value = in_12, name = "IN_12", overwrite = T, append = F)

rm(in_12)

############################
in_20 <- fread("E:/purges_12_16_20/in/IN-2020-1/Statewide_VoterInformation_NonPublic.txt",
                  select = c("REGISTRATION_DATE", "GENDER",
                             "DOB", "FIRST_NAME", "MIDDLE_NAME", "LAST_NAME",
                             "FULL_ADDRESS",
                             "CITY", "STATE", "ZIP",
                             "LEGACY_IDENTIFICATION_NUMBER",
                             "IDENTIFICATION_NUMBER",
                             "Locality"))

colnames(in_20) <- clean_names(in_20)

in_20 <- in_20 %>% 
  rename(reg_date = registration_date,
         street = full_address,
         old_voter_id = legacy_identification_number,
         voter_id = identification_number,
         county = locality) %>% 
  mutate_at(vars(reg_date, dob), ~ substring(., 1, 10))

in_16$purged <- !(in_16$voter_id %in% in_20$voter_id)
dbWriteTable(db_full, value = in_16, name = "IN_16", overwrite = T, append = F)
dbWriteTable(db_full, value = in_20, name = "IN_20", overwrite = T, append = F)
