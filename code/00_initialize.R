library(readxl)
library(splitstackshape)
library(readxl)
library(lubridate)
library(RSQLite)
library(kevostools)
library(data.table)
library(tidyverse)

db_full <- dbConnect(SQLite(), "E:/full_file.db")


clean_streets <- function(data, vars){
  g <- data
  g$abcd <- apply(select(data, vars), 1, 
                    function(x) paste(x[!is.na(x)], collapse = " ")
  )
  
  g <- g %>% 
    select(-vars) %>% 
    rename(street = abcd) %>% 
    mutate(street = trimws(gsub("\\s+", " ", street)))
  return(g)
}

write_db <- function(input){
  nm <- toupper(deparse(substitute(input)))
  dbWriteTable(db_full, name = nm, value = input, overwrite = T, append = F)
}

save <- c("db_full", "cleanup", "theme_bc", "save", "clean_streets", "write_db")
cleanup <- function(...){
  save2 <- c(save, ...)
  rm(list=ls(envir = .GlobalEnv)[! ls(envir = .GlobalEnv) %in% save2], envir = .GlobalEnv)
}
