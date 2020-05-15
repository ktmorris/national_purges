
wa_121 <- read_tsv("E:/purges_12_16_20/wa/WA-2012-1/DelimitedVoterExtract_Active.txt")
wa_122 <- read_tsv("E:/purges_12_16_20/wa/WA-2012-1/DelimitedVoterExtract_InActive.txt")

wa_12 <- bind_rows(wa_121, wa_122)
rm(wa_121, wa_122)

wa_12 <- wa_12 %>% 
  select(voter_id = StateVoterID,
         first_name = FName,
         middle_name = MName,
         last_name = LName,
         dob = Birthdate,
         gender = Gender,
         RegStNum, RegStName, RegStType,
         RegStPreDirection, RegStPostDirection,
         city = RegCity,
         state = RegState,
         zip = RegZipCode,
         county = CountyCode,
         reg_date = Registrationdate,
         ) %>% 
  mutate_at(vars(dob, reg_date),
            ~ as.character(as.Date(., "%m/%d/%Y")))

wa_12 <- clean_streets(wa_12, c("RegStNum", "RegStPreDirection", "RegStName",
                                "RegStType", "RegStPostDirection"))

#################

wa_16 <- read_tsv("E:/purges_12_16_20/wa/WA-2016-3/201611_VRDB_Extract.txt")

wa_16 <- wa_16 %>% 
  select(voter_id = StateVoterID,
         first_name = FName,
         middle_name = MName,
         last_name = LName,
         dob = Birthdate,
         gender = Gender,
         RegStNum, RegStName, RegStType,
         RegStPreDirection, RegStPostDirection,
         city = RegCity,
         state = RegState,
         zip = RegZipCode,
         county = CountyCode,
         reg_date = Registrationdate,
  ) %>% 
  mutate_at(vars(dob, reg_date),
            ~ as.character(as.Date(., "%m/%d/%Y")))

wa_16 <- clean_streets(wa_16, c("RegStNum", "RegStPreDirection", "RegStName",
                                "RegStType", "RegStPostDirection"))

wa_12$purged <- !(wa_12$voter_id %in% wa_16$voter_id)
dbWriteTable(db_full, value = wa_12, name = "WA_12", overwrite = T, append = F)
rm(wa_12)
#################

wa_20 <- fread("E:/purges_12_16_20/wa/2020-1/201912_VRDB_Extract.txt", sep = "|")

wa_20 <- wa_20 %>% 
  select(voter_id = StateVoterID,
         first_name = FName,
         middle_name = MName,
         last_name = LName,
         dob = Birthdate,
         gender = Gender,
         RegStNum, RegStName, RegStType,
         RegStPreDirection, RegStPostDirection,
         city = RegCity,
         state = RegState,
         zip = RegZipCode,
         county = CountyCode,
         reg_date = Registrationdate,
  ) %>% 
  mutate_at(vars(dob, reg_date),
            ~ as.character(as.Date(., "%Y-%m-%d")))

wa_20 <- clean_streets(wa_20, c("RegStNum", "RegStPreDirection", "RegStName",
                                "RegStType", "RegStPostDirection"))

wa_20$voter_id <- paste0("WA", str_pad(as.character(wa_20$voter_id), width = 9,
                                       side = "left", pad = "0"))

wa_16$purged <- !(wa_16$voter_id %in% wa_20$voter_id)
dbWriteTable(db_full, value = wa_16, name = "WA_16", overwrite = T, append = F)
dbWriteTable(db_full, value = wa_20, name = "WA_20", overwrite = T, append = F)


#### if you move do you keep your id?

inner1 <- inner_join(wa_16, wa_20, by = c("first_name", "last_name", "dob")) %>% 
  filter(county.x != county.y)
j <- mean(inner1$voter_id.x == inner1$voter_id.y, na.rm = T)
saveRDS(j, "./temp/share_wa_same_id_different_county.rds")
##### can ids be re-assigned?

inner1 <- inner_join(wa_16, wa_20, by = c("voter_id"))
j <- mean(inner1$dob.x == inner1$dob.y, na.rm = T)
saveRDS(j, "./temp/share_wa_same_id_same_dob.rds")
######## do invidivuals get new ids?

inner1 <- inner_join(wa_16, wa_20, by = c("first_name", "last_name", "street", "city", "dob"),
                     na_matches = "never")
j <- mean(inner1$voter_id.x != inner1$voter_id.y)
saveRDS(j, "./temp/share_wa_different_id_same_name_street.rds")

j <- mean(filter(inner1, reg_date.x != reg_date.y)$voter_id.x == filter(inner1, reg_date.x != reg_date.y)$voter_id.y)
saveRDS(j, "./temp/share_wa_same_id_street_different_reg_date.rds")
