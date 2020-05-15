
files <- list.files("E:/purges_12_16_20/ky/KY-2012-1",
                    full.names = T, pattern = "CONG.*")

ky_12 <- rbindlist(lapply(files, function(file){
  j <- read_fwf(file, fwf_widths(c(3, 4, 1, 25, 15, 10, 1, 1, 3,
                                   40, 20, 2, 9, 40, 20, 2, 9,
                                   8, 8, 20)))
  colnames(j) <- c("county", "precinct", "city_code", "last_name",
                   "first_name", "middle_name", "gender", "party",
                   "other", "street", "city", "state", "zip",
                   "m1", "m2", "m3", "m4", "dob", "reg_date", "hist")
  
  j <- select(j,
              -m1, -m2, -m3, -m4, -hist,
              -precinct, -city_code) %>% 
    mutate(party = ifelse(party %in% c("D", "R"), party,
                          ifelse(party == "I", "U", "O"))) %>% 
    mutate_at(vars(dob, reg_date), ~ as.character(as.Date(., "%m%d%Y")))
}))

#################

ky_16 <- read_fwf("E:/purges_12_16_20/ky/KY-2017-1/KY-2017-1/anderson0350.txt",
                  fwf_widths(c(3, 4, 1, 25, 15, 10, 1, 1, 3,
                               40, 20, 2, 9, 40, 20, 2, 9,
                               8, 8, 20)))
colnames(ky_16) <- c("county", "precinct", "city_code", "last_name",
                     "first_name", "middle_name", "gender", "party",
                     "other", "street", "city", "state", "zip",
                     "m1", "m2", "m3", "m4", "dob", "reg_date", "hist")

ky_16 <- select(ky_16,
                -m1, -m2, -m3, -m4, -hist,
                -precinct, -city_code) %>% 
  mutate(party = ifelse(party %in% c("D", "R"), party,
                        ifelse(party == "I", "U", "O"))) %>% 
  mutate_at(vars(dob, reg_date), ~ as.character(as.Date(., "%m%d%Y")))

####################

ky_20 <- read_fwf("E:/purges_12_16_20/ky/KY-2019-2/Statewide.txt",
                  fwf_widths(c(3, 4, 1, 25, 15, 10, 1, 1, 3,
                               40, 20, 2, 9, 40, 20, 2, 9,
                               4, 8, 20)))
colnames(ky_20) <- c("county", "precinct", "city_code", "last_name",
                     "first_name", "middle_name", "gender", "party",
                     "other", "street", "city", "state", "zip",
                     "m1", "m2", "m3", "m4", "dob", "reg_date", "hist")

ky_20 <- select(ky_20,
                -m1, -m2, -m3, -m4, -hist,
                -precinct, -city_code) %>% 
  mutate(party = ifelse(party %in% c("D", "R"), party,
                        ifelse(party == "I", "U", "O")),
         dob = as.character(make_date(dob)),
         reg_date = as.character(as.Date(reg_date, "%m%d%Y")))

dbWriteTable(db_full, value = ky_12, name = "KY_12", overwrite = T, append = F)
dbWriteTable(db_full, value = ky_16, name = "KY_16", overwrite = T, append = F)
dbWriteTable(db_full, value = ky_20, name = "KY_20", overwrite = T, append = F)
