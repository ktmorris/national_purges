cleanup()

files <- list.files("E:/purges_12_16_20/ct/CT-2012-1",
                    pattern = "*txt", full.names = T)

ct_12 <- rbindlist(lapply(files, function(f){
  j <- read_fwf(f,
                fwf_widths(c(03 + 1,
                               09 + 1,
                               35 + 1,
                               20 + 1,
                               15 + 1,
                               05 + 1,
                               05 + 1,
                               01 + 1,
                               01 + 1,
                               01 + 1,
                               03 + 1,
                               02 + 1,
                               03 + 1,
                               03 + 1,
                               03 + 1,
                               40 + 1,
                               03 + 1,
                               02 + 1,
                               03 + 1,
                               02 + 1,
                               06 + 1,
                               08 + 1,
                               40 + 1,
                               18 + 1,
                               02 + 1,
                               05 + 1,
                               04 + 1,
                               04 + 1,
                               06 + 1,
                               08 + 1,
                               40 + 1,
                               20 + 1,
                               30 + 1,
                               02 + 1,
                               20 + 1,
                               10 + 1,
                               04 + 1,
                               10 + 1,
                               10 + 1,
                               05 + 1,
                               05 + 1,
                               01 + 1,
                               10 + 1,
                rep(10, 20))))
  
  colnames(j) <- c("TOWN-ID",
                   "VTR-ID-VOTER",
                   "VTR-NM-LAST",
                   "VTR-NM-FIRST",
                   "VTR-NM-MID",
                   "VTR-NM-PREFIX",
                   "VTR-NM-SUFF",
                   "VTR-CD-STATUS",
                   "CD-SPEC-STATUS",
                   "CD-OFF-REASON",
                   "VTR-DIST",
                   "VTR-PREC",
                   "CONGRESS",
                   "SENATE",
                   "ASSEMBLY",
                   "POLL-PL-NAME",
                   "LOC-VTR-DIST",
                   "LOC-VTR-PREC",
                   "SPC-VTR-DIST",
                   "SPC-VTR-PREC",
                   "VTR-AD-NUM",
                   "VTR-AD-UNIT",
                   "NM-STREET",
                   "TOWN-NAME",
                   "ST",
                   "ZIP5",
                   "ZIP4",
                   "CARRIER",
                   "MAIL-NUM",
                   "MAIL-UNIT",
                   "MAIL-STR1",
                   "MAIL-STR2",
                   "MAIL-CITY",
                   "MAIL-ST",
                   "MAIL-COUNTRY",
                   "MAIL-ZIP",
                   "MAIL-CARRIER",
                   "DT-BIRTH",
                   "PHONE",
                   "CD-PARTY",
                   "CD-PARTY-UNQUAL",
                   "CD-SEX",
                   "DT-ACCEPT"
  )
  colnames(j) <- clean_names(j)
  j <- j %>% 
    select(voter_id = vtr_id_voter,
           first_name = vtr_nm_first,
           middle_name = vtr_nm_mid,
           last_name = vtr_nm_last,
           vtr_ad_num, nm_street,
           city = town_name,
           state = st,
           zip5, zip4,
           dob = dt_birth,
           sex = cd_sex,
           reg_date = dt_accept,
           party = cd_party)
  
  j <- j %>% 
    mutate_all(~ gsub(" ", "", .)) %>% 
    mutate_all(~ trimws(substring(., 1, nchar(.) - 1)))
  
  j <- clean_streets(j, c("vtr_ad_num", "nm_street")) %>% 
    mutate(party = ifelse(party %in% c("D", "R", "U"), party, "O"),
           zip = paste0(zip5, zip4)) %>% 
    mutate_at(vars(dob, reg_date), ~ as.character(as.Date(., "%m/%d/%Y"))) %>% 
    select(-zip5, -zip4)
  
}))


#################
ct_16 <- read_fwf("E:/purges_12_16_20/ct/CT-2017-1/CT-2017-1/20171/Aggregate/allvoters.txt",
              fwf_widths(c(03 + 1,
                           09 + 1,
                           35 + 1,
                           20 + 1,
                           15 + 1,
                           05 + 1,
                           05 + 1,
                           01 + 1,
                           01 + 1,
                           01 + 1,
                           03 + 1,
                           02 + 1,
                           03 + 1,
                           03 + 1,
                           03 + 1,
                           40 + 1,
                           03 + 1,
                           02 + 1,
                           03 + 1,
                           02 + 1,
                           06 + 1,
                           08 + 1,
                           40 + 1,
                           18 + 1,
                           02 + 1,
                           05 + 1,
                           04 + 1,
                           04 + 1,
                           06 + 1,
                           08 + 1,
                           40 + 1,
                           20 + 1,
                           30 + 1,
                           02 + 1,
                           20 + 1,
                           10 + 1,
                           04 + 1,
                           10 + 1,
                           10 + 1,
                           05 + 1,
                           05 + 1,
                           01 + 1,
                           10 + 1,
                           rep(10, 20))))

colnames(ct_16) <- c("TOWN-ID",
                 "VTR-ID-VOTER",
                 "VTR-NM-LAST",
                 "VTR-NM-FIRST",
                 "VTR-NM-MID",
                 "VTR-NM-PREFIX",
                 "VTR-NM-SUFF",
                 "VTR-CD-STATUS",
                 "CD-SPEC-STATUS",
                 "CD-OFF-REASON",
                 "VTR-DIST",
                 "VTR-PREC",
                 "CONGRESS",
                 "SENATE",
                 "ASSEMBLY",
                 "POLL-PL-NAME",
                 "LOC-VTR-DIST",
                 "LOC-VTR-PREC",
                 "SPC-VTR-DIST",
                 "SPC-VTR-PREC",
                 "VTR-AD-NUM",
                 "VTR-AD-UNIT",
                 "NM-STREET",
                 "TOWN-NAME",
                 "ST",
                 "ZIP5",
                 "ZIP4",
                 "CARRIER",
                 "MAIL-NUM",
                 "MAIL-UNIT",
                 "MAIL-STR1",
                 "MAIL-STR2",
                 "MAIL-CITY",
                 "MAIL-ST",
                 "MAIL-COUNTRY",
                 "MAIL-ZIP",
                 "MAIL-CARRIER",
                 "DT-BIRTH",
                 "PHONE",
                 "CD-PARTY",
                 "CD-PARTY-UNQUAL",
                 "CD-SEX",
                 "DT-ACCEPT"
)
colnames(ct_16) <- clean_names(ct_16)
ct_16 <- ct_16 %>% 
  select(voter_id = vtr_id_voter,
         first_name = vtr_nm_first,
         middle_name = vtr_nm_mid,
         last_name = vtr_nm_last,
         vtr_ad_num, nm_street,
         city = town_name,
         state = st,
         zip5, zip4,
         dob = dt_birth,
         sex = cd_sex,
         reg_date = dt_accept,
         party = cd_party)

ct_16 <- ct_16 %>% 
  mutate_all(~ gsub(" ", "", .)) %>% 
  mutate_all(~ trimws(substring(., 1, nchar(.) - 1)))

ct_16 <- clean_streets(ct_16, c("vtr_ad_num", "nm_street")) %>% 
  mutate(party = ifelse(party %in% c("D", "R", "U"), party, "O"),
         zip = paste0(zip5, zip4)) %>% 
  mutate_at(vars(dob, reg_date), ~ as.character(as.Date(., "%m/%d/%Y"))) %>% 
  select(-zip5, -zip4)

ct_12$purged <- !(ct_12$voter_id %in% ct_16$voter_id)
dbWriteTable(db_full, name = "CT_12", value = ct_12, overwrite = T, append = F)
rm(ct_12)
###############################################
files <- list.files("E:/purges_12_16_20/ct/CT-2020-1", recursive = T,
                    pattern = "EXT.", full.names = T)

ct_20 <- rbindlist(lapply(files, function(f){
  j <- read_fwf(f,
                fwf_widths(c(03 + 1,
                             09 + 1,
                             35 + 1,
                             20 + 1,
                             15 + 1,
                             05 + 1,
                             05 + 1,
                             01 + 1,
                             01 + 1,
                             01 + 1,
                             03 + 1,
                             02 + 1,
                             03 + 1,
                             03 + 1,
                             03 + 1,
                             40 + 1,
                             03 + 1,
                             02 + 1,
                             03 + 1,
                             02 + 1,
                             06 + 1,
                             08 + 1,
                             40 + 1,
                             18 + 1,
                             02 + 1,
                             05 + 1,
                             04 + 1,
                             04 + 1,
                             06 + 1,
                             08 + 1,
                             40 + 1,
                             20 + 1,
                             30 + 1,
                             02 + 1,
                             20 + 1,
                             10 + 1,
                             04 + 1,
                             10 + 1,
                             10 + 1,
                             05 + 1,
                             05 + 1,
                             01 + 1,
                             10 + 1,
                             rep(10, 20))))
  
  colnames(j) <- c("TOWN-ID",
                   "VTR-ID-VOTER",
                   "VTR-NM-LAST",
                   "VTR-NM-FIRST",
                   "VTR-NM-MID",
                   "VTR-NM-PREFIX",
                   "VTR-NM-SUFF",
                   "VTR-CD-STATUS",
                   "CD-SPEC-STATUS",
                   "CD-OFF-REASON",
                   "VTR-DIST",
                   "VTR-PREC",
                   "CONGRESS",
                   "SENATE",
                   "ASSEMBLY",
                   "POLL-PL-NAME",
                   "LOC-VTR-DIST",
                   "LOC-VTR-PREC",
                   "SPC-VTR-DIST",
                   "SPC-VTR-PREC",
                   "VTR-AD-NUM",
                   "VTR-AD-UNIT",
                   "NM-STREET",
                   "TOWN-NAME",
                   "ST",
                   "ZIP5",
                   "ZIP4",
                   "CARRIER",
                   "MAIL-NUM",
                   "MAIL-UNIT",
                   "MAIL-STR1",
                   "MAIL-STR2",
                   "MAIL-CITY",
                   "MAIL-ST",
                   "MAIL-COUNTRY",
                   "MAIL-ZIP",
                   "MAIL-CARRIER",
                   "DT-BIRTH",
                   "PHONE",
                   "CD-PARTY",
                   "CD-PARTY-UNQUAL",
                   "CD-SEX",
                   "DT-ACCEPT"
  )
  colnames(j) <- clean_names(j)
  j <- j %>% 
    select(voter_id = vtr_id_voter,
           first_name = vtr_nm_first,
           middle_name = vtr_nm_mid,
           last_name = vtr_nm_last,
           vtr_ad_num, nm_street,
           city = town_name,
           state = st,
           zip5, zip4,
           dob = dt_birth,
           sex = cd_sex,
           reg_date = dt_accept,
           party = cd_party)
  
  j <- j %>% 
    mutate_all(~ gsub(" ", "", .)) %>% 
    mutate_all(~ trimws(substring(., 1, nchar(.) - 1)))
  
  j <- clean_streets(j, c("vtr_ad_num", "nm_street")) %>% 
    mutate(party = ifelse(party %in% c("D", "R", "U"), party, "O"),
           zip = paste0(zip5, zip4)) %>% 
    mutate_at(vars(dob, reg_date), ~ as.character(as.Date(., "%m/%d/%Y"))) %>% 
    select(-zip5, -zip4)
  
}))


ct_16$purged <- !(ct_16$voter_id %in% ct_20$voter_id)
dbWriteTable(db_full, name = "CT_16", value = ct_16, overwrite = T, append = F)
dbWriteTable(db_full, name = "CT_20", value = ct_20, overwrite = T, append = F)
