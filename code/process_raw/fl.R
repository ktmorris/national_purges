cleanup()
n <- make.names(fread("D:/rolls/florida/colnames.csv", header = F, sep = ",")$V1)

files <- list.files("E:/purges_12_16_20/fl/2012_10/VoterExtract/VoterExtract",
                    pattern = ".txt", full.names = T)

fl_12 <- rbindlist(lapply(files, function(file){
  j <- fread(file)
  colnames(j) <- n[1:37]
  colnames(j) <- clean_names(j)
  j <- j %>% 
    select(county = county_code,
           voter_id,
           first_name = name_first,
           middle_name = name_middle,
           last_name = name_last,
           street = residence_address_line_1,
           city = residence_city,
           zip = residence_zipcode,
           gender,
           race,
           dob = birth_date,
           reg_date = registration_date,
           party = party_affiliation) %>% 
    mutate(race = ifelse(race == 2, "Asian",
                         ifelse(race == 3, "Black",
                                ifelse(race == 4, "Latino",
                                       ifelse(race == 5, "White", "Other")))),
           party = ifelse(party == "DEM", "D",
                      ifelse(party == "REP", "R",
                             ifelse(party == "NPA", "U", "O"))),
           state = "FL",
           reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
           dob = as.character(as.Date(dob, "%m/%d/%Y")))
  return(j)
}))

########################
files <- list.files("E:/purges_12_16_20/fl/2016_12/20161206_VoterDetail",
                    pattern = ".txt", full.names = T)

fl_16 <- rbindlist(lapply(files, function(file){
  j <- fread(file)
  colnames(j) <- n
  colnames(j) <- clean_names(j)
  j <- j %>% 
    select(county = county_code,
           voter_id,
           first_name = name_first,
           middle_name = name_middle,
           last_name = name_last,
           street = residence_address_line_1,
           city = residence_city,
           zip = residence_zipcode,
           gender,
           race,
           dob = birth_date,
           reg_date = registration_date,
           party = party_affiliation) %>% 
    mutate(race = ifelse(race == 2, "Asian",
                         ifelse(race == 3, "Black",
                                ifelse(race == 4, "Latino",
                                       ifelse(race == 5, "White", "Other")))),
           party = ifelse(party == "DEM", "D",
                          ifelse(party == "REP", "R",
                                 ifelse(party == "NPA", "U", "O"))),
           state = "FL",
           reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
           dob = as.character(as.Date(dob, "%m/%d/%Y")))
  return(j)
}))

fl_12$purged <- !(fl_12$voter_id %in% fl_16$voter_id)

dbWriteTable(db_full, value = fl_12, name = "FL_12", overwrite = T, append = F)
rm(fl_12)

########################
files <- list.files("E:/purges_12_16_20/fl/2020_04/Voter_Registration_20200407/20200407_VoterDetail",
                    pattern = ".txt", full.names = T)

fl_20 <- rbindlist(lapply(files, function(file){
  j <- fread(file)
  colnames(j) <- n
  colnames(j) <- clean_names(j)
  j <- j %>% 
    select(county = county_code,
           voter_id,
           first_name = name_first,
           middle_name = name_middle,
           last_name = name_last,
           street = residence_address_line_1,
           city = residence_city,
           zip = residence_zipcode,
           gender,
           race,
           dob = birth_date,
           reg_date = registration_date,
           party = party_affiliation) %>% 
    mutate(race = ifelse(race == 2, "Asian",
                         ifelse(race == 3, "Black",
                                ifelse(race == 4, "Latino",
                                       ifelse(race == 5, "White", "Other")))),
           party = ifelse(party == "DEM", "D",
                          ifelse(party == "REP", "R",
                                 ifelse(party == "NPA", "U", "O"))),
           state = "FL",
           reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
           dob = as.character(as.Date(dob, "%m/%d/%Y")))
  return(j)
}))

fl_16$purged <- !(fl_16$voter_id %in% fl_20$voter_id)

dbWriteTable(db_full, value = fl_16, name = "FL_16", overwrite = T, append = F)
dbWriteTable(db_full, value = fl_20, name = "FL_20", overwrite = T, append = F)

#### if you move do you keep your id?

inner1 <- inner_join(fl_16, fl_20, by = c("voter_id", "first_name", "last_name"))
j <- mean(inner1$city.x == inner1$city.y)
saveRDS(j, "./temp/share_fl_same_id_different_city.rds")
##### can ids be re-assigned?

inner1 <- inner_join(fl_16, fl_20, by = c("voter_id"))
j <- mean(inner1$dob.x == inner1$dob.y, na.rm = T)
saveRDS(j, "./temp/share_fl_same_id_same_dob.rds")
######## do invidivuals get new ids?

fl_16 <- fl_16 %>% 
  mutate_all(~ ifelse(. %in% c("", "[*]"), NA, .))

fl_20 <- fl_20 %>% 
  mutate_all(~ ifelse(. %in% c("", "[*]"), NA, .))

inner1 <- inner_join(fl_16, fl_20, by = c("first_name", "last_name", "street", "city", "dob"),
                     na_matches = "never")
j <- mean(inner1$voter_id.x != inner1$voter_id.y)
saveRDS(j, "./temp/share_fl_different_id_same_name_street.rds")

j <- mean(filter(inner1, reg_date.x != reg_date.y)$voter_id.x == filter(inner1, reg_date.x != reg_date.y)$voter_id.y)
saveRDS(j, "./temp/share_fl_same_id_street_different_reg_date.rds")
