cn <- fread("E:/purges_12_16_20/pa/columns.csv", header = F, sep = "%")$V1[c(1:30, 152)]

np <- c("NE"	,
        "NF"	,
        "NI"	,
        "NO"	,
        "NODE",
        "NON"	,
        "NOP"	,
        "NOPA",
        "NPA"	,
        "NPF")

##################
files <- list.files("E:/purges_12_16_20/pa/PA-2012-1/Voter Export Files",
                    full.name = T)

pa_12 <- rbindlist(lapply(files, function(f){
  inter <- fread(f, select = c(1:30, 152))
  
  colnames(inter) <- cn
  colnames(inter) <- clean_names(inter)
  
  inter <- clean_streets(inter, c("house_number", "street_name")) %>% 
    select(voter_id = id_number,
           last_name, first_name, middle_name,
           gender, dob, reg_date = registration_date,
           party = party_code,
           street,
           city,
           state,
           zip,
           county,
           old_voter_id = legacy_system_id_number) %>% 
    mutate_at(vars(dob, reg_date), ~ as.character(as.Date(., "%m/%d/%Y"))) %>% 
    mutate(party = ifelse(party %in% c("R", "D"), party,
                          ifelse(party %in% np, "U", "O")),
           zip = str_pad(zip, width = 5, side = "left", pad = "0"))
}))

##################
files <- list.files("E:/purges_12_16_20/pa/PA-2016-3/Voter Export Files",
                    full.name = T)

pa_16 <- rbindlist(lapply(files, function(f){
  inter <- fread(f, select = c(1:30, 152))
  
  colnames(inter) <- cn
  colnames(inter) <- clean_names(inter)
  
  inter <- clean_streets(inter, c("house_number", "street_name")) %>% 
    select(voter_id = id_number,
           last_name, first_name, middle_name,
           gender, dob, reg_date = registration_date,
           party = party_code,
           street,
           city,
           state,
           zip,
           county,
           old_voter_id = legacy_system_id_number) %>% 
    mutate_at(vars(dob, reg_date), ~ as.character(as.Date(., "%m/%d/%Y"))) %>% 
    mutate(party = ifelse(party %in% c("R", "D"), party,
                          ifelse(party %in% np, "U", "O")),
           zip = str_pad(zip, width = 5, side = "left", pad = "0"))
}))

pa_12$purged <- !(pa_12$voter_id %in% pa_16$voter_id)
dbWriteTable(db_full, value = pa_12, name = "PA_12", overwrite = T, append = F)
rm(pa_12)
##################
files <- list.files("E:/purges_12_16_20/pa/PA-2020-1",
                    full.name = T, pattern = "*FVE*")

pa_20 <- rbindlist(lapply(files, function(f){
  inter <- fread(f, select = c(1:30, 152))
  
  colnames(inter) <- cn
  colnames(inter) <- clean_names(inter)
  
  inter <- clean_streets(inter, c("house_number", "street_name")) %>% 
    select(voter_id = id_number,
           last_name, first_name, middle_name,
           gender, dob, reg_date = registration_date,
           party = party_code,
           street,
           city,
           state,
           zip,
           county,
           old_voter_id = legacy_system_id_number) %>% 
    mutate_at(vars(dob, reg_date), ~ as.character(as.Date(., "%m/%d/%Y"))) %>% 
    mutate(party = ifelse(party %in% c("R", "D"), party,
                          ifelse(party %in% np, "U", "O")),
           zip = str_pad(zip, width = 5, side = "left", pad = "0"),
           old_voter_id = as.character(old_voter_id))
  return(inter)
}))


pa_16$purged <- !(pa_16$voter_id %in% pa_20$voter_id)
dbWriteTable(db_full, value = pa_16, name = "PA_16", overwrite = T, append = F)
dbWriteTable(db_full, value = pa_20, name = "PA_20", overwrite = T, append = F)