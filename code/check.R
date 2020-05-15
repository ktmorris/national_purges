f12 <- tbl(db_full, "FL_12") %>% 
  select(-reg_date) %>% 
  collect()

f16 <- tbl(db_full, "FL_16") %>% 
  select(-reg_date, -purged) %>% 
  collect() %>% 
  rename(id = voter_id) %>% 
  distinct()

inner <- inner_join(f12, f16, by = c("county", "first_name", "middle_name", "last_name", "street", "city", "zip"))

mean(inner$id == inner$voter_id)
