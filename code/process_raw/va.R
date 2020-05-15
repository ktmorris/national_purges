cleanup()

va_12 <- fread("E:/purges_12_16_20/va/VA-2012-1/Registered_Voter_List_State4_May12/Registered_Voter_List_State4_May12.txt")

colnames(va_12) <- clean_names(va_12)

va_12 <- va_12 %>% 
  select(voter_id = identification_number,
         last_name,
         first_name,
         middle_name,
         house_number,
         housenumbersuffix,
         street_name,
         streettypecodename,
         direction, post_direction,
         city,
         state, zip,
         gender, dob,
         reg_date = registration_date
         )

va_12 <- clean_streets(va_12, c("house_number",
                                "housenumbersuffix",
                                "direction",
                                "street_name",
                                "streettypecodename",
                                "post_direction")) %>% 
  mutate_at(vars(dob, reg_date),
            ~ as.character(as.Date(., "%m/%d/%Y")))

########################

va_16 <- fread("E:/purges_12_16_20/va/VA-2016-2/Registered_Voter_List.csv")

colnames(va_16) <- clean_names(va_16)

va_16 <- va_16 %>% 
  select(voter_id = identification_number,
         last_name,
         first_name,
         middle_name,
         house_number,
         housenumbersuffix,
         street_name,
         streettypecodename,
         direction, post_direction,
         city,
         state, zip,
         gender, dob,
         reg_date = registration_date
  )

va_16 <- clean_streets(va_16, c("house_number",
                                "housenumbersuffix",
                                "direction",
                                "street_name",
                                "streettypecodename",
                                "post_direction")) %>% 
  mutate_at(vars(dob, reg_date),
            ~ as.character(as.Date(., "%m/%d/%Y")))

va_12$purged <- !(va_12$voter_id %in% va_16$voter_id)
dbWriteTable(db_full, value = va_12, name = "VA_12", overwrite = T, append = F)
