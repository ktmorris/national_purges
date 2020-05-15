ms_12 <- read_csv("E:/purges_12_16_20/ms/ms_12/2 16 2012.csv")

colnames(ms_12) <- clean_names(ms_12)

ms_12 <- ms_12 %>% 
  select(voter_id,
         first_name,
         middle_name,
         last_name,
         street = residential_address,
         city = res_city,
         state = res_state,
         zip = res_zip_code,
         county = res_county,
         party,
         reg_date = effective_regn_date) %>% 
  mutate(reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")))

#############
ms_16 <- read_csv("E:/purges_12_16_20/ms/ms_16/Statewide Voter Extract 2 10 2016.csv")

colnames(ms_16) <- clean_names(ms_16)

ms_16 <- ms_16 %>% 
  select(voter_id,
         first_name,
         middle_name,
         last_name,
         street = residential_address,
         city = res_city,
         state = res_state,
         zip = res_zip_code,
         county = res_county,
         reg_date = effective_regn_date) %>% 
  mutate(reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")))

ms_12$purged <- !(ms_12$voter_id %in% ms_16$voter_id)

dbWriteTable(db_full, value = ms_12, name = "MS_12", overwrite = T, append = F)
