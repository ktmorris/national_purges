files <- list.files("E:/purges_12_16_20/ok/OK-2012-1",
                    pattern = "VR .*", full.names = T)


ok_12 <- rbindlist(lapply(files, function(f){
  inter <- read_csv2(f)[, c(1:17)]
  
  colnames(inter) <- c("x1", "last_name", "first_name", "middle_name",
                       "x2", "voter_id", "party", "x3",
                       "house_no", "street_dir", "street_name",
                       "street_type", "x4", "city", "zip",
                       "dob", "reg_date")
  
  inter <- clean_streets(inter, c("house_no", "street_dir", "street_name",
                                  "street_type")) %>% 
    select(-starts_with("x")) %>% 
    mutate(party = ifelse(party %in% c("DEM", "REP"), substring(party, 1, 1), "U")) %>% 
    mutate_at(vars(dob, reg_date), ~ as.character(as.Date(as.character(.), "%Y%m%d")))
}))
#####################
files <- list.files("E:/purges_12_16_20/ok/OK-2016-20-160813/CDSW_VR_20160815100036",
                    pattern = "CD*", full.names = T)


ok_16 <- rbindlist(lapply(files, function(f){
  inter <- fread(f,
                 select = c("LastName", "FirstName", "MiddleName",
                            "VoterID", "PolitalAff", "StreetNum",
                            "StreetDir", "StreetName", "StreetType",
                            "City", "Zip", "DateOfBirth",
                            "OriginalRegistration"))
  
  colnames(inter) <- clean_names(inter)
  
  inter <- clean_streets(inter, c("streetnum",
                                  "streetdir", "streetname", "streettype")) %>% 
    rename(last_name = lastname,
           first_name = firstname,
           middle_name = middlename,
           voter_id = voterid,
           party = politalaff,
           dob = dateofbirth,
           reg_date = originalregistration) %>% 
    mutate(party = ifelse(party %in% c("DEM", "REP"), substring(party, 1, 1),
                          ifelse(party == "IND", "U", "O"))) %>% 
    mutate_at(vars(dob, reg_date), ~ as.character(as.Date(., "%m/%d/%Y")))
}))


ok_12$purged <- !(ok_12$voter_id %in% ok_16$voter_id)
dbWriteTable(db_full, name = "OK_12", value = ok_12, overwrite = T, append = F)
rm(ok_12)

#####################
files <- list.files("E:/purges_12_16_20/ok/OK-2020-1",
                    pattern = "CD.*vr.csv", full.names = T, recursive = T)


ok_20 <- rbindlist(lapply(files, function(f){
  inter <- fread(f,
                 select = c("LastName", "FirstName", "MiddleName",
                            "VoterID", "PolitalAff", "StreetNum",
                            "StreetDir", "StreetName", "StreetType",
                            "City", "Zip", "DateOfBirth",
                            "OriginalRegistration"))
  
  colnames(inter) <- clean_names(inter)
  
  inter <- clean_streets(inter, c("streetnum",
                                  "streetdir", "streetname", "streettype")) %>% 
    rename(last_name = lastname,
           first_name = firstname,
           middle_name = middlename,
           voter_id = voterid,
           party = politalaff,
           dob = dateofbirth,
           reg_date = originalregistration) %>% 
    mutate(party = ifelse(party %in% c("DEM", "REP"), substring(party, 1, 1),
                          ifelse(party == "IND", "U", "O"))) %>% 
    mutate_at(vars(dob, reg_date), ~ as.character(as.Date(., "%m/%d/%Y")))
}))


ok_16$purged <- !(ok_16$voter_id %in% ok_20$voter_id)
dbWriteTable(db_full, name = "OK_16", value = ok_16, overwrite = T, append = F)
dbWriteTable(db_full, name = "OK_20", value = ok_20, overwrite = T, append = F)
