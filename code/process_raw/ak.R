cleanup()

ak_12 <- fread("E:/purges_12_16_20/ak/AK-2012-1/PROD-REGION0-G0952V00.txt", fill = T)

names <- c(c("District",
           "Precinct",
           "Ascension Number",
           "Last Name",
           "First Name",
           "Middle Initial",
           "Name Suffix",
           "Original registration date (YYYYMMDD)",
           "Date registered in District (YYYYMMDD)",
           "Registration date (YYYYMMDD)",
           "Private Residence Address Indicator",
           "Residence Address 1",
           "Residence Address 2",
           "Residence Address City",
           "Residence Address State",
           "Residence Address Zip Code + 4 (includes hyphen)",
           "Sex",
           "Party"),
           rep("History", 10),
           c("Mailing Address 1",
           "Mailing Address 2",
           "Mailing Address City",
           "Mailing Address State ",
           "Mailing Address Zip Code + 4 ",
           "Mailing Address Foreign Country",
           "Undeliverable Mailing Address Flag"
))

colnames(ak_12) <- names
colnames(ak_12) <- clean_names(ak_12)

ak_12 <- ak_12 %>% 
  select(party, last_name, first_name, middle_name = middle_initial,
         voter_id = ascension_number,
         reg_date = registration_date__yyyymmdd_,
         street = residence_address_1,
         city = residence_address_city,
         zip = residence_address_zip_code___4__includes_hyphen_,
         gender = sex) %>% 
  mutate(reg_date = as.character(as.Date(as.character(reg_date), "%Y%m%d")),
         party = ifelse(party %in% c("D", "R", "U"), party, "O"))

##########################

ak_16 <- fread("E:/purges_12_16_20/ak/AK-2017-1/AK-2017-1/VOTERS LIST REPORT (16).csv", fill = T)

colnames(ak_16) <- clean_names(ak_16)

ak_16 <- ak_16 %>% 
  select(party, last_name, first_name, middle_name,
         voter_id = ascension__, reg_date,
         street = residence_address,
         city = residence_city,
         zip = residence_zip,
         gender) %>% 
  mutate(reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
         party = ifelse(party %in% c("D", "R", "U"), party, "O"))


ak_12$purged <- !(ak_12$voter_id %in% ak_16$voter_id)
dbWriteTable(db_full, name = "AK_12", value = ak_12, overwrite = T, append = F)
rm(ak_12)

##########################

ak_20 <- fread("E:/purges_12_16_20/ak/AK-2019-2/VOTERS LIST REPORT 6.12.19.csv", fill = T)

colnames(ak_20) <- clean_names(ak_20)

ak_20 <- ak_20 %>% 
  select(party, last_name, first_name, middle_name,
         voter_id = ascension__, reg_date,
         street = residence_address,
         city = residence_city,
         zip = residence_zip,
         gender) %>% 
  mutate(reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
         party = ifelse(party %in% c("D", "R", "U"), party, "O"))


ak_16$purged <- !(ak_16$voter_id %in% ak_20$voter_id)
dbWriteTable(db_full, name = "AK_16", value = ak_16, overwrite = T, append = F)
dbWriteTable(db_full, name = "AK_20", value = ak_20, overwrite = T, append = F)


#### if you move do you keep your id?

inner1 <- inner_join(ak_16, ak_20, by = c("voter_id", "first_name", "last_name"))
j <- mean(inner1$city.x == inner1$city.y)
saveRDS(j, "./temp/share_ak_same_id_different_city.rds")
##### can ids be re-assigned?

inner1 <- inner_join(ak_16, ak_20, by = c("voter_id"))
j <- mean(inner1$last_name.x == inner1$last_name.y, na.rm = T)
saveRDS(j, "./temp/share_ak_same_id_different_last_name.rds")
######## do invidivuals get new ids?

inner1 <- inner_join(ak_16, ak_20, by = c("first_name",
                                          "last_name", "street", "city"))
j <- mean(inner1$voter_id.x == inner1$voter_id.y)
saveRDS(j, "./temp/share_ak_different_id_same_name_street.rds")

j <- mean(filter(inner1, reg_date.x != reg_date.y)$voter_id.x == filter(inner1, reg_date.x != reg_date.y)$voter_id.y)
saveRDS(j, "./temp/share_ak_same_id_street_different_reg_date.rds")
