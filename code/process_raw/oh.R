
files <- list.files("E:/purges_12_16_20/oh/OH-2012-1",
                    full.names = T, recursive = T,
                    pattern  = "*TXT")

oh_12 <- rbindlist(lapply(files, function(f){
  if(f == files[1]){
    inter <- fread(f, select = c(1:16), fill = T)
  }else{
    inter <- fread(f, select = c(1:16))
  }
  
  colnames(inter) <- clean_names(inter)
  inter <- inter %>% 
    select(voter_id = sos_voterid,
           county = county_number,
           last_name, first_name, middle_name,
           dob = year_of_birth,
           reg_date = registration_date,
           street = residential_address1,
           city = residential_city,
           state = residential_state,
           zip = residential_zip,
           party = party_affiliation) %>% 
    mutate(dob = as.character(make_date(dob)),
           reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
           party = ifelse(is.na(party), "U",
                          ifelse(party %in% c("R", "D"), party, "O")))
}), fill = T)
#######################################
files <- list.files("E:/purges_12_16_20/oh/OH-2016-3",
                    full.names = T, recursive = T,
                    pattern  = "*TXT")

oh_16 <- rbindlist(lapply(files, function(f){
  inter <- fread(f)
  
  colnames(inter) <- clean_names(inter)
  inter <- inter %>% 
    select(voter_id = sos_voterid,
           county = county_number,
           last_name, first_name, middle_name,
           dob = date_of_birth,
           reg_date = registration_date,
           street = residential_address1,
           city = residential_city,
           state = residential_state,
           zip = residential_zip,
           party = party_affiliation,
           voter_status) %>% 
    mutate(party = ifelse(is.na(party), "U",
                          ifelse(party %in% c("R", "D"), party, "O")))
}), fill = T)


oh_12$purged <- !(oh_12$voter_id %in% oh_16$voter_id)
dbWriteTable(db_full, name = "OH_12", value = oh_12, overwrite = T, append = F)
rm(oh_12)

#######################################
files <- list.files("E:/purges_12_16_20/oh/OH-2020-1",
                    full.names = T, recursive = T,
                    pattern  = "*txt")

oh_20 <- rbindlist(lapply(files, function(f){
  inter <- fread(f, select = c(1:16), fill = T)
  
  colnames(inter) <- clean_names(inter)
  inter <- inter %>% 
    select(voter_id = sos_voterid,
           county = county_number,
           last_name, first_name, middle_name,
           dob = date_of_birth,
           reg_date = registration_date,
           street = residential_address1,
           city = residential_city,
           state = residential_state,
           zip = residential_zip,
           party = party_affiliation,
           voter_status) %>% 
    mutate(party = ifelse(is.na(party), "U",
                          ifelse(party %in% c("R", "D"), party, "O")))
}), fill = T)

oh_16$purged <- !(oh_16$voter_id %in% oh_20$voter_id)
dbWriteTable(db_full, name = "OH_16", value = oh_16, overwrite = T, append = F)
dbWriteTable(db_full, name = "OH_20", value = oh_20, overwrite = T, append = F)
