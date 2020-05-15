cleanup()

vt_12 <- fread("E:/purges_12_16_20/vt/VT-2012-1/Voter File 7-18-2012.TXT")

colnames(vt_12) <- clean_names(vt_12)

vt_12 <- vt_12 %>% 
  select(voter_id = voterid,
         last_name = lastname,
         first_name = firstname,
         middle_name = middleinitial,
         street = mailaddr1,
         city = mailcity,
         state = mailstate,
         zip = mailzip,
         dob = birthyear,
         reg_date = regdate) %>% 
  mutate(dob = as.character(make_date(year = dob)),
         reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")))

##############
vt_16 <- fread("E:/purges_12_16_20/vt/VT-2016-All/10.31.2016 Vermont Voter File/10.31.2016 Vermont Voter File.txt")

colnames(vt_16) <- clean_names(vt_16)

vt_16 <- vt_16 %>% 
  select(voter_id = voterid,
         last_name,
         first_name,
         middle_name,
         street = legal_address_line_1,
         city = legal_address_city,
         state = legal_address_state,
         zip = legal_address_zip,
         dob = year_of_birth,
         reg_date = date_of_registration) %>% 
  mutate(dob = as.character(make_date(year = dob)),
         reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")))


vt_12$purged <- !(vt_12$voter_id %in% vt_16$voter_id)
dbWriteTable(db_full, name = "VT_12", value = vt_12, overwrite = T, append = F)

##############
vt_20 <- fread("E:/purges_12_16_20/vt/VT-2020-1/Statewidevoters 2.14.2020.txt")

colnames(vt_20) <- clean_names(vt_20)

vt_20 <- vt_20 %>% 
  select(voter_id = voterid,
         last_name,
         first_name,
         middle_name,
         street = legal_address_line_1,
         city = legal_address_city,
         state = legal_address_state,
         zip = legal_address_zip,
         dob = year_of_birth,
         reg_date = date_of_registration) %>% 
  mutate(dob = as.character(make_date(year = dob)),
         reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")))

vt_16$purged <- !(vt_16$voter_id %in% vt_20$voter_id)
dbWriteTable(db_full, name = "VT_16", value = vt_16, overwrite = T, append = F)
dbWriteTable(db_full, name = "VT_20", value = vt_20, overwrite = T, append = F)