cleanup()

files <- list.files("E:/purges_12_16_20/al/AL-2012-1",
                    pattern = "*.txt", full.names = T)

al_12 <- rbindlist(lapply(files, fread))

al_12 <- al_12 %>% 
  select(last_name = V14,
         middle_name = V16,
         first_name = V15,
         street_no = V23,
         street_name = V20,
         city = V26,
         state = V27,
         zip = V28,
         gender = V56,
         voter_id = V55,
         dob = V57,
         reg_date = V59) %>% 
  mutate_at(vars("dob", "reg_date"),
            ~ str_pad(., width = 6, side = "left", pad = "0")) %>% 
  mutate_at(vars("dob", "reg_date"),
            ~ as.character(make_date(year = ifelse(substring(., 5) < 20,
                                      paste0("20", substring(., 5)),
                                      paste0("19", substring(., 5))),
                        month = substring(., 1, 2),
                        day = substring(., 3, 4))))

al_12 <- clean_streets(al_12, c("street_no", "street_name"))

###############################

al_16m <- fread("E:/purges_12_16_20/al/AL-2017-1/AL-2017-1/AL-Alabama/AL 122316 M.csv")
colnames(al_16m) <- clean_names(al_16m)
al_16f <- fread("E:/purges_12_16_20/al/AL-2017-1/AL-2017-1/AL-Alabama/AL 122316 F.csv")
colnames(al_16f) <- colnames(al_16m)

al_16 <- rbind(al_16m, al_16f)
rm(al_16m, al_16f)

al_16 <- al_16 %>% 
  select(county,
         last_name,
         first_name,
         middle_name,
         dob = date_of_birth,
         reg_date = date_of_registration,
         race,
         gender,
         voter_id = registrant_id,
         street = residential_address,
         city = residential_city,
         state = residential_state,
         zip = residential_zip) %>% 
  mutate_at(vars(reg_date, dob),
            ~ as.character(as.Date(., "%m/%d/%Y")))

al_12$purged <- !(al_12$voter_id %in% al_16$voter_id)
dbWriteTable(db_full, value = al_12, name = "AL_12", overwrite = T, append = F)
rm(al_12)

############################