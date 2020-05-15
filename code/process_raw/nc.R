nc_12 <- fread("E:/purges_12_16_20/nc/roll_full_12.csv",
            select = c("county_id", "ncid", "status_cd",
                       "last_name", "first_name", "midl_name",
                       "house_num", "street_dir", "street_name", "street_type_cd",
                       "res_city_desc", "state_cd", "zip_code", "race_code", "ethnic_code",
                       "party_cd", "sex_code", "age", "registr_dt"), fill = T) %>% 
  filter(status_cd %in% c("A", "I"))

nc_12 <- clean_streets(nc_12, c("house_num", "street_dir", "street_name", "street_type_cd"))

nc_12 <- nc_12 %>% 
  mutate(dob = as.character(make_date(year = 2016 - age)),
         race = ifelse(ethnic_code == "HL", "Latino",
                       ifelse(race_code == "W", "White",
                              ifelse(race_code == "B", "Black",
                                     ifelse(race_code == "A", "Asian",
                                            "Other")))),
         party = ifelse(party_cd == "DEM", "D",
                        ifelse(party_cd == "REP", "R",
                               ifelse(party_cd == "UNA", "U", "O"))),
         state = "NC") %>% 
  select(county = county_id,
         voter_id = ncid,
         last_name, first_name, middle_name = midl_name,
         street, city = res_city_desc, zip = zip_code,
         race, party, dob, gender = sex_code, reg_date = registr_dt, state)

#######################################

nc_16 <- fread("E:/purges_12_16_20/nc/roll_full_16.csv",
               select = c("county_id", "ncid", "status_cd",
                          "last_name", "first_name", "midl_name",
                          "house_num", "street_dir", "street_name", "street_type_cd",
                          "res_city_desc", "state_cd", "zip_code", "race_code", "ethnic_code",
                          "party_cd", "sex_code", "age", "registr_dt"), fill = T) %>% 
  filter(status_cd %in% c("A", "I"))

nc_16 <- clean_streets(nc_16, c("house_num", "street_dir", "street_name", "street_type_cd"))

nc_16 <- nc_16 %>% 
  mutate(dob = as.character(make_date(year = 2016 - age)),
         race = ifelse(ethnic_code == "HL", "Latino",
                       ifelse(race_code == "W", "White",
                              ifelse(race_code == "B", "Black",
                                     ifelse(race_code == "A", "Asian",
                                            "Other")))),
         party = ifelse(party_cd == "DEM", "D",
                        ifelse(party_cd == "REP", "R",
                               ifelse(party_cd == "UNA", "U", "O"))),
         state = "NC") %>% 
  select(county = county_id,
         voter_id = ncid,
         last_name, first_name, middle_name = midl_name,
         street, city = res_city_desc, zip = zip_code,
         race, party, dob, gender = sex_code, reg_date = registr_dt, state)

nc_12$purged <- !(nc_12$voter_id %in% nc_16$voter_id)

dbWriteTable(db_full, value = nc_12, name = "NC_12", overwrite = T, append = F)
rm(nc_12)

#######################################

nc_20 <- fread("E:/purges_12_16_20/nc/roll_full_20.csv",
               select = c("county_id", "ncid", "status_cd",
                          "last_name", "first_name", "midl_name",
                          "house_num", "street_dir", "street_name", "street_type_cd",
                          "res_city_desc", "state_cd", "zip_code", "race_code", "ethnic_code",
                          "party_cd", "sex_code", "age", "registr_dt"), fill = T) %>% 
  filter(status_cd %in% c("A", "I"))

nc_20 <- clean_streets(nc_20, c("house_num", "street_dir", "street_name", "street_type_cd"))

nc_20 <- nc_20 %>% 
  mutate(dob = as.character(make_date(year = 2020 - age)),
         race = ifelse(ethnic_code == "HL", "Latino",
                       ifelse(race_code == "W", "White",
                              ifelse(race_code == "B", "Black",
                                     ifelse(race_code == "A", "Asian",
                                            "Other")))),
         party = ifelse(party_cd == "DEM", "D",
                        ifelse(party_cd == "REP", "R",
                               ifelse(party_cd == "UNA", "U", "O"))),
         state = "NC") %>% 
  select(county = county_id,
         voter_id = ncid,
         last_name, first_name, middle_name = midl_name,
         street, city = res_city_desc, zip = zip_code,
         race, party, dob, gender = sex_code, reg_date = registr_dt, state)

nc_16$purged <- !(nc_16$voter_id %in% nc_20$voter_id)

dbWriteTable(db_full, value = nc_16, name = "NC_16", overwrite = T, append = F)
rm(nc_16)

dbWriteTable(db_full, value = nc_20, name = "NC_20", overwrite = T, append = F)
rm(nc_20)

cleanup()
nc_16 <- dbGetQuery(db_full, "select * from NC_16")
nc_20 <- dbGetQuery(db_full, "select * from NC_20")


#### if you move do you keep your id?

inner1 <- inner_join(nc_16, nc_20, by = c("voter_id", "first_name", "last_name", "dob"))
j <- mean(inner1$county.x == inner1$county.y, na.rm = T)
saveRDS(j, "./temp/share_nc_same_id_different_county.rds")
##### can ids be re-assigned?

inner1 <- inner_join(nc_16, nc_20, by = c("voter_id"))
j <- mean(inner1$first_name.x == inner1$first_name.y, na.rm = T)
saveRDS(j, "./temp/share_nc_same_id_same_dob.rds")
######## do invidivuals get new ids?

inner1 <- inner_join(nc_16, nc_20, by = c("first_name", "last_name", "street", "city", "dob"),
                     na_matches = "never")
j <- mean(inner1$voter_id.x != inner1$voter_id.y)
saveRDS(j, "./temp/share_nc_different_id_same_name_street.rds")

j <- mean(filter(inner1, reg_date.x != reg_date.y)$voter_id.x == filter(inner1, reg_date.x != reg_date.y)$voter_id.y)
saveRDS(j, "./temp/share_nc_same_id_street_different_reg_date.rds")

h <- filter(inner1, reg_date.x != reg_date.y)
h$okay <- h$voter_id.x %in% nc_20$voter_id

######### do you get a new reg date always?

inner1 <- inner_join(nc_16, nc_20, by = c("voter_id", "first_name", "street")) %>% 
  filter(last_name.x != last_name.y)

mean(inner1$reg_date.x == inner1$reg_date.y)
## dont get new reg date, so we're good