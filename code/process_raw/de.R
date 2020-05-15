de_12 <- fread("E:/purges_12_16_20/de/DE-2012-1/ActiveReg.txt")

colnames(de_12) <- clean_names(de_12)

de_12 <- de_12 %>% 
  select(voter_id = unique_id,
         last_name,
         first_name,
         middle_name = mid_init,
         dob = year_of_birth,
         home_no, home_street,
         city = home_city,
         zip = home_zipcode,
         county,
         reg_date = date_reg,
         party)

de_12 <- clean_streets(de_12, c("home_no", "home_street")) %>% 
  mutate(party = ifelse(party %in% c("D", "R"), party,
                        ifelse(party == "I", "U", "O")),
         dob = as.character(make_date(year = dob)),
         reg_date = as.character(as.Date(as.character(reg_date), "%Y%m%d")))

#########################
de_17 <- fread("E:/purges_12_16_20/de/DE-2017-1/DE-2017-1/ActiveReg.txt")

colnames(de_17) <- clean_names(de_17)

de_17 <- de_17 %>% 
  select(voter_id = unique_id,
         last_name,
         first_name,
         middle_name = mid_init,
         dob = year_of_birth,
         home_no, home_street,
         city = home_city,
         zip = home_zipcode,
         county,
         reg_date = date_reg,
         party)

de_17 <- clean_streets(de_17, c("home_no", "home_street")) %>% 
  mutate(party = ifelse(party %in% c("D", "R"), party,
                        ifelse(party == "I", "U", "O")),
         dob = as.character(make_date(year = dob)),
         reg_date = as.character(as.Date(as.character(reg_date), "%Y%m%d")))
