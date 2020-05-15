cleanup()


hi_12 <- read_fwf("E:/purges_12_16_20/hi/HI-2012-1/vrfmmstr.txt",
                  fwf_widths(c(2,
                               2,
                               28,
                               28,
                               5,
                               7,
                               1,
                               7,
                               6,
                               1,
                               7,
                               2,
                               10,
                               2,
                               2,
                               1,
                               28,
                               5,
                               2,
                               1,
                               1,
                               10,
                               6,
                               8,
                               1,
                               1,
                               1,
                               1,
                               1,
                               1,
                               2),
                             c("district"     ,
                               "precinct"     ,
                               "name"         ,
                               "street"       ,
                               "zip"          ,
                               "voter_id"     ,
                               "gender"       ,
                               "filler1"      ,
                               "reg_date"     ,
                               "county"       ,
                               "filler2"      ,
                               "status"       ,
                               "filler3"      ,
                               "senate"       ,
                               "council"      ,
                               "cong"         ,
                               "mail"         ,
                               "mailzip"      ,
                               "ftv"          ,
                               "perm_abs"     ,
                               "mail_ind"     ,
                               "fillera"      ,
                               "last_contact" ,
                               "fillerb"      ,
                               "ftv2"         ,
                               "ftv3"         ,
                               "fillerc"      ,
                               "absentee"     ,
                               "quest"        ,
                               "ttype"        ,
                               "lang"         ))) %>% 
  select(name, street, zip, voter_id, gender, reg_date, county)

hi_12 <- cSplit(hi_12, "name", sep = ",", type.convert = F)
hi_12 <- cSplit(hi_12, "name_2", sep = " ", type.convert = F)

hi_12 <- hi_12 %>% 
  mutate(year = substring(reg_date, 5),
         year = ifelse(year < 21, paste0("20", year), paste0("19", year)),
         reg_date = as.character(make_date(year = year, month = substring(reg_date, 1, 2),
                                           day = substring(reg_date, 3, 4)))) %>% 
  rename(first_name = name_2_1,
         middle_name = name_2_2,
         last_name = name_1) %>% 
  select(-year, -starts_with("name"))
############################################

hi_16 <- read_fwf("E:/purges_12_16_20/hi/HI-2017-1/vrfmmstr.txt",
                  fwf_widths(c(2,
                               2,
                               28,
                               28,
                               5,
                               7,
                               1,
                               7,
                               6,
                               1,
                               7,
                               2,
                               10,
                               2,
                               2,
                               1,
                               28,
                               5,
                               2,
                               1,
                               1,
                               10,
                               6,
                               8,
                               1,
                               1,
                               1,
                               1,
                               1,
                               1,
                               2),
                             c("district"     ,
                               "precinct"     ,
                               "name"         ,
                               "street"       ,
                               "zip"          ,
                               "voter_id"     ,
                               "gender"       ,
                               "filler1"      ,
                               "reg_date"     ,
                               "county"       ,
                               "filler2"      ,
                               "status"       ,
                               "filler3"      ,
                               "senate"       ,
                               "council"      ,
                               "cong"         ,
                               "mail"         ,
                               "mailzip"      ,
                               "ftv"          ,
                               "perm_abs"     ,
                               "mail_ind"     ,
                               "fillera"      ,
                               "last_contact" ,
                               "fillerb"      ,
                               "ftv2"         ,
                               "ftv3"         ,
                               "fillerc"      ,
                               "absentee"     ,
                               "quest"        ,
                               "ttype"        ,
                               "lang"         ))) %>% 
  select(name, street, zip, voter_id, gender, reg_date, county)

hi_16 <- cSplit(hi_16, "name", sep = ",", type.convert = F)
hi_16 <- cSplit(hi_16, "name_2", sep = " ", type.convert = F)

hi_16 <- hi_16 %>% 
  mutate(year = substring(reg_date, 5),
         year = ifelse(year < 21, paste0("20", year), paste0("19", year)),
         reg_date = as.character(make_date(year = year, month = substring(reg_date, 1, 2),
                                           day = substring(reg_date, 3, 4)))) %>% 
  rename(first_name = name_2_1,
         middle_name = name_2_2,
         last_name = name_1) %>% 
  select(-year, -starts_with("name"))

############################################

files <- list.files("E:/purges_12_16_20/hi/HI-2019-2",
                    pattern = "*.csv", full.names = T)

hi_20 <- rbindlist(lapply(files, fread), fill = T)

hi_20 <- hi_20 %>% 
  select(first_name = vrNameFirst,
         middle_name = vrNameMiddle,
         last_name = vrNameLast,
         street = noResAddress,
         city = noResCity,
         zip = noResZip,
         county = noCountyName,
         reg_date = DateOfRegistration,
         voter_id = ListID)
# 
# dbWriteTable(db_full, name = "HI_12", value = hi_12, overwrite = T, append = F)
# dbWriteTable(db_full, name = "HI_16", value = hi_16, overwrite = T, append = F)
# dbWriteTable(db_full, name = "HI_20", value = hi_20, overwrite = T, append = F)