

sd_12 <- read_fwf("E:/purges_12_16_20/sd/SD-2012-1/Voter Information - Statewide_reg.txt",
                  fwf_widths(c(1,
                               9,
                               1,
                               15,
                               23,
                               15,
                               6,
                               3,
                               40,
                               25,
                               2,
                               10,
                               35,
                               20,
                               2,
                               10,
                               3,
                               4,
                               3,
                               3,
                               2,
                               5,
                               3,
                               4,
                               4,
                               4,
                               4,
                               4,
                               4,
                               12,
                               8,
                               15,
                               8,
                               8,
                               8,
                               8,
                               2)))
colnames(sd_12) <- c("Transaction Code",
                     "Voter ID",
                     "Voter Status (Active-inactive)",
                     "First Name",
                     "Last Name",
                     "Middle Name",
                     "Title",
                     "Suffix",
                     "Address",
                     "City",
                     "State",
                     "Zip",
                     "Mailing Address",
                     "Mailing City",
                     "Mailing State",
                     "Mailing Zip ",
                     "Party",
                     "Precinct ",
                     "Senate District",
                     "House District",
                     "Commissioner District",
                     "City/Township ",
                     "Ward code",
                     "School code",
                     "Special District 1",
                     "Special District 2",
                     "Special District 3",
                     "Special District 4",
                     "Special District 5",
                     "Telephone number",
                     "Date of Birth",
                     "Empty",
                     "Original Registration Date",
                     "Registration Changed Date",
                     "Date Last Jury Service",
                     "Date county system updated",
                     "State of Driver License Issuance")
colnames(sd_12) <- clean_names(sd_12)

sd_12 <- select(sd_12,
                voter_id,
                first_name,
                last_name,
                middle_name,
                street = address,
                city,
                state,
                zip,
                party,
                dob = date_of_birth,
                reg_date = registration_changed_date) %>% 
  mutate(party = ifelse(party %in% c("DEM", "REP"), substring(party, 1, 1),
                        ifelse(party %in% c("IND", "NPA"), "U", "O")),
         reg_date = as.character(as.Date(as.character(reg_date), "%Y%m%d")),
         dob = as.character(make_date(dob)))

#####################

sd_16 <- fread("E:/purges_12_16_20/sd/SD-2017-1/SD-2017-1/sd_vf_2017-01-04.csv")
colnames(sd_16) <- clean_names(sd_16)

sd_16 <- select(sd_16,
                voter_id = id,
                first_name,
                last_name,
                middle_name,
                street = residential_address,
                city = residential_city,
                state = residential_state,
                zip = residential_zip,
                party,
                county,
                dob,
                reg_date = last_registration_date) %>% 
  mutate(party = ifelse(party %in% c("DEM", "REP"), substring(party, 1, 1),
                        ifelse(party %in% c("IND", "NPA"), "U", "O")),
         reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
         dob = as.character(make_date(dob)))

#####################

sd_20 <- fread("E:/purges_12_16_20/sd/SD-2020-1/SWVoters (30).csv")
colnames(sd_20) <- clean_names(sd_20)

sd_20 <- select(sd_20,
                voter_id = id,
                first_name,
                last_name,
                middle_name,
                street = address,
                city = city,
                state = state,
                zip = zip,
                party,
                county,
                dob,
                reg_date = last_reg_date) %>% 
  mutate(party = ifelse(party %in% c("DEM", "REP"), substring(party, 1, 1),
                        ifelse(party %in% c("IND", "NPA"), "U", "O")),
         reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
         dob = as.character(make_date(dob)))

sd_12$purged <- !(sd_12$voter_id %in% sd_16$voter_id)
sd_16$purged <- !(sd_16$voter_id %in% sd_20$voter_id)
write_db(sd_12)
write_db(sd_16)
write_db(sd_20)
