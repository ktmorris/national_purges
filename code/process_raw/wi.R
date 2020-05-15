wi_12 <- fread("E:/purges_12_16_20/wi/WI-2012-1/5737_Statewide_Voters_List.tab", fill = T)

wi_12 <- wi_12 %>% 
  filter(VoterStatus != "Cancelled") %>% 
  select(voter_id = VoterRegNum,
         first_name = FirstName,
         middle_name = MiddleName,
         last_name = LastName,
         street = AddressLine1,
         reg_date = ApplicationDate,
         city = Jurisdiction,
         zip = ZipCode) %>% 
  mutate(reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
         city = gsub("TOWN OF |CITY OF |VILLAGE OF ", "", city),
         state = "WI")

####################

wi_16 <- fread("E:/purges_12_16_20/wi/WI-2016-1/1440_DataFile.tab", fill = T)

wi_16 <- wi_16 %>% 
  filter(VoterStatus != "Cancelled") %>% 
  select(voter_id = VoterRegNum,
         first_name = FirstName,
         middle_name = MiddleName,
         last_name = LastName,
         street = AddressLine1,
         reg_date = ApplicationDate,
         city = Jurisdiction,
         zip = ZipCode) %>% 
  mutate(reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
         city = gsub("TOWN OF |CITY OF |VILLAGE OF ", "", city),
         city = sub("\\ - .*", "", city),
         state = "WI")

####################

wi_20 <- fread("E:/purges_12_16_20/wi/WI-2020-1/1024_4128.txt", fill = T)

colnames(wi_20) <- clean_names(wi_20)

wi_20 <- wi_20 %>% 
  filter(voter_status != "Cancelled") %>% 
  select(voter_id = voter_reg_number,
         first_name = firstname,
         middle_name = middlename,
         last_name = lastname,
         street = address1,
         reg_date = applicationdate,
         city = jurisdiction,
         zip = zipcode) %>% 
  mutate(reg_date = as.character(as.Date(reg_date, "%m/%d/%Y")),
         city = gsub("TOWN OF |CITY OF |VILLAGE OF ", "", city),
         city = sub("\\ - .*", "", city),
         state = "WI")

#### if you move do you keep your id?

inner1 <- inner_join(wi_16, wi_20, by = c("first_name", "last_name")) %>% 
  filter(city.x != city.y)
j <- mean(inner1$voter_id.x == inner1$voter_id.y, na.rm = T)
saveRDS(j, "./temp/share_wi_same_id_different_county.rds")
##### can ids be re-assigned?

inner1 <- inner_join(wi_16, wi_20, by = c("voter_id"))
j <- mean(inner1$first_name.x == inner1$first_name.y, na.rm = T)
saveRDS(j, "./temp/share_wi_same_id_same_dob.rds")
######## do invidivuals get new ids?

inner1 <- inner_join(wi_16, wi_20, by = c("first_name", "last_name", "street", "city"),
                     na_matches = "never")
j <- mean(inner1$voter_id.x != inner1$voter_id.y)
saveRDS(j, "./temp/share_wi_different_id_same_name_street.rds")

j <- mean(filter(inner1, reg_date.x != reg_date.y)$voter_id.x == filter(inner1, reg_date.x != reg_date.y)$voter_id.y)
saveRDS(j, "./temp/share_wi_same_id_street_different_reg_date.rds")

h <- filter(inner1, reg_date.x != reg_date.y)
h$okay <- h$voter_id.x %in% wi_20$voter_id
mean(h$okay)
######### do you get a new reg date always?

inner1 <- inner_join(wi_16, wi_20, by = c("voter_id", "first_name", "street")) %>% 
  filter(last_name.x != last_name.y)

mean(inner1$reg_date.x == inner1$reg_date.y, na.rm = T)
