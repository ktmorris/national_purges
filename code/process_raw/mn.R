
files <- list.files("E:/purges_12_16_20/mn/MN-2012-1",
                    full.names = T, pattern = "Voter.*")

mn_12 <- rbindlist(lapply(files, function(file){
  j <- fread(file)
  
  j <- select(j,
              voter_id = VoterId,
              county = CountyCode,
              first_name = FirstName,
              middle_name = MiddleName,
              last_name = LastName,
              HouseNumber, StreetName,
              city = City,
              state = State,
              zip = ZipCode,
              reg_date = RegistrationDate,
              dob = DOBYear) %>% 
    mutate(dob = as.character(make_date(dob)),
           reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")))
  
  j <- clean_streets(j, c("HouseNumber", "StreetName"))
  return(j)
}))

#####################

files <- list.files("E:/purges_12_16_20/mn/MN-2017-1/vf",
                    full.names = T, pattern = "Voter.*")

mn_16 <- rbindlist(lapply(files, function(file){
  j <- fread(file)
  
  j <- select(j,
              voter_id = VoterId,
              county = CountyCode,
              first_name = FirstName,
              middle_name = MiddleName,
              last_name = LastName,
              HouseNumber, StreetName,
              city = City,
              state = State,
              zip = ZipCode,
              reg_date = RegistrationDate,
              dob = DOBYear) %>% 
    mutate(dob = as.character(make_date(dob)),
           reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")))
  
  j <- clean_streets(j, c("HouseNumber", "StreetName"))
  return(j)
}))

mn_12$purged <- !(mn_12$voter_id %in% mn_16$voter_id)
dbWriteTable(db_full, name = "MN_12", value = mn_12, overwrite = T, append = F)
rm(mn_12)
#####################

files <- list.files("E:/purges_12_16_20/mn/MN-2019-2",
                    full.names = T, pattern = "Voter.*")

mn_20 <- rbindlist(lapply(files, function(file){
  j <- fread(file)
  
  j <- select(j,
              voter_id = VoterId,
              county = CountyCode,
              first_name = FirstName,
              middle_name = MiddleName,
              last_name = LastName,
              HouseNumber, StreetName,
              city = City,
              state = State,
              zip = ZipCode,
              reg_date = RegistrationDate,
              dob = DOBYear) %>% 
    mutate(dob = as.character(make_date(dob)),
           reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")))
  
  j <- clean_streets(j, c("HouseNumber", "StreetName"))
  return(j)
}))

mn_16$purged <- !(mn_16$voter_id %in% mn_20$voter_id)
dbWriteTable(db_full, name = "MN_16", value = mn_16, overwrite = T, append = F)
dbWriteTable(db_full, name = "MN_20", value = mn_20, overwrite = T, append = F)
