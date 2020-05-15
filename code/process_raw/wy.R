cleanup()
wy_12 <- fread("E:/purges_12_16_20/wy/WY-2012-1/Statewide VR File 10-01-12.txt")

colnames(wy_12) <- clean_names(wy_12)

wy_12 <- wy_12 %>% 
  select(voter_id,
         reg_date = registration_date,
         last_name,
         first_name,
         middle_name,
         party = political_party,
         street = details__ra_,
         city = city__ra_,
         zip = zip__ra_,
         county) %>% 
  mutate(party = ifelse(party == "Democratic", "D",
                        ifelse(party == "Republican", "R",
                               ifelse(party == "Unaffiliated", "U", "O"))),
         state = "WY",
         reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")))
##################

wy_16 <- fread("E:/purges_12_16_20/wy/WY Statewide VR File 02-07-16/WY Statewide VR File 02-07-16.csv")

colnames(wy_16) <- clean_names(wy_16)

wy_16 <- wy_16 %>% 
  select(voter_id,
         reg_date = registration_date,
         last_name,
         first_name,
         middle_name,
         party = political_party,
         street = details__ra_,
         city = city__ra_,
         zip = zip__ra_,
         county) %>% 
  mutate(party = ifelse(party == "Democratic", "D",
                        ifelse(party == "Republican", "R",
                               ifelse(party == "Unaffiliated", "U", "O"))),
         state = "WY",
         reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")))

##################

wy_20 <- fread("E:/purges_12_16_20/wy/WY-2020-1/Willsie_Statewide_3-6-20.txt")

colnames(wy_20) <- clean_names(wy_20)

wy_20 <- wy_20 %>% 
  select(voter_id,
         reg_date = registration_date,
         last_name,
         first_name,
         middle_name,
         party = political_party,
         street = details__ra_,
         city = city__ra_,
         zip = zip__ra_,
         county) %>% 
  mutate(party = ifelse(party == "Democratic", "D",
                        ifelse(party == "Republican", "R",
                               ifelse(party == "Unaffiliated", "U", "O"))),
         state = "WY",
         reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")))


#####################

wy_12$purged <- !(wy_12$voter_id %in% wy_16$voter_id)
wy_16$purged <- !(wy_16$voter_id %in% wy_20$voter_id)

dbWriteTable(db_full, name = "WY_12", value = wy_12, overwrite = T, append = F)
dbWriteTable(db_full, name = "WY_16", value = wy_16, overwrite = T, append = F)
dbWriteTable(db_full, name = "WY_20", value = wy_20, overwrite = T, append = F)
