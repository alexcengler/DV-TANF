library(here)
library(tidyverse)
library(readxl)


######### Reading in TANF Application Data #########
app15_rec <- read_excel(here("data", "tanf-application-data", "cy2015_application_tanf.xls")
                    , range = cell_rows(5:59)
                    , col_types=c("text", rep("numeric", 13))
                    , col_names = FALSE) %>%  
                    rename(state=X__1,January=X__2,February=X__3,March=X__4,April=X__5,May=X__6,June=X__7,July=X__8,August=X__9,September=X__10,October=X__11,November=X__12,December=X__13)

