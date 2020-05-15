
files <- list.files("E:/purges_12_16_20/sc/SC-2012-1",
                    full.names = T, pattern = "sr.*")

sc_12 <- rbindlist(lapply(files, function(f){
  inter <- fread(f, select = c(1:19))
  
  colnames(inter) <- c("county", "voter_id", "first_name", "middle_name", "last_name",
                       "x1", "house_num", "street", "city", "zip", "x2", "x3", "x4", "x5", "x6",
                       "gender", "race", "reg_date", "dob")
  
  inter <- clean_streets(inter, c("house_num", "street")) %>% 
    select(-starts_with("x")) %>% 
    mutate_at(vars(reg_date, dob), ~ as.character(as.Date(as.character(.), "%Y%m%d")))
}))

###############

files <- list.files("E:/purges_12_16_20/sc/SC-2016-2",
                    full.names = T, pattern = "*txt", recursive = T)

sc_16 <- rbindlist(lapply(files, function(f){
  inter <- fread(f, select = c(1:20))
  
  colnames(inter) <- c("county", "voter_id", "first_name", "middle_name", "last_name",
                       "x1", "house_num", "street", "xx", "city", "zip", "x2", "x3", "x4", "x5", "x6",
                       "gender", "race", "reg_date", "dob")
  
  inter <- clean_streets(inter, c("house_num", "street")) %>% 
    select(-starts_with("x")) %>% 
    mutate_at(vars(reg_date, dob), ~ as.character(as.Date(as.character(.), "%Y%m%d")))
}))


###############
files <- list.files("E:/purges_12_16_20/sc/SC-2019-2",
                    full.names = T, pattern = "*txt", recursive = T)

sc_20 <- rbindlist(lapply(files, function(f){
  inter <- fread(f, select = c(1:20))
  
  colnames(inter) <- c("county", "voter_id", "first_name", "middle_name", "last_name",
                       "x1", "house_num", "street", "xx", "city", "zip", "x2", "x3", "x4", "x5", "x6",
                       "gender", "race", "reg_date", "dob")
  
  inter <- clean_streets(inter, c("house_num", "street")) %>% 
    select(-starts_with("x")) %>% 
    mutate_at(vars(reg_date, dob), ~ as.character(as.Date(as.character(.), "%Y%m%d")))
}))

sc_12$purged <- !(sc_12$voter_id %in% sc_16$voter_id)
sc_16$purged <- !(sc_16$voter_id %in% sc_20$voter_id)

write_db(sc_12)
write_db(sc_16)
write_db(sc_20)

