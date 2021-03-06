library(tidyverse)
library(readxl)
library(lubridate)
library(here)
library(ggrepel)
library(gghighlight)
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

glimpse(app15_rec)
## Basic Dplyr Review:
#### Define dataframe once, refer to column names freely (no need for $):
#### Chain functions with %>%
#### Assignment with <- or %<>%
app15_rec %>%
  group_by(state) %>%
  summarize(average_apps=mean(applications, na.rm=TRUE),
            total_apps=sum(applications)) %>%
  arrange(-total_apps) %>%
  filter(average_apps > 5000)






## Line charts, with log base ten, highlighting three states:
app15_rec_filtered <- filter(app15_rec, state %in% c("California", "Oregon", "Maine"))
p1 <- app15_rec %>% 
  ggplot(aes(x=month, y=applications, group=state)) + 
    geom_point(size=0.5, alpha=0.6, color="#d2d2d2") + geom_line(alpha=0.6, color="#d2d2d2") +
    geom_point(data=app15_rec_filtered, mapping=aes(color=state), size=0.5) + 
    geom_line(data=app15_rec_filtered, mapping=aes(color=state)) + 
    labs(title="These States Don't Stick Out Much",subtitle="Really nothing special about Maine",x="Month", y="Total Applications (Log10)") +
    scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x),
                labels = trans_format("log10", math_format(10^.x))) +
    scale_x_discrete(expand=c(0,0)) + 
    geom_text_repel(data=filter(app15_rec_filtered, month=="December"), 
                    mapping=aes(x=5, y=applications, label=state, color=state)) + 
    theme(axis.text.x=element_text(angle=45, hjust=1),
          legend.position="none")


## Or, create a new column and use that:
app15_rec <- mutate(app15_rec, highlight_state = state %in% c("California", "Oregon", "Maine"))

table(app15_rec$highlight_state)

p2 <- app15_rec %>% 
  ggplot(aes(x=month, y=applications, group=state, color=highlight_state)) + 
  geom_point(size=0.5, alpha=0.6) + geom_line(alpha=0.6) +
  labs(title="These States Don't Stick Out Much",subtitle="Really nothing special about Maine",x="Month", y="Total Applications (Log10)") +
  scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x),
                labels = trans_format("log10", math_format(10^.x))) +
  scale_x_discrete(expand=c(0,0)) + 
  scale_color_manual(values=c("#cccccc", "blue")) +
  theme(axis.text.x=element_text(angle=45, hjust=1),
        legend.position="none")



## Save with ggsave to PDF:
ggsave(here("output","plot1.pdf"), p1)

