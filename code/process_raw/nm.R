nm_12 <- read_csv("E:/purges_12_16_20/nm/NM-2012-1/FULLFILE0726.csv")

nm_12 <- nm_12 %>% 
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

nm_12 <- clean_streets(nm_12, c("text_res_address_nbr", "cde_street_dir_prefix",
                                "text_street_name", "cde_street_type")) %>% 
  mutate(party = ifelse(party %in% c("DEMOCRAT", "REPUBLICAN"),
                        substring(party, 1, 1),
                        ifelse(party == "DECLINED TO STATE", "U", "O")),
         dob = as.character(make_date(dob)),
         reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")))

#################
nm_16 <- read_csv("E:/purges_12_16_20/nm/NM-2017-1/NEWMEXICOSTATEWIDE (3).csv") %>% 
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

nm_16 <- clean_streets(nm_16, c("text_res_address_nbr", "cde_street_dir_prefix",
                                "text_street_name", "cde_street_type")) %>% 
  mutate(party = ifelse(party %in% c("DEMOCRAT", "REPUBLICAN"),
                        substring(party, 1, 1),
                        ifelse(party == "DECLINED TO STATE", "U", "O")),
         dob = as.character(make_date(dob)),
         reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")))

nm_12$purged <- !(nm_12$voter_id %in% nm_16$voter_id)
#################
nm_20 <- read_tsv("E:/purges_12_16_20/nm/NM-2020-1/voterfile_list_current_20200227/voter_extract.txt")

colnames(nm_20) <- clean_names(nm_20)

nm_20 <- nm_20 %>% 
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

nm_20 <- clean_streets(nm_20, c("ra_hs_num", "ra_stdir_code", "ra_street_name", "ra_sttype",
                                "ra_stdir_code_post")) %>% 
  mutate_at(vars(dob, reg_date), ~ as.character(as.Date(., "%m/%d/%Y")))

