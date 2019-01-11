library(tidyverse)
library(readxl)
library(lubridate)
library(here)
library(ggrepel)
library(scales)

######### Reading in TANF Application Data #########
app15_rec <- read_excel(here("data", "tanf-application-data", "cy2015_application_tanf.xls")
                    , range = cell_rows(5:59)
                    , col_types=c("text", rep("numeric", 13))
                    , col_names = FALSE) %>%  
                    rename(state=X__1,January=X__2,February=X__3,March=X__4,April=X__5,May=X__6,June=X__7,July=X__8,August=X__9,September=X__10,October=X__11,November=X__12,December=X__13,Average=X__14)

## Reshape to long data and filter out average by state and totals across all states.
app15_rec  %<>% 
  gather(January:Average, key='month', value='applications') %>% 
  filter(state != "U.S. Totals" & month != "Average") %>%
  mutate(month = factor(month, levels=format(ISOdate(2018,1:12,1),"%B")))


## Line charts, with log base ten, highlighting three states:
app15_rec_filtered <- filter(app15_rec, state %in% c("California", "Oregon", "Maine"))
app15_rec %>% 
  ggplot(aes(x=month, y=applications, group=state)) + 
    geom_point(alpha=0.6, color="#d2d2d2") + geom_line(alpha=0.6, color="#d2d2d2") +
    geom_point(data=app15_rec_filtered, mapping=aes(color=state)) + 
    geom_line(data=app15_rec_filtered, mapping=aes(color=state)) + 
    labs(x="Month", y="Total Applications (Log10)") +
    scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x),
                labels = trans_format("log10", math_format(10^.x)))



+ geom_text_repel(data=filter(app15_rec, month=="December"), mapping=aes(x=12, y=applications, label=state))
