## Created by Robert Kelley
# Rent by direction and distance in Boston

## "This product uses the Census Bureau Data API but is not endorsed or certified by the Census Bureau."
library('tidyverse')
library("tidytext")
library('dplyr')
library("sf")
library("RColorBrewer")
library("ggplot2")

Counties <- get_estimates(geography = "county",product="population",output="wide",geometry=TRUE,keep_geo_vars=TRUE, key="3d89f005b11bd0cc562da8eea31dc3ce5011a707")
tracts <- get_estimates(geography ="tract",product="population",output="wide",geometry=TRUE,keep_geo_vars=TRUE, key="3d89f005b11bd0cc562da8eea31dc3ce5011a707")

# This pulls MA's census data from their database with a variable included.
tarr <- get_acs(geography = "tract", variables = "B25064_001",
                state = "MA", geometry = TRUE, key="3d89f005b11bd0cc562da8eea31dc3ce5011a707")

## Extracts all tracts from one county.
bos <- tarr[grep("Suffolk", tarr$NAME), ]
#This extracts specifically the tract with city hall into its own frame.
dt <- bos[grep("Tract 303", bos$NAME), ]

# This allows me to look at all the variables and their codes to see what i want to select.
v17 <- load_variables(2017, "acs5", cache = TRUE)

# This was a hack way to see if my variable was actually what I thought it was
v17 %>% filter(name == "B25064_001")

# This creates centroids of the geometries in my data tables.
cent <- st_centroid(bos$geometry)
Cdt <- st_centroid(dt$geometry)

# These extract the coordinates of the centroids.
cent1 <- st_coordinates(cent)

cdt1 <- st_coordinates(Cdt)

## This is a detailed way to map my data as a choropleth
ggplot() +
  geom_sf(data=bos, aes(fill=cut_number(estimate,5)), color="grey",lwd = .05)+
  geom_sf(data=Cdt, aes(), lwd = .3, color = "red")+
  scale_fill_brewer(palette="GnBu")+
  guides(fill=guide_legend(title="Gross Median Rent"))+
  labs(title = "Boston's Gross Median Rent by Census Tract")+
  theme(plot.title=element_text(hjust=0.5),
        axis.title.x=element_blank(),
        axis.title.y=element_blank())

# This creates a different sort of aestetic with the same data and geometries.
plot(jdeg1["estimate"],key.width = .3, key.length=.5, main = "Median Rent by Tract")


#Direction
# This creates a data frame with the x and way coordinates of every centroid in Boston.
x <- data.frame(lon = cent1[,"Y"],
                lat = cent1[,"X"])

# This does the same for the selected centerpoint of the city.
center <- c(lon = cdt1[,"Y"],
            lat = cdt1[,"X"])

# This is the function that runs through each tract in 
#Boston and calculates its bearing towards the city hall.
robbieBear <- function(x, center){
  bear <- NULL
  for(i in 1:nrow(x)){
    bear[i] <- bearing(center, x[i, ])
  }
  return(bear)
}

# This creates a data frame on the bearings with a unique identifier connected to the tract.
deg1 <- data.frame(robbieBear(x, center), bos$GEOID)

#These modify the column names to enable a join.
colnames(deg1)[1] <- "direction"
colnames(deg1)[2] <- "GEOID"

# This joins the bearings to the main dataset.
jdeg <- left_join(bos,
                  deg1,
                  by = "GEOID")

#This turns the bearings into cardinal directions in a new column.
jdeg1 <- jdeg %>%
  mutate(cardinal = ifelse(direction >= -135 & direction < -45, "South",
                           ifelse(direction == 0, "Center",
                                  ifelse(direction >= -45 & direction < 45 & direction != 0, "East",
                                         ifelse(direction >= 45 & direction < 135, "North",
                                                "West")))))

#This creates a new variable delineating if a tract is or is not the downtown census tract.
jdeg2 <-jdeg1%>%
  mutate(center = ifelse(NAME == "Census Tract 303, Suffolk County, Massachusetts",
                         1,0))

# This extracts just the downtown tract.
jdeg4 <- jdeg2 %>%
  filter(center == 1)

#This creates a map of the cardinal directions from city hall.
ggplot() +
  geom_sf(data=jdeg1, aes(fill=cardinal), color="grey",lwd = .05)+
  geom_sf(data=Cdt, aes(), lwd = .3, color = "black") +
  labs(title = " Directions from City Hall",
       fill = "Cardinal Directions")

#This creates a map of the degrees of bearing off the city hall.
ggplot() +
  geom_sf(data=jdeg1, aes(fill=direction), color="grey",lwd = .05)+
  geom_sf(data=Cdt, aes(), lwd = .3, color = "red") +
  labs(title = " Degrees off of City Hall",
       fill = "Degrees",
       color = "City Hall")

# This creates a rough Polar Plot
jdeg1 %>%
  ggplot() + 
  geom_point(aes(estimate, direction))+
  coord_polar("y", start= 180)+
  labs(title = "Rent by direction",
       subtitle = "The two labels on the side correspond with the first and second rings.",
       x = NULL,
       y = "Median Rent")

# Distance
# This function calculates the distance from each point to the city hall tract using the classical distance formula
robbieDist <- function(x, center){
  dist <- NULL
  for(i in 1:nrow(x)){
    dist[i] <- sqrt((center[1] - x[1][i, ])^2 + (center[2] - x[2][i, ])^2)
  }
  return(dist)
}

# This creates a data frame with the distance and a unique identifier.
dist1 <- data.frame(robbieDist(x, center), bos$GEOID)

# These modify column names.
colnames(dist1)[1] <- "distdeg"
colnames(dist1)[2] <- "GEOID"

# This creates a new column that converts degrees into meters.
dist1 <- dist1 %>%
  mutate(meters = distdeg*111139)

# This joins my distance data frame to the rest of my data.
joined <- left_join(jdist1,
                    dist1,
                    by = "GEOID")

# This creates a map of distance from city hall, validating that my function worked.
ggplot() +
  geom_sf(data=joined, aes(fill=meters), color="grey",lwd = .05)+
  geom_sf(data=Cdt, aes(), lwd = .3, color = "red") +
  labs(title = " Distance from City Hall",
       fill = "Distance in Meters")

# This creates a plot of rent based on distance from city hall.
joined %>%
  ggplot(aes(x = meters,
             y = estimate))+
  geom_point()+
  labs(title = "Rent in Boston by Distance",
       x = "Distance in Meters",
       y = "Gross Median Rent (dollars)")
