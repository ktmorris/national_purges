n <- fread("D:/rolls/new_jersey/colnames.csv")

files <- list.files("E:/purges_12_16_20/nj/082018",
                    full.names = T, pattern = "*.zip", recursive = T)

lapply(files, function(file){
  dir.create(file.path(gsub(".zip", "", file)))
  p <- gsub(".zip", "", file)
  unzip(file, exdir = p)
})

files <- list.files("E:/purges_12_16_20/nj/082018/njsvrs-voterhistory-alphavoterlist-2018-0820", pattern = "*.txt",
                    full.names = T, recursive = T)


nj_12 <- rbindlist(lapply(files, function(file){
  
  j <- fread(file)
  colnames(j) <- gsub("[.]", "_", make.unique(make.names(n[[1]])))
  colnames(j) <- clean_names(j)
  
  c <- j$county[1]
  
  k <- fread(paste0("E:/purges_12_16_20/nj/082018/njsvrs-voterhistory-diskreport-2018-0820/njsvrs-voterhistory-diskreport-2018-0820/", c, "/ElectionHistory.txt"), sep = "|") %>%
    select(V1, V9, V33) %>% 
    distinct()
  j <- left_join(j, k, by = c("voter_id" = "V1")) %>% 
    select(reg_date = V33,
           gender = V9,
           county,
           voter_id,
           last_name,
           first_name,
           middle_name,
           street_number,
           street_name,
           city,
           zip,
           dob,
           party = party_code) %>% 
    mutate(party = ifelse(party == "DEM", "D",
                          ifelse(party == "REP", "R",
                                 ifelse(party == "UNA", "U", "O")))) %>% 
    mutate_at(vars(reg_date, dob), ~ as.character(as.Date(., "%m/%d/%Y")))
  
  j <- clean_streets(j, c("street_number", "street_name"))
  
  return(j)
}))

nj_12$state <- "NJ"

######################
files <- list.files("E:/purges_12_16_20/nj/070319",
                    full.names = T, pattern = "*.zip", recursive = T)

lapply(files, function(file){
  dir.create(file.path(gsub(".zip", "", file)))
  p <- gsub(".zip", "", file)
  unzip(file, exdir = p)
})

files <- list.files("E:/purges_12_16_20/nj/070319/njsvrs-voterhistory-alphavoterlist-2019-0630", pattern = "*.txt",
                    full.names = T, recursive = T)


nj_16 <- rbindlist(lapply(files, function(file){
  
  j <- fread(file)
  colnames(j) <- gsub("[.]", "_", make.unique(make.names(n[[1]])))
  colnames(j) <- clean_names(j)
  
  c <- j$county[1]
  
  k <- fread(paste0("E:/purges_12_16_20/nj/082018/njsvrs-voterhistory-diskreport-2018-0820/njsvrs-voterhistory-diskreport-2018-0820/", c, "/ElectionHistory.txt"), sep = "|") %>%
    select(V1, V9, V33) %>% 
    distinct()
  j <- left_join(j, k, by = c("voter_id" = "V1")) %>% 
    select(reg_date = V33,
           gender = V9,
           county,
           voter_id,
           last_name,
           first_name,
           middle_name,
           street_number,
           street_name,
           city,
           zip,
           dob,
           party = party_code) %>% 
    mutate(party = ifelse(party == "DEM", "D",
                          ifelse(party == "REP", "R",
                                 ifelse(party == "UNA", "U", "O")))) %>% 
    mutate_at(vars(reg_date, dob), ~ as.character(as.Date(., "%m/%d/%Y")))
  
  j <- clean_streets(j, c("street_number", "street_name"))
  
  return(j)
}))

nj_16$state <- "NJ"


#### if you move do you keep your id?

inner1 <- inner_join(nj_16, nj_20, by = c("voter_id", "first_name", "last_name", "dob"))
j <- mean(inner1$county.x == inner1$county.y, na.rm = T)
saveRDS(j, "./temp/share_nj_same_id_different_county.rds")
##### can ids be re-assigned?

inner1 <- inner_join(nj_16, nj_20, by = c("voter_id"))
j <- mean(inner1$first_name.x == inner1$first_name.y, na.rm = T)
saveRDS(j, "./temp/share_nj_same_id_same_dob.rds")
######## do invidivuals get new ids?

inner1 <- inner_join(nj_16, nj_20, by = c("first_name", "last_name", "street", "city", "dob"),
                     na_matches = "never")
j <- mean(inner1$voter_id.x != inner1$voter_id.y)
saveRDS(j, "./temp/share_nj_different_id_same_name_street.rds")

j <- mean(filter(inner1, reg_date.x != reg_date.y)$voter_id.x == filter(inner1, reg_date.x != reg_date.y)$voter_id.y)
saveRDS(j, "./temp/share_nj_same_id_street_different_reg_date.rds")

h <- filter(inner1, reg_date.x != reg_date.y)
h$okay <- h$voter_id.x %in% nj_20$voter_id

######### do you get a new reg date always?

inner1 <- inner_join(nj_16, nj_20, by = c("voter_id", "first_name", "street")) %>% 
  filter(last_name.x != last_name.y)

mean(inner1$reg_date.x == inner1$reg_date.y, na.rm = T)
## dont get new reg date, so we're good

##############

inner1 <- inner_join(nj_16, filter(nj_20, reg_date > "2018-08-30"), by = c("first_name", "middle_name", "last_name",
                                          "dob")) %>% 
  filter(city.x != city.y)

### IDS AREN"T CONSTANT