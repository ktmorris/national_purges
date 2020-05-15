cleanup()

il_12 <- fread("E:/purges_12_16_20/il/IL-2012-1/Statewide norm 6-12_Voters.txt")

colnames(il_12) <- clean_names(il_12)

il_12 <- il_12 %>% 
  select(voter_id = suid,
         last_name = lastname,
         first_name = firstname,
         middle_name = middlename,
         reg_date = registrationdate,
         dob = birthdate,
         gender = sex,
         street = voteaddress,
         city = votecity,
         state = votestate,
         zip = votezip,
         county = jurisdictionid) %>% 
  mutate_at(vars(dob, reg_date), ~ as.character(as.Date(., "%m/%d/%Y")))
##################
il_16 <- fread("E:/purges_12_16_20/il/IL-2017-1/Statewide Norm 1-17_Voters.txt")

colnames(il_16) <- clean_names(il_16)

il_16 <- il_16 %>% 
  select(voter_id = suid,
         last_name = lastname,
         first_name = firstname,
         middle_name = middlename,
         reg_date = registrationdate,
         dob = birthdate,
         gender = sex,
         street = voteaddress,
         city = votecity,
         state = votestate,
         zip = votezip,
         county = jurisdictionid) %>% 
  mutate_at(vars(dob, reg_date), ~ as.character(as.Date(., "%m/%d/%Y")))
il_12$purged <- !(il_12$voter_id %in% il_16$voter_id)
dbWriteTable(db_full, name = "IL_12", value = il_12, overwrite = T, append = F)
rm(il_12)

##################
il_20 <- fread("E:/purges_12_16_20/il/IL-2020-1/Statewide Normalized 1-20_Voters.txt")

colnames(il_20) <- clean_names(il_20)

il_20 <- il_20 %>% 
  select(voter_id = suid,
         last_name = lastname,
         first_name = firstname,
         middle_name = middlename,
         reg_date = registrationdate,
         dob = age,
         gender = sex,
         street = voteaddress,
         city = votecity,
         state = votestate,
         zip = votezip,
         county = jurisdictionid) %>% 
  mutate(reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
         dob = as.character(make_date(2020 - dob)))
il_16$purged <- !(il_16$voter_id %in% il_20$voter_id)
dbWriteTable(db_full, name = "IL_16", value = il_16, overwrite = T, append = F)
dbWriteTable(db_full, name = "IL_20", value = il_20, overwrite = T, append = F)
