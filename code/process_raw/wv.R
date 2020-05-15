

wv_12 <- fread("E:/purges_12_16_20/wv/WV-2012-1/voter_complete_072412.txt")
colnames(wv_12) <- clean_names(wv_12)

wv_12 <- clean_streets(wv_12, c("house_no", "street")) %>% 
  mutate(reg_date = as.character(as.Date(registration_date, "%m/%d/%Y")),
         party = ifelse(grepl("Democrat", partyaffiliation), "D",
                        ifelse(grepl("Republican", partyaffiliation), "R",
                               ifelse(partyaffiliation == "No Party Affiliation", "U", "O"))),
         dob = as.character(as.Date(substring(date_of_birth, 1, 10), "%m/%d/%Y"))) %>% 
  select(reg_date, party, dob, first_name, middle_name = mid, last_name,
         street, city, zip, state, county = county_name,
         voter_id = id_voter)

#########

wv_16 <- fread("E:/purges_12_16_20/wv/wv_voter_090916/voter_data_090916.txt", sep = "|", quote = "",
               select = c("id_voter", "County_Name", "FIRST_NAME", "MIDDLE_NAME", "LAST_NAME",
                          "DATE_OF_BIRTH", "SEX", "HOUSE_NO", "STREET", "CITY", "STATE",
                          "ZIP", "REGISTRATION_DATE", "PartyAffiliation"))
colnames(wv_16) <- clean_names(wv_16)

wv_16 <- clean_streets(wv_16, c("house_no", "street")) %>% 
  mutate(reg_date = as.character(as.Date(registration_date, "%m/%d/%Y")),
         party = ifelse(grepl("Democrat", partyaffiliation), "D",
                        ifelse(grepl("Republican", partyaffiliation), "R",
                               ifelse(partyaffiliation == "No Party Affiliation", "U", "O"))),
         dob = as.character(as.Date(substring(date_of_birth, 1, 10), "%m/%d/%Y"))) %>% 
  select(reg_date, party, dob, first_name, middle_name, last_name,
         street, city, zip, state, county = county_name,
         voter_id = id_voter, gender = sex)

wv_12$purged <- !(wv_12$voter_id %in% wv_16$voter_id)
dbWriteTable(db_full, value = wv_12, name = "WV_12", overwrite = T, append = F)
rm(wv_12)

################
#########

wv_20 <- fread("E:/purges_12_16_20/wv/WV-2020-1/Statewide_VR030420.txt", sep = "|")
colnames(wv_20) <- clean_names(wv_20)

wv_20 <- clean_streets(wv_20, c("house_no", "street")) %>% 
  mutate(reg_date = as.character(as.Date(registration_date, "%m/%d/%Y")),
         party = ifelse(grepl("Democrat", partyaffiliation), "D",
                        ifelse(grepl("Republican", partyaffiliation), "R",
                               ifelse(partyaffiliation == "No Party Affiliation", "U", "O"))),
         dob = as.character(as.Date(substring(date_of_birth, 1, 10), "%m/%d/%Y"))) %>% 
  select(reg_date, party, dob, first_name, middle_name = mid, last_name,
         street, city, zip, state, county = county_name,
         voter_id = id_voter, gender = sex)

wv_16$purged <- !(wv_16$voter_id %in% wv_20$voter_id)
dbWriteTable(db_full, value = wv_16, name = "WV_16", overwrite = T, append = F)
dbWriteTable(db_full, value = wv_20, name = "WV_20", overwrite = T, append = F)

#### if you move do you keep your id?

inner1 <- inner_join(wv_12, wv_16, by = c("first_name", "last_name", "dob")) %>% 
  filter(county.x != county.y)
j <- mean(inner1$voter_id.x == inner1$voter_id.y, na.rm = T)
saveRDS(j, "./temp/share_wv_same_id_different_county.rds")
##### can ids be re-assigned?

inner1 <- inner_join(wv_12, wv_16, by = c("voter_id"))
j <- mean(inner1$dob.x == inner1$dob.y, na.rm = T)
saveRDS(j, "./temp/share_wv_same_id_same_dob.rds")
######## do invidivuals get new ids?

inner1 <- inner_join(wv_12, wv_16, by = c("first_name", "last_name", "street", "city", "dob"),
                     na_matches = "never")
j <- mean(inner1$voter_id.x != inner1$voter_id.y)
saveRDS(j, "./temp/share_wv_different_id_same_name_street.rds")

j <- mean(filter(inner1, reg_date.x != reg_date.y)$voter_id.x == filter(inner1, reg_date.x != reg_date.y)$voter_id.y)
saveRDS(j, "./temp/share_wv_same_id_street_different_reg_date.rds")

h <- filter(inner1, reg_date.x != reg_date.y)
h$okay <- h$voter_id.x %in% wv_16$voter_id
mean(h$okay)
######### do you get a new reg date always?

inner1 <- inner_join(wv_12, wv_16, by = c("voter_id", "first_name", "street", "dob")) %>% 
  filter(last_name.x != last_name.y)

mean(inner1$reg_date.x == inner1$reg_date.y)
## dont get new reg date, so we're good