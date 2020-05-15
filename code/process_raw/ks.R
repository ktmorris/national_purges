ks_12 <- read_tsv("E:/purges_12_16_20/ks/KS-2012-1/LL Statewide.txt")

ks_12 <- ks_12 %>% 
  select(county = db_logid,
         first_name = text_name_first,
         middle_name = text_name_middle,
         last_name = text_name_last,
         dob = date_of_birth,
         reg_date = date_of_registration,
         voter_id = text_registrant_id,
         text_res_address_nbr, cde_street_dir_prefix,
         text_street_name, cde_street_type,
         city = text_res_city,
         state = cde_res_state,
         zip = text_res_zip5,
         party = cde_party,
         gender = cde_gender)

ks_12 <- clean_streets(ks_12, c("text_res_address_nbr", "cde_street_dir_prefix",
                     "text_street_name", "cde_street_type")) %>% 
  mutate(party = ifelse(party %in% c("D", "R", "U"), party, "O"),
         dob = as.character(as.Date(dob, "%m/%d/%Y")),
         reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")))

###################################
ks_16 <- read_tsv("E:/purges_12_16_20/ks/KS-2017-1/StatewideFeb2nd2017.txt")

ks_16 <- ks_16 %>% 
  select(county = db_logid,
         first_name = text_name_first,
         middle_name = text_name_middle,
         last_name = text_name_last,
         dob = date_of_birth,
         reg_date = date_of_registration,
         voter_id = text_registrant_id,
         text_res_address_nbr, cde_street_dir_prefix,
         text_street_name, cde_street_type,
         city = text_res_city,
         state = cde_res_state,
         zip = text_res_zip5,
         party = cde_party,
         gender = cde_gender)

ks_16 <- clean_streets(ks_16, c("text_res_address_nbr", "cde_street_dir_prefix",
                                "text_street_name", "cde_street_type")) %>% 
  mutate(party = ifelse(party %in% c("D", "R", "U"), party, "O"),
         dob = as.character(as.Date(dob, "%m/%d/%Y")),
         reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")))

ks_12$purged <- !(ks_12$voter_id %in% ks_16$voter_id)
dbWriteTable(db_full, value = ks_12, name = "KS_12", overwrite = T, append = F)
rm(ks_12)
###################################
ks_20 <- read_tsv("E:/purges_12_16_20/ks/KS-2020-1/Statewide02212020.txt")

ks_20 <- ks_20 %>% 
  select(county = db_logid,
         first_name = text_name_first,
         middle_name = text_name_middle,
         last_name = text_name_last,
         dob = date_of_birth,
         reg_date = date_of_registration,
         voter_id = text_registrant_id,
         text_res_address_nbr, cde_street_dir_prefix,
         text_street_name, cde_street_type,
         city = text_res_city,
         state = cde_res_state,
         zip = text_res_zip5,
         party = desc_party,
         gender = cde_gender)

ks_20 <- clean_streets(ks_20, c("text_res_address_nbr", "cde_street_dir_prefix",
                                "text_street_name", "cde_street_type")) %>% 
  mutate(party = ifelse(party %in% c("Democratic", "Republican", "Unaffiliated"),
                        substring(party, 1, 1), "O"),
         dob = as.character(as.Date(dob, "%m/%d/%Y")),
         reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")))

ks_16$purged <- !(ks_16$voter_id %in% ks_20$voter_id)
dbWriteTable(db_full, value = ks_16, name = "KS_16", overwrite = T, append = F)
dbWriteTable(db_full, value = ks_20, name = "KS_20", overwrite = T, append = F)
