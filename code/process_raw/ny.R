

ny_12 <- fread("E:/purges_12_16_20/ny/NY-2012-1/All-Voters_070112.txt")

colnames(ny_12) <- fread("D:/rolls/new_york/misc/colnames.csv", header = F)$V1
colnames(ny_12) <- clean_names(ny_12)

ny_12 <- filter(ny_12, voter_status != "PURGED")

ny_12 <- clean_streets(ny_12, c("res_house_number", "res_pre_street",
                                "res_street_name", "res_post_street_dir")) %>% 
  select(last_name, first_name, middle_name,
         city = res_city,
         zip = zip5,
         dob, gender,
         party = political_party,
         voter_id = nys_id,
         reg_date = registration_date, street) %>% 
  mutate_at(vars(dob, reg_date), ~ as.character(as.Date(as.character(.), "%Y%m%d")))

######################

ny_16 <- fread("E:/purges_12_16_20/ny/NY-2016-3/AllNYSVoters.txt")

colnames(ny_16) <- fread("D:/rolls/new_york/misc/colnames.csv", header = F)$V1
colnames(ny_16) <- clean_names(ny_16)

ny_16 <- filter(ny_16, voter_status != "PURGED")

ny_16 <- clean_streets(ny_16, c("res_house_number", "res_pre_street",
                                "res_street_name", "res_post_street_dir")) %>% 
  select(last_name, first_name, middle_name,
         city = res_city,
         zip = zip5,
         dob, gender,
         party = political_party,
         voter_id = nys_id,
         reg_date = registration_date, street) %>% 
  mutate_at(vars(dob, reg_date), ~ as.character(as.Date(as.character(.), "%Y%m%d")))

ny_12$purged <- !(ny_12$voter_id %in% ny_16$voter_id)
dbWriteTable(db_full, name = "NY_12", value = ny_12, overwrite = T, append = F)

######################

ny_20 <- fread("E:/purges_12_16_20/ny/NY-2020-1/AllNYSVoters_20200127.txt")

colnames(ny_20) <- fread("D:/rolls/new_york/misc/colnames.csv", header = F)$V1
colnames(ny_20) <- clean_names(ny_20)

ny_20 <- filter(ny_20, voter_status != "PURGED")

ny_20 <- clean_streets(ny_20, c("res_house_number", "res_pre_street",
                                "res_street_name", "res_post_street_dir")) %>% 
  select(last_name, first_name, middle_name,
         city = res_city,
         zip = zip5,
         dob, gender,
         party = political_party,
         voter_id = nys_id,
         reg_date = registration_date, street) %>% 
  mutate_at(vars(dob, reg_date), ~ as.character(as.Date(as.character(.), "%Y%m%d")))

ny_16$purged <- !(ny_16$voter_id %in% ny_20$voter_id)
dbWriteTable(db_full, name = "NY_16", value = ny_16, overwrite = T, append = F)
dbWriteTable(db_full, name = "NY_20", value = ny_20, overwrite = T, append = F)