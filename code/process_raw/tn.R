
tn_12 <- fread("E:/purges_12_16_20/tn/TN-2013-1/AESVRTable.csv")

colnames(tn_12) <- clean_names(tn_12)

tn_12 <- tn_12 %>% 
  select(county, voter_id = voterid,
         regyear, regmonth, regday,
         birthyear, birthmonth, birthday,
         gender, race, last_name = lastname,
         first_name = firstname, middle_name = middlename,
         street = resaddress1,
         city = rescity, state = resstate,
         zip = reszip1) %>% 
  mutate(dob = as.character(make_date(birthyear, birthmonth, birthday)),
         reg_date = as.character(make_date(regyear, regmonth, regday))) %>% 
  select(-regyear, -regmonth, -regday,
         -birthyear, -birthmonth, -birthday)

################
tn_16 <- fread("E:/purges_12_16_20/tn/TN-2017-1/TN-2017-1/tn_vf_2017-01-07.csv")

colnames(tn_16) <- clean_names(tn_16)

tn_16 <- tn_16 %>% 
  select(county, voter_id = voterid,
         regyear, regmonth, regday,
         birthyear, birthmonth, birthday,
         gender, race, last_name = lastname,
         first_name = firstname, middle_name = middlename,
         street = resaddress1,
         city = rescity, state = resstate,
         zip = reszip1) %>% 
  mutate(dob = as.character(make_date(birthyear, birthmonth, birthday)),
         reg_date = as.character(make_date(regyear, regmonth, regday))) %>% 
  select(-regyear, -regmonth, -regday,
         -birthyear, -birthmonth, -birthday)

################
tn_16 <- fread("E:/purges_12_16_20/tn/TN-2017-1/TN-2017-1/tn_vf_2017-01-07.csv")

colnames(tn_16) <- clean_names(tn_16)

tn_16 <- tn_16 %>% 
  select(county, voter_id = voterid,
         regyear, regmonth, regday,
         birthyear, birthmonth, birthday,
         gender, race, last_name = lastname,
         first_name = firstname, middle_name = middlename,
         street = resaddress1,
         city = rescity, state = resstate,
         zip = reszip1) %>% 
  mutate(dob = as.character(make_date(birthyear, birthmonth, birthday)),
         reg_date = as.character(make_date(regyear, regmonth, regday))) %>% 
  select(-regyear, -regmonth, -regday,
         -birthyear, -birthmonth, -birthday)

tn_12$purged <- !(tn_12$voter_id %in% tn_16$voter_id)
write_db(tn_12)
rm(tn_12)
