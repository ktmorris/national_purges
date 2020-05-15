read_az <- function(file){
  inp <- read_csv(file) %>% 
    select(first_name = text_name_first,
           middle_name = text_name_middle,
           last_name = text_name_last,
           dob = date_of_birth,
           reg_date = date_of_registration,
           voter_id = text_registrant_id,
           text_res_address_nbr, cde_street_dir_prefix,
           text_street_name, cde_street_type, cde_street_dir_suffix,
           city = text_res_city,
           state = cde_res_state,
           zip = text_res_zip5,
           party = desc_party)
  
  inp <- clean_streets(inp, c("text_res_address_nbr", "cde_street_dir_prefix",
                              "text_street_name", "cde_street_type", "cde_street_dir_suffix")) %>% 
    mutate(party = ifelse(party %in% c("DEMOCRATIC", "REPUBLICAN"), substring(party, 1, 1),
                          ifelse(party == "PARTY NOT DESIGNATED", "U", "O")))
  return(inp)
}

read_aza <- function(file){
  inp <- read_tsv(file) %>% 
    select(first_name = text_name_first,
           middle_name = text_name_middle,
           last_name = text_name_last,
           dob = date_of_birth,
           reg_date = date_of_registration,
           voter_id = text_registrant_id,
           text_res_address_nbr, cde_street_dir_prefix,
           text_street_name, cde_street_type, cde_street_dir_suffix,
           city = text_res_city,
           state = cde_res_state,
           zip = text_res_zip5,
           party = cde_party)
  
  inp <- clean_streets(inp, c("text_res_address_nbr", "cde_street_dir_prefix",
                              "text_street_name", "cde_street_type", "cde_street_dir_suffix")) %>% 
    mutate(party = ifelse(party %in% c("DEM", "REP"), substring(party, 1, 1),
                          ifelse(party == "IND", "U", "O")))
  return(inp)
}

read_az2 <- function(file){
  inp <- read_csv(file) %>% 
    select(first_name = text_name_first,
           middle_name = text_name_middle,
           last_name = text_name_last,
           reg_date = date_of_registration,
           voter_id = text_registrant_id,
           text_res_address_nbr, cde_street_dir_prefix,
           text_street_name, cde_street_type, cde_street_dir_suffix,
           city = text_res_city,
           state = cde_res_state,
           zip = text_res_zip5,
           party = desc_party)
  
  inp <- clean_streets(inp, c("text_res_address_nbr", "cde_street_dir_prefix",
                              "text_street_name", "cde_street_type", "cde_street_dir_suffix")) %>% 
    mutate(party = ifelse(party %in% c("DEMOCRATIC", "REPUBLICAN"), substring(party, 1, 1),
                          ifelse(party == "PARTY NOT DESIGNATED", "U", "O")))
  return(inp)
}

read_az3 <- function(file){
  inp <- read_csv(file) %>% 
    select(first_name = text_name_first,
           middle_name = text_name_middle,
           last_name = text_name_last,
           dob = date_of_birth,
           reg_date = date_of_registration,
           voter_id = text_registrant_id,
           text_res_address_nbr, cde_street_dir_prefix,
           text_street_name, cde_street_type, cde_street_dir_suffix,
           city = text_res_city,
           state = cde_res_state,
           zip = text_res_zip5,
           party = cde_party)
  
  inp <- clean_streets(inp, c("text_res_address_nbr", "cde_street_dir_prefix",
                              "text_street_name", "cde_street_type", "cde_street_dir_suffix")) %>% 
    mutate(party = ifelse(party %in% c("DEM", "REP"), substring(party, 1, 1),
                          ifelse(party == "IND", "U", "O")))
  return(inp)
}

########################

apache <- read_az("E:/purges_12_16_20/az/AZ-2012-1/Apache-QUARTERLY PARTY 01102012.csv") %>% 
  mutate_at(vars(dob, reg_date), ~ as.character(as.Date(., "%m/%d/%Y"))) %>% 
  mutate(county = "APACHE")

cochise <- read_az3("E:/purges_12_16_20/az/AZ-2012-1/Cochise-AZ PARTY REPORT (ACTIVE).csv") %>% 
  mutate(dob = as.character(make_date(dob)),
         reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
         county = "COCHISE")

coconino <- read_az("E:/purges_12_16_20/az/AZ-2012-1/Coconino-VR FILE 3-29-12.csv") %>% 
  mutate(dob = as.character(make_date(dob)),
         reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
         county = "COCONINO")

gila <- read_az2("E:/purges_12_16_20/az/AZ-2012-1/Gila-QUARTERLY PARTY REPORT 03-01-2012.CSV") %>% 
  mutate(reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
         county = "GILA")

graham <- read_az("E:/purges_12_16_20/az/AZ-2012-1/Graham-PARTYLIST.CSV") %>% 
  mutate(dob = as.character(make_date(dob)),
         reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
         county = "GRAHAM")

greenlee <- rbind(
  read_az3("E:/purges_12_16_20/az/AZ-2012-1/Greenlee-March 1-Active.csv"),
  read_az3("E:/purges_12_16_20/az/AZ-2012-1/Greenlee-March 1-inactive.csv")) %>% 
  mutate(dob = as.character(make_date(dob)),
         reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
         county = "GREENLEE")

lapaz <- read_az2("E:/purges_12_16_20/az/AZ-2012-1/LaPaz-03.19.2012.PARTY.REPORT.csv") %>% 
  mutate(reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
         county = "LAPAZ")

maricopa <- fread("E:/purges_12_16_20/az/AZ-2012-1/Maricopa-PARTYFILE_REPC_04302012_031555.txt") %>% 
  select(first_name = FRSTNAME,
         middle_name = MIDNAME,
         last_name = LASTNAME,
         dob = DOB_YEAR,
         reg_date = DOR,
         voter_id = VOTERID,
         HSENO, STDIR, STNAME, STTYPE, STSUFX, 
         city = CITY,
         state = STATE,
         zip = ZIP,
         party = PARTY)
maricopa <- clean_streets(maricopa, c("HSENO", "STDIR", "STNAME", "STTYPE", "STSUFX")) %>% 
  mutate(dob = as.character(make_date(dob)),
         reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
         county = "MARICOPA",
         party = ifelse(party %in% c("DEM", "REP"), substring(party, 1, 1),
                        ifelse(party == "IND", "U", "O")))

mohave <- read_az("E:/purges_12_16_20/az/AZ-2012-1/Mohave-MARCH 1 MOHAVE VOTER FILE.csv") %>% 
  mutate(dob = as.character(make_date(dob)),
         reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
         county = "MOHAVE")

navajo <- read_az("E:/purges_12_16_20/az/AZ-2012-1/Navajo-FREE PARTY LIST 03012012.csv") %>% 
  mutate(dob = as.character(make_date(dob)),
         reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
         county = "NAVAJO")
#################
pima <- rbindlist(lapply(c("E:/purges_12_16_20/az/AZ-2012-1/Pima-VRdata/Active.txt",
                           "E:/purges_12_16_20/az/AZ-2012-1/Pima-VRdata/Inactive.txt"), function(f){
                             read_csv(f, col_names = F) %>% 
                               select(name = X7,
                                      last_name = X6,
                                      X8, X9, X10, X11, X12, X13,
                                      city = X15,
                                      zip = X16,
                                      party = X22,
                                      dob = X25,
                                      reg_date = X37,
                                      voter_id = X3)
                           }))

pima <- cSplit(pima, "name", sep = " ", type.convert = F) %>% 
  rename(first_name = name_1,
         middle_name = name_2) %>% 
  mutate(party = ifelse(party %in% c("DEM", "REP"), substring(party, 1, 1),
                        ifelse(party == "PND", "U", "O")),
         dob = as.character(make_date(dob)),
         reg_date = as.character(as.Date(reg_date, "%Y%m%d")),
         state = "AZ",
         county = "PIMA") %>% 
  select(-starts_with("name"))

pima <- clean_streets(pima, c("X8", "X9", "X10", "X11", "X12", "X13"))
##################

pinal <- rbindlist(lapply(list.files("E:/purges_12_16_20/az/AZ-2012-1/Pinal-ACTIVE-VOTER",
                                     pattern = "*.csv", full.names = T), function(f){
                                       x <- read_csv(f) %>% 
                                         select(first_name = text_name_first,
                                                middle_name = text_name_middle,
                                                last_name = text_name_last,
                                                dob = date_of_birth,
                                                reg_date = date_of_registration,
                                                voter_id = text_registrant_id,
                                                text_res_address_nbr, cde_street_dir_prefix,
                                                text_street_name, cde_street_type,
                                                city = text_res_city,
                                                state = cde_res_state,
                                                zip = text_res_zip5,
                                                party = cde_party)
                                       
                                       x <- clean_streets(x, c("text_res_address_nbr", "cde_street_dir_prefix",
                                                               "text_street_name", "cde_street_type")) %>% 
                                         mutate(party = ifelse(party %in% c("DEM", "REP"), substring(party, 1, 1),
                                                               ifelse(party == "IND", "U", "O")),
                                                county = "PINAL",
                                                dob = as.character(make_date(dob)),
                                                reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")))
                                     }))

santacruz <- read_az("E:/purges_12_16_20/az/AZ-2012-1/SantaCruz-QUARTERLY FILE 03-22-12.csv") %>% 
  mutate(dob = as.character(make_date(dob)),
         reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
         county = "SANTACRUZ")

yavapai <- rbindlist(lapply(
  c("E:/purges_12_16_20/az/AZ-2012-1/Yavapai-MAR/MAR QUARTERLY INACTIVE.txt",
    "E:/purges_12_16_20/az/AZ-2012-1/Yavapai-MAR/MAR QUARTERLY ACTIVE.txt"),
  read_aza)) %>% 
  mutate_at(vars(dob, reg_date), ~ as.character(as.Date(., "%m/%d/%Y"))) %>% 
  mutate(county = "YAVAPAI")

yuma <- read_az("E:/purges_12_16_20/az/AZ-2012-1/Yuma-PARTY QUARTERLY REPORT FOR JAN 1, 2012.csv") %>% 
  mutate(dob = as.character(make_date(dob)),
         reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
         county = "YUMA")
#########################
az_12 <- rbind(apache, cochise, coconino,
               gila, graham, greenlee, lapaz,
               maricopa, mohave, navajo,
               pima, pinal, santacruz,
               yavapai, yuma, fill = T)
cleanup("az_12")

az_16 <- fread("E:/purges_12_16_20/az/AZ-2016-MID_EXPORT/101116_AZ_MID_EXPORT.tab") %>% 
  select(voter_id = CountyVoterID,
         first_name = FirstName,
         middle_name = MiddleName,
         last_name = LastName,
         dob = BirthDate,
         reg_date = RegDate,
         county = County,
         party = PartyID,
         street = AddressLine,
         city = City,
         state = State,
         zip = Zip) %>% 
  mutate(party = ifelse(party == 1, "D",
                        ifelse(party == 2, "R",
                               ifelse(party == 24, "U", "O"))))

