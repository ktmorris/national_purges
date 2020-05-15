cleanup()

files <- list.files("E:/purges_12_16_20/co/CO-2012-1", full.names = T,
                    pattern = "*Detail*")

co_12 <- rbindlist(lapply(files, function(c){
  j <- fread(c)
  
  colnames(j) <- clean_names(j)
  
  j <- j %>% 
    select(voter_id,
           county,
           first_name,
           middle_name,
           last_name,
           reg_date = registration_date,
           street = residential_address,
           city = residential_city,
           state = residential_state,
           zip1 = residential_zip_code,
           zip2 = residential_zip_plus,
           party,
           gender,
           dob = birth_year)
  
  j <- j %>% 
    mutate(zip = paste0(zip1, ifelse(is.na(zip2), "", zip2)),
           party = ifelse(party == "DEM", "D",
                          ifelse(party == "REP", "R",
                                 ifelse(party == "UAF", "U", "O"))),
           reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
           dob = as.character(make_date(year = dob))) %>% 
    select(-zip1, -zip2)
}), fill = T)


###################
co_16 <- fread("E:/purges_12_16_20/co/CO-2017-1/CO-2017-1/Registered_Voters_List_Merged.txt")

colnames(co_16) <- clean_names(co_16)

co_16 <- co_16 %>% 
  select(voter_id,
         county,
         first_name,
         middle_name,
         last_name,
         reg_date = registration_date,
         street = residential_address,
         city = residential_city,
         state = residential_state,
         zip1 = residential_zip_code,
         zip2 = residential_zip_plus,
         party,
         gender,
         dob = birth_year)
  
co_16 <- co_16 %>% 
  mutate(zip = paste0(zip1, ifelse(is.na(zip2), "", zip2)),
         party = ifelse(party == "DEM", "D",
                        ifelse(party == "REP", "R",
                               ifelse(party == "UAF", "U", "O"))),
         reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
         dob = as.character(make_date(year = dob))) %>% 
  select(-zip1, -zip2)


co_12$purged <- !(co_12$voter_id %in% co_16$voter_id)
dbWriteTable(db_full, name = "CO_12", value = co_12, overwrite = T, append = F)
rm(co_12)

###################

files <- list.files("E:/purges_12_16_20/co/CO-2020-1/",
                    recursive = T, pattern = "Registered_Voters_List_Public_ Part.*txt",
                    full.names = T)

co_20 <- rbindlist(lapply(files, function(f){
  j <- fread(f, fill = T)
  colnames(j) <- clean_names(j)
  
  j <- j %>% 
    select(voter_id,
           county,
           first_name,
           middle_name,
           last_name,
           reg_date = registration_date,
           street = residential_address,
           city = residential_city,
           state = residential_state,
           zip1 = residential_zip_code,
           zip2 = residential_zip_plus,
           party,
           gender,
           dob = birth_year)
  
  j <- j %>% 
    mutate(zip = paste0(zip1, ifelse(is.na(zip2), "", zip2)),
           party = ifelse(party == "DEM", "D",
                          ifelse(party == "REP", "R",
                                 ifelse(party == "UAF", "U", "O"))),
           reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
           dob = as.character(make_date(year = dob))) %>% 
    select(-zip1, -zip2)
}))


co_16$purged <- !(co_16$voter_id %in% co_20$voter_id)
dbWriteTable(db_full, name = "CO_16", value = co_16, overwrite = T, append = F)
dbWriteTable(db_full, name = "CO_20", value = co_20, overwrite = T, append = F)

