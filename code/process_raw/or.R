files <- list.files("E:/purges_12_16_20/or/OR-2012-1",
                    pattern = "CD.*reg.txt", full.names = T, recursive = T)


or_12 <- rbindlist(lapply(files, function(f){
  inter <- read_tsv(f)[,1:20]
  
  colnames(inter) <- clean_names(inter)
  
  inter <- clean_streets(inter, c("house_no", "pre_direction", "street_name",
                                  "street_type_code", "post_direction")) %>% 
    select(street,
           voter_id = voterid,
           first_name = firstname,
           middle_name = middlename,
           last_name = lastname,
           city,
           state,
           zip = zipcode,
           reg_date = eff_regn_date,
           party = party_code,
           dob = birth_date) %>% 
    mutate(party = ifelse(party %in% c("DEM", "REP"), substring(party, 1, 1),
                          ifelse(party == "NAV", "U", "O"))) %>% 
    mutate_at(vars(dob, reg_date), ~ as.character(as.Date(., "%m-%d-%Y")))

}))

################
files <- list.files("E:/purges_12_16_20/or/OR-2016-3/StatewideVoterList_October2016_2/VoterList_Oct2016_2",
                    pattern = "*txt", full.names = T, recursive = T)


or_16 <- rbindlist(lapply(files, function(f){
  inter <- read_tsv(f)
  
  colnames(inter) <- clean_names(inter)
  
  inter <- inter %>% 
    select(street = res_address_1,
           voter_id,
           first_name,
           middle_name,
           last_name,
           city,
           state,
           zip = zip_code,
           reg_date = eff_regn_date,
           party = party_code,
           dob = birth_date) %>% 
    mutate(party = ifelse(party %in% c("DEM", "REP"), substring(party, 1, 1),
                          ifelse(party == "NAV", "U", "O"))) %>% 
    mutate_at(vars(dob, reg_date), ~ as.character(as.Date(., "%m-%d-%Y")))
  
}))

or_12$purged <- !(or_12$voter_id %in% or_16$voter_id)
dbWriteTable(db_full, name = "OR_12", value = or_12, overwrite = T, append = F)
rm(or_12)

################
files <- list.files("E:/purges_12_16_20/or/OR-2019-2/Statewide List December 2019/Statewide List December 2019/Statewide List December 2019",
                    pattern = "*txt", full.names = T, recursive = T)
files <- files[!grepl("Readme", files)]

or_20 <- rbindlist(lapply(files, function(f){
  inter <- read_tsv(f)
  
  colnames(inter) <- clean_names(inter)
  
  inter <- inter %>% 
    select(street = res_address_1,
           voter_id,
           first_name,
           middle_name,
           last_name,
           city,
           state,
           zip = zip_code,
           reg_date = eff_regn_date,
           party = party_code,
           dob = birth_date) %>% 
    mutate(party = ifelse(party %in% c("DEM", "REP"), substring(party, 1, 1),
                          ifelse(party == "NAV", "U", "O")),
           dob = as.character(make_date(dob)),
           reg_date = as.character(as.Date(reg_date, "%m-%d-%Y")))
  
}))

or_16$purged <- !(or_16$voter_id %in% or_20$voter_id)
dbWriteTable(db_full, name = "OR_16", value = or_16, overwrite = T, append = F)
dbWriteTable(db_full, name = "OR_20", value = or_20, overwrite = T, append = F)
