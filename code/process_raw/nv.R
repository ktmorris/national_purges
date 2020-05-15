cleanup()

nv_12 <- fread("E:/purges_12_16_20/nv/NV-2012-1/VoterList.ElgbVtr.12416.010412104857.txt")

h <- (fread("D:/rolls/nevada/colnames.csv", header = F) %>% 
  filter(V2 == "snapshot"))[,1]

colnames(nv_12) <- h
colnames(nv_12) <- clean_names(nv_12)

nv_12 <- nv_12 %>% 
  mutate(dob = as.character(as.Date(birth_date, "%m/%d/%Y")),
         reg_date = as.character(as.Date(registration_date, "%m/%d/%Y")),
         party = ifelse(party == "Democrat", "D",
                        ifelse(party == "Republican", "R",
                               ifelse(party == "Non-Partisan", "U", "O")))) %>% 
  select(street = address_1,
         voter_id = voterid,
         dob,
         first_name,
         middle_name,
         last_name,
         reg_date,
         party,
         county,
         city,
         state,
         zip)

###########

nv_16 <- fread("E:/purges_12_16_20/nv/NV-2016-3/VoterList.ElgbVtr.35626.100316143048.txt")

h <- (fread("D:/rolls/nevada/colnames.csv", header = F) %>% 
        filter(V2 == "snapshot"))[,1]

colnames(nv_16) <- h
colnames(nv_16) <- clean_names(nv_16)

nv_16 <- nv_16 %>% 
  mutate(dob = as.character(as.Date(birth_date, "%m/%d/%Y")),
         reg_date = as.character(as.Date(registration_date, "%m/%d/%Y")),
         party = ifelse(party == "Democrat", "D",
                        ifelse(party == "Republican", "R",
                               ifelse(party == "Non-Partisan", "U", "O")))) %>% 
  select(street = address_1,
         voter_id = voterid,
         dob,
         first_name,
         middle_name,
         last_name,
         reg_date,
         party,
         county,
         city,
         state,
         zip)

nv_12$purged <- !(nv_12$voter_id %in% nv_16$voter_id)
dbWriteTable(db_full, value = nv_12, name = "NV_12", overwrite = T, append = F)
###########

nv_20 <- fread("E:/purges_12_16_20/nv/NV-2020-1/VoterList.ElgbVtr.37214.010320134415.txt")

h <- (fread("D:/rolls/nevada/colnames.csv", header = F) %>% 
        filter(V2 == "snapshot"))[,1]

colnames(nv_20) <- h
colnames(nv_20) <- clean_names(nv_20)

nv_20 <- nv_20 %>% 
  mutate(dob = as.character(as.Date(birth_date, "%m/%d/%Y")),
         reg_date = as.character(as.Date(registration_date, "%m/%d/%Y")),
         party = ifelse(party == "Democrat", "D",
                        ifelse(party == "Republican", "R",
                               ifelse(party == "Non-Partisan", "U", "O")))) %>% 
  select(street = address_1,
         voter_id = voterid,
         dob,
         first_name,
         middle_name,
         last_name,
         reg_date,
         party,
         county,
         city,
         state,
         zip)

nv_16$purged <- !(nv_16$voter_id %in% nv_20$voter_id)
dbWriteTable(db_full, value = nv_16, name = "NV_16", overwrite = T, append = F)
dbWriteTable(db_full, value = nv_20, name = "NV_20", overwrite = T, append = F)
#### if you move do you keep your id?

inner1 <- inner_join(nv_16, nv_20, by = c("voter_id", "first_name", "last_name", "dob"))
j <- mean(inner1$county.x == inner1$county.y, na.rm = T)
saveRDS(j, "./temp/share_nv_same_id_different_county.rds")
##### can ids be re-assigned?

inner1 <- inner_join(nv_16, nv_20, by = c("voter_id"))
j <- mean(inner1$first_name.x == inner1$first_name.y, na.rm = T)
saveRDS(j, "./temp/share_nv_same_id_same_dob.rds")
######## do invidivuals get new ids?

inner1 <- inner_join(nv_16, nv_20, by = c("first_name", "last_name", "street", "city", "dob"),
                     na_matches = "never")
j <- mean(inner1$voter_id.x != inner1$voter_id.y)
saveRDS(j, "./temp/share_nv_different_id_same_name_street.rds")

j <- mean(filter(inner1, reg_date.x != reg_date.y)$voter_id.x == filter(inner1, reg_date.x != reg_date.y)$voter_id.y)
saveRDS(j, "./temp/share_nv_same_id_street_different_reg_date.rds")

h <- filter(inner1, reg_date.x != reg_date.y)
h$okay <- h$voter_id.x %in% nv_20$voter_id

######### do you get a new reg date always?

inner1 <- inner_join(nv_16, nv_20, by = c("first_name", "street", "dob")) %>% 
  filter(last_name.x != last_name.y)

mean(inner1$reg_date.x == inner1$reg_date.y)
## dont get new reg date, so we're good