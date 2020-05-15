cleanup()

dc_12 <- fread("E:/purges_12_16_20/dc/DC-2012-1/VOTERS.txt")

colnames(dc_12) <- clean_names(dc_12)

dc_12 <- clean_streets(dc_12, c("res_house", "res_frac",
                                "res_street")) %>% 
  mutate(reg_date = as.character(as.Date(registered, "%m/%d/%Y")),
         party = ifelse(party == "DEMOCRATIC", "D",
                        ifelse(party == "REPUBLICAN", "R",
                               ifelse(party == "NO PARTY", "U", "O"))),
         state = "DC") %>% 
  select(reg_date,
         last_name = lastname,
         first_name = firstname,
         middle_name = middle,
         party,
         city = res_city,
         zip = res_zip,
         state, voter_id)
########################
dc_16 <- fread("E:/purges_12_16_20/dc/DC-2017-1/VOTERS.txt")

colnames(dc_16) <- clean_names(dc_16)

dc_16 <- clean_streets(dc_16, c("res_house", "res_frac",
                                "res_street")) %>% 
  mutate(reg_date = as.character(as.Date(registered, "%m/%d/%Y")),
         party = ifelse(party == "DEMOCRATIC", "D",
                        ifelse(party == "REPUBLICAN", "R",
                               ifelse(party == "NO PARTY", "U", "O"))),
         state = "DC") %>% 
  select(reg_date,
         last_name = lastname,
         first_name = firstname,
         middle_name = middle,
         party,
         city = res_city,
         zip = res_zip,
         state, voter_id)

##########################

dc_20 <- fread("E:/purges_12_16_20/dc/DC-2020-1/INVoter.txt")
colnames(dc_20) <- 