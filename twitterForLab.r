install.packages("rtweet")
install.packages("igraph")
install.packages("dplyr")
install.packages("tidytext")
install.packages("tm")
install.packages("tidyr")
install.packages("ggraph")
install.packages("tidycensus")
install.packages("ggplot2")
install.packages("RPostgres")
install.packages("RColorBrewer")
install.packages("DBI")
install.packages("rccmisc")

#search and analyze twitter data, by Joseph Holler, 2019
#following tutorial at https://www.earthdatascience.org/courses/earth-analytics/get-data-using-apis/use-twitter-api-r/
#also get advice from the rtweet page: https://rtweet.info/
#to do anything, you first need a twitter API token: https://rtweet.info/articles/auth.html 

#install packages for twitter, census, data management, and mapping
install.packages(c("rtweet","tidycensus","tidytext","maps","RPostgres","igraph","tm", "ggplot2","RColorBrewer","rccmisc","ggraph"))


#initialize the libraries. this must be done each time you load the project
library(rtweet)
library(igraph)
library(dplyr)
library(tidytext)
library(tm)
library(tidyr)
library(ggraph)
library(tidycensus)
library(ggplot2)
library(RPostgres)
library(RColorBrewer)
library(DBI)
library(rccmisc)

help(rtweet) # put a library name or function in the help function to get help on anything!

############# FIND ONLY PRECISE GEOGRAPHIES NOVEMBER ############# 

#reference for lat_lng function: https://rtweet.info/reference/lat_lng.html
#adds a lat and long field to the data frame, picked out of the fields you indicate in the c() list
#sample function: lat_lng(x, coords = c("coords_coords", "bbox_coords"))

# list unique/distinct place types to check if you got them all
unique(november$place_type)

# list and count unique place types
# NA results included based on profile locations, not geotagging / geocoding. If you have these, it indicates that you exhausted the more precise tweets in your search parameters
count(november, place_type)

#this just copied coordinates for those with specific geographies
#do not use geo_coords! Lat/Lng will come out inverted

#convert GPS coordinates into lat and lng columns
november <- lat_lng(november,coords=c("coords_coords"))

#select any tweets with lat and lng columns (from GPS) or designated place types of your choosing
novemberGeo <- subset(november, place_type == 'city'| place_type == 'neighborhood'| place_type == 'poi' | !is.na(lat))

#convert bounding boxes into centroids for lat and lng columns
novemberGeo <- lat_lng(novemberGeo,coords=c("bbox_coords"))



############# NETWORK ANALYSIS ############# 

#create network data frame. Other options for 'edges' in the network include
novemberTweetNetwork <- network_graph(novemberGeo, c("quote"))

plot.igraph(novemberTweetNetwork, lable = NA)
#Please, this is incredibly ugly... if you finish early return to this function and see if we can modify its parameters to improve aesthetics



############# TEXT / CONTEXTUAL ANALYSIS for November ############# 

novemberGeo$text <- plain_tweets(novemberGeo$text)

novemberText <- select(novemberGeo,text)
novemberWords <- unnest_tokens(novemberText, word, text)

# how many words do you have including the stop words?
count(novemberWords)

#create list of stop words (useless words) and add "t.co" twitter links to the list
data("stop_words")
stop_words <- stop_words %>% add_row(word="t.co",lexicon = "SMART")

novemberWords <- novemberWords %>%
  anti_join(stop_words) 

# how many words after removing the stop words?
count(novemberWords)

novemberWords %>%
  count(word, sort = TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
  labs(x = "Count",
       y = "Unique words",
       title = "Count of unique words found in tweets",
       subtitle = "With 'celtics' removed")

novemberWordPairs <- novemberGeo %>% select(text) %>%
  mutate(text = removeWords(text, stop_words$word)) %>%
  unnest_tokens(paired_words, text, token = "ngrams", n = 2)

novemberWordPairs <- separate(novemberWordPairs, paired_words, c("word1", "word2"),sep=" ")
novemberWordPairs <- novemberWordPairs %>% count(word1, word2, sort=TRUE)

#graph a word cloud with space indicating association. 
#you may change the filter to filter more or less than pairs with 10 instances
novemberWordPairs %>%
  filter(n >= 20) %>%
  graph_from_data_frame() %>%
  ggraph(layout = "fr") +
  # geom_edge_link(aes(edge_alpha = n, edge_width = n)) +
  geom_node_point(color = "darkslategray4", size = 3) +
  geom_node_text(aes(label = name), vjust = 1.8, size = 3) +
  labs(title = "Word Network: November Tweet Baseline",
       subtitle = "Text mining twitter data ",
       x = "", y = "") +
  theme_void()

############# SPATIAL ANALYSIS ############# 

#get a Census API here: https://api.census.gov/data/key_signup.html
#replace the key text 'yourkey' with your own key!
Counties <- get_estimates("county",product="population",output="wide",geometry=TRUE,keep_geo_vars=TRUE, key="3d89f005b11bd0cc562da8eea31dc3ce5011a707")

#select only the states you want, with FIPS state codes in quotes in the c() list
#Warning: I missed washington DC in this list! It's selecting by FIPS codes
#look up fips codes here: https://en.wikipedia.org/wiki/Federal_Information_Processing_Standard_state_code 
EastCounties <- filter(Counties,STATEFP %in% c('54', '51', '50', '47', '45', '44', '42', '39', '37',
                                                    '36', '34', '33', '29', '28', '25', '24', '23', '22', '21', '18', '17',
                                                    '13', '12', '11', '10', '09', '05', '01') )

#map results with GGPlot
#note: cut_interval is an equal interval classification function, while cut_numer is a quantile / equal count function
#you can change the colors, titles, and transparency of points
ggplot() +
  geom_sf(data=EastCounties, aes(fill=cut_number(DENSITY,5)), color="grey")+
  scale_fill_brewer(palette="GnBu")+
  guides(fill=guide_legend(title="Population Density"))+
  geom_point(data = novemberGeo, aes(x=lng,y=lat),
             colour = 'purple', alpha = .5) +
  labs(title = "Locations For Novemebr Tweets")+
  theme(plot.title=element_text(hjust=0.5),
        axis.title.x=element_blank(),
        axis.title.y=element_blank())

############# FIND ONLY PRECISE GEOGRAPHIES DORIAN ############# 

#reference for lat_lng function: https://rtweet.info/reference/lat_lng.html
#adds a lat and long field to the data frame, picked out of the fields you indicate in the c() list
#sample function: lat_lng(x, coords = c("coords_coords", "bbox_coords"))

# list unique/distinct place types to check if you got them all
unique(dorian$place_type)

# list and count unique place types
# NA results included based on profile locations, not geotagging / geocoding. If you have these, it indicates that you exhausted the more precise tweets in your search parameters
count(dorian, place_type)

#this just copied coordinates for those with specific geographies
#do not use geo_coords! Lat/Lng will come out inverted

#convert GPS coordinates into lat and lng columns
dorian <- lat_lng(dorian,coords=c("coords_coords"))

#select any tweets with lat and lng columns (from GPS) or designated place types of your choosing
dorianGeo <- subset(dorian, place_type == 'city'| place_type == 'neighborhood'| place_type == 'poi' | !is.na(lat))

#convert bounding boxes into centroids for lat and lng columns
dorianGeo <- lat_lng(dorianGeo,coords=c("bbox_coords"))



############# NETWORK ANALYSIS ############# 

#create network data frame. Other options for 'edges' in the network include
dorianTweetNetwork <- network_graph(dorianGeo, c("quote"))

plot.igraph(dorianTweetNetwork, lable = NA)
#Please, this is incredibly ugly... if you finish early return to this function and see if we can modify its parameters to improve aesthetics



############# TEXT / CONTEXTUAL ANALYSIS for dorian ############# 

dorianGeo$text <- plain_tweets(dorianGeo$text)

dorianText <- select(dorianGeo,text)
dorianWords <- unnest_tokens(dorianText, word, text)

# how many words do you have including the stop words?
count(dorianWords)

#create list of stop words (useless words) and add "t.co" twitter links to the list
data("stop_words")
stop_words <- stop_words %>% add_row(word="t.co",lexicon = "SMART")

dorianWords <- dorianWords %>%
  anti_join(stop_words) 

# how many words after removing the stop words?
count(dorianWords)

dorianWords %>%
  count(word, sort = TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
  labs(x = "Count",
       y = "Unique words",
       title = "Count of unique words found in tweets",
       subtitle = "With 'celtics' removed")

dorianWordPairs <- dorianGeo %>% select(text) %>%
  mutate(text = removeWords(text, stop_words$word)) %>%
  unnest_tokens(paired_words, text, token = "ngrams", n = 2)

dorianWordPairs <- separate(dorianWordPairs, paired_words, c("word1", "word2"),sep=" ")
dorianWordPairs <- dorianWordPairs %>% count(word1, word2, sort=TRUE)

#graph a word cloud with space indicating association. you may change the filter to filter more or less than pairs with 10 instances
dorianWordPairs %>%
  filter(n >= 20) %>%
  graph_from_data_frame() %>%
  ggraph(layout = "fr") +
  # geom_edge_link(aes(edge_alpha = n, edge_width = n)) +
  geom_node_point(color = "darkslategray4", size = 3) +
  geom_node_text(aes(label = name), vjust = 1.8, size = 3) +
  labs(title = "Word Network: Dorian Twitter Events",
       subtitle = "Text mining twitter data ",
       x = "", y = "") +
  theme_void()

############# SPATIAL ANALYSIS ############# 

#get a Census API here: https://api.census.gov/data/key_signup.html
#replace the key text 'yourkey' with your own key!
Counties <- get_estimates("county",product="population",output="wide",geometry=TRUE,keep_geo_vars=TRUE, key="3d89f005b11bd0cc562da8eea31dc3ce5011a707")

#select only the states you want, with FIPS state codes in quotes in the c() list
#Warning: I missed washington DC in this list! It's selecting by FIPS codes
#look up fips codes here: https://en.wikipedia.org/wiki/Federal_Information_Processing_Standard_state_code 
EastCounties <- filter(Counties,STATEFP %in% c('54', '51', '50', '47', '45', '44', '42', '39', '37',
                                                    '36', '34', '33', '29', '28', '25', '24', '23', '22', '21', '18', '17',
                                                    '13', '12', '11', '10', '09', '05', '01') )

#map results with GGPlot
#note: cut_interval is an equal interval classification function, while cut_numer is a quantile / equal count function
#you can change the colors, titles, and transparency of points
ggplot() +
  geom_sf(data=EastCounties, aes(fill=cut_number(DENSITY,5)), color="grey")+
  scale_fill_brewer(palette="GnBu")+
  guides(fill=guide_legend(title="Population Density"))+
  geom_point(data = dorianGeo, aes(x=lng,y=lat),
             colour = 'purple', alpha = .5) +
  labs(title = "Locations For Dorian Tweets")+
  theme(plot.title=element_text(hjust=0.5),
        axis.title.x=element_blank(),
        axis.title.y=element_blank())


############### UPLOAD RESULTS TO POSTGIS DATABASE ###############

#Connectign to Postgres
#Create a con database connection with the dbConnect function.
#Change the database name, user, and password to your own!
con <- dbConnect(RPostgres::Postgres(), dbname='yourdatabase', host='artemis', user='yourUserName', password='yourPassword') 

#list the database tables, to check if the database is working
dbListTables(con) 

#create a simple table for uploading (I will be using the november dataset in this example)
nov <- select(novemberGeo,c("user_id","status_id","text","lat","lng"),starts_with("place"))

#write data to the database
#replace new_table_name with your new table name
#replace dhshh with the data frame you want to upload to the database 
dbWriteTable(con,'nov',nov, overwrite=TRUE)

#SQL to add geometry column of type point and crs NAD 1983: 
#SELECT AddGeometryColumn ('public','nov','geom',4269,'POINT',2, false);
#SQL to calculate geometry: update nov set geom = st_transform(st_makepoint(lng,lat),4326,4269);

#make all lower-case names for this table
ecounties <- lownames(EastCounties)
dbWriteTable(con,'ecounties',ecounties, overwrite=TRUE)
#SQL to update geometry column for the new table: select populate_geometry_columns('necounties'::regclass);

#disconnect from the database
dbDisconnect(con)
