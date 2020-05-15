
mt_12 <- read_tsv("E:/purges_12_16_20/mt/MT-2012-1/voter_extract.txt")

colnames(mt_12) <- clean_names(mt_12)

mt_12 <- mt_12 %>% 
  select(voter_id = vtrid,
         first_name = firstname,
         middle_name = middlename,
         last_name = lastname,
         ra_hs_num, ra_street_name, ra_sttype, ra_stdir_code,
         ra_stdir_code_post,
         city = ra_city,
         state = ra_state,
         zip = ra_zip_code,
         dob,
         reg_date = eff_regn_date,
         county = current_county)

mt_12 <- clean_streets(mt_12, c("ra_hs_num", "ra_stdir_code", "ra_street_name", "ra_sttype",
                                "ra_stdir_code_post")) %>% 
  mutate_at(vars(dob, reg_date), ~ as.character(as.Date(., "%m/%d/%Y")))

#################
mt_16 <- read_tsv("E:/purges_12_16_20/mt/MT-2017-1/MT-2017-1/MT_2016-12-21_VF.txt")

colnames(mt_16) <- clean_names(mt_16)

mt_16 <- mt_16 %>% 
  select(voter_id = vtrid,
         first_name = firstname,
         middle_name = middlename,
         last_name = lastname,
         ra_hs_num, ra_street_name, ra_sttype, ra_stdir_code,
         ra_stdir_code_post,
         city = ra_city,
         state = ra_state,
         zip = ra_zip_code,
         dob,
         reg_date = vote_eligible_date,
         county = current_county)

mt_16 <- clean_streets(mt_16, c("ra_hs_num", "ra_stdir_code", "ra_street_name", "ra_sttype",
                                "ra_stdir_code_post")) %>% 
  mutate_at(vars(dob, reg_date), ~ as.character(as.Date(., "%m/%d/%Y")))

mt_12$purged <- !(mt_12$voter_id %in% mt_16$voter_id)

dbWriteTable(db_full, value = mt_12, name = "MT_12", overwrite = T, append = F)
rm(mt_12)
#################
mt_20 <- read_tsv("E:/purges_12_16_20/mt/MT-2020-1/voter_extract.txt")

colnames(mt_20) <- clean_names(mt_20)

mt_20 <- mt_20 %>% 
  select(voter_id = vtrid,
         first_name = firstname,
         middle_name = middlename,
         last_name = lastname,
         ra_hs_num, ra_street_name, ra_sttype, ra_stdir_code,
         ra_stdir_code_post,
         city = ra_city,
         state = ra_state,
         zip = ra_zip_code,
         dob,
         reg_date = vote_eligible_date,
         county = current_county)

mt_20 <- clean_streets(mt_20, c("ra_hs_num", "ra_stdir_code", "ra_street_name", "ra_sttype",
                                "ra_stdir_code_post")) %>% 
  mutate_at(vars(dob, reg_date), ~ as.character(as.Date(., "%m/%d/%Y")))

mt_16$purged <- !(mt_16$voter_id %in% mt_20$voter_id)

dbWriteTable(db_full, value = mt_16, name = "MT_16", overwrite = T, append = F)
dbWriteTable(db_full, value = mt_20, name = "MT_20", overwrite = T, append = F)
