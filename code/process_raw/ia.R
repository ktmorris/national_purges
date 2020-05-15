cleanup()

files <- list.files("E:/purges_12_16_20/ia/IA-2012-1",
                    full.names = T)

h <- clean_names(fread(files[1], nrows = 1))[1:33]

ia_12 <- rbindlist(lapply(files, function(file){
  
  if(grepl("Part1", file)){
    j <- read_csv(file)
    j <- j[, 1:33]
    colnames(j) <- h
  }else{
    j <- read_csv(file, col_names = F)
    j <- j[, 1:33]
    colnames(j) <- h[1:ncol(j)]
  }
  
  j <- clean_streets(j, c("house_num", "house_suffix", "pre_dir",
                          "street_name", "street_type", "post_dir")) %>% 
    mutate(reg_date = as.character(as.Date(eff_regn_date, "%m/%d/%Y")),
           dob = as.character(as.Date(birthdate,  "%m/%d/%Y")),
           gender = substring(gender, 1, 1),
           party = ifelse(party == "DEM", "D",
                          ifelse(party == "REP", "R",
                                 ifelse(party == "NP", "U", "O"))),
           state = "IA") %>% 
    select(reg_date, dob, gender, party, county, voter_id = regn_num,
           first_name, middle_name, last_name,
           street, city, state, zip = zip_code)
  
}))

##############################
files <- list.files("E:/purges_12_16_20/ia/IA-2017-1/IA-2017-1",
                    full.names = T, pattern = "VoterDe*")

h <- clean_names(fread(files[1], nrows = 1))[1:33]

ia_16 <- rbindlist(lapply(files, function(file){
  
  if(grepl("Part1", file)){
    j <- read_csv(file)
    j <- j[, 1:33]
    colnames(j) <- h
  }else{
    j <- read_csv(file, col_names = F)
    j <- j[, 1:33]
    colnames(j) <- h[1:ncol(j)]
  }
  
  j <- clean_streets(j, c("house_num", "house_suffix", "pre_dir",
                          "street_name", "street_type", "post_dir")) %>% 
    mutate(reg_date = as.character(as.Date(eff_regn_date, "%m/%d/%Y")),
           dob = as.character(as.Date(birthdate,  "%m/%d/%Y")),
           gender = substring(gender, 1, 1),
           party = ifelse(party == "DEM", "D",
                          ifelse(party == "REP", "R",
                                 ifelse(party == "NP", "U", "O"))),
           state = "IA") %>% 
    select(reg_date, dob, gender, party, county, voter_id = regn_num,
           first_name, middle_name, last_name,
           street, city, state, zip = zip_code)
  
}))

ia_12$purged <- !(ia_12$voter_id %in% ia_16$voter_id)
dbWriteTable(db_full, name = "IA_12", value = ia_12, overwrite = T, append = F)
rm(ia_12)

##############################
files <- list.files("E:/purges_12_16_20/ia/IA-2019-2/Statewide EX-005 5-13-2019/Statewide EX-005 5-13-2019",
                    full.names = T, pattern = "VoterDe*")

h <- clean_names(fread(files[1], nrows = 1))[1:33]

ia_20 <- rbindlist(lapply(files, function(file){
  
  if(grepl("Part1", file)){
    j <- read_csv(file)
    j <- j[, 1:33]
    colnames(j) <- h
  }else{
    j <- read_csv(file, col_names = F)
    j <- j[, 1:33]
    colnames(j) <- h[1:ncol(j)]
  }
  
  j <- clean_streets(j, c("house_num", "house_suffix", "pre_dir",
                          "street_name", "street_type", "post_dir")) %>% 
    mutate(reg_date = as.character(as.Date(eff_regn_date, "%m/%d/%Y")),
           dob = as.character(as.Date(birthdate,  "%m/%d/%Y")),
           gender = substring(gender, 1, 1),
           party = ifelse(party == "DEM", "D",
                          ifelse(party == "REP", "R",
                                 ifelse(party == "NP", "U", "O"))),
           state = "IA") %>% 
    select(reg_date, dob, gender, party, county, voter_id = regn_num,
           first_name, middle_name, last_name,
           street, city, state, zip = zip_code)
  
}))

ia_16$purged <- !(ia_16$voter_id %in% ia_20$voter_id)
dbWriteTable(db_full, name = "IA_16", value = ia_16, overwrite = T, append = F)
dbWriteTable(db_full, name = "IA_20", value = ia_20, overwrite = T, append = F)
#cleanup()

#### if you move do you keep your id?

inner1 <- inner_join(ia_16, ia_20, by = c("voter_id", "first_name", "last_name", "dob"))
j <- mean(inner1$county.x == inner1$county.y)
saveRDS(j, "./temp/share_ia_same_id_different_county.rds")
##### can ids be re-assigned?

inner1 <- inner_join(ia_16, ia_20, by = c("voter_id"))
j <- mean(inner1$dob.x == inner1$dob.y, na.rm = T)
saveRDS(j, "./temp/share_ia_same_id_same_dob.rds")
######## do invidivuals get new ids?

inner1 <- inner_join(ia_16, ia_20, by = c("first_name", "last_name", "street", "city", "dob"),
                     na_matches = "never")
j <- mean(inner1$voter_id.x != inner1$voter_id.y)
saveRDS(j, "./temp/share_ia_different_id_same_name_street.rds")

j <- mean(filter(inner1, reg_date.x != reg_date.y)$voter_id.x == filter(inner1, reg_date.x != reg_date.y)$voter_id.y)
saveRDS(j, "./temp/share_ia_same_id_street_different_reg_date.rds")

h <- filter(inner1, reg_date.x != reg_date.y)
