

ri_12 <- fread("E:/purges_12_16_20/ri/RI-2012-1/Voter.txt")

colnames(ri_12) <- clean_names(ri_12)

ri_12 <- clean_streets(ri_12, c("street_number", "street_name")) %>% 
  select(voter_id, last_name, first_name, middle_name,
         zip = zip_code,
         city, state, party = party_code,
         reg_date = date_effective,
         gender = sex,
         dob = date_of_birth,
         street) %>% 
  mutate_at(vars(dob, reg_date), ~ as.character(as.Date(., "%m/%d/%Y")))

#############################
ri_16 <- fread("E:/purges_12_16_20/ri/RI-2016-2/Voter_Fixed.txt")

colnames(ri_16) <- clean_names(ri_16)

ri_16 <- clean_streets(ri_16, c("street_number", "street_name")) %>% 
  select(voter_id, last_name, first_name, middle_name,
         zip = zip_code,
         city, state, party = party_code,
         reg_date = date_effective,
         gender = sex,
         dob = date_of_birth,
         street) %>% 
  mutate_at(vars(dob, reg_date), ~ as.character(as.Date(., "%m/%d/%Y")))

ri_12$purged <- !(ri_12$voter_id %in% ri_16$voter_id)
dbWriteTable(db_full, name = "RI_12", value = ri_12, overwrite = T, append = F)

#############################
ri_20 <- fread("E:/purges_12_16_20/ri/RI-2019-2/Statewide Voter File 11.18.19/Voter.txt")

colnames(ri_20) <- clean_names(ri_20)

ri_20 <- clean_streets(ri_20, c("street_number", "street_name")) %>% 
  select(voter_id, last_name, first_name, middle_name,
         zip = zip_code,
         city, state, party = party_code,
         reg_date = date_effective,
         gender = sex,
         dob = year_of_birth,
         street) %>% 
  mutate_at(vars(reg_date), ~ as.character(as.Date(., "%m/%d/%Y"))) %>% 
  mutate(dob = as.character(make_date(dob)))

ri_16$purged <- !(ri_16$voter_id %in% ri_20$voter_id)
dbWriteTable(db_full, name = "RI_16", value = ri_16, overwrite = T, append = F)
dbWriteTable(db_full, name = "RI_20", value = ri_20, overwrite = T, append = F)