# Final Project

Here is a [link](index.md) back to the home page

### GIS, statistics, and R- cross platform replicability and transparency

I am interested in exploring how to do many of the actions/topics covered this semester in R. This might include spatial analysis, database management, basic mapping, probability functions, and maybe more. In class we have already begun exploring how to add files to a database using R, but I am still interested in finding ways to push the limit of that knowledge. Related topics that we have covered in class include replicability (how switching software affects the possibility of reenacting work) and how to manage variability in data/representation. One of the greatest possible strengths of R is the capacity to write out the code for an entire problem and then run it, either in pieces or in its entirety. I am interested to see how much it would be reasonable to do in one workflow in R which draws on how we began to use SQL in our work.

Academic resources I might use include:

The chapter on Error evaluation and tracking

Accounting for Spatial Uncertainty in Optimization with Spatial Decision Support Systems

Social vulnerability indices A comparative assessment using uncertainty and sensitivity analysis

Uncertainty Analysis for a Social Vulnerability Index

The main thrust of what I am interested in doing is replicating some of the prcesses that we have done in a different software format.


## Planning Stage

Replicate the first lab in RStudio, and then make it into a shiny app that allows people to play with different data inputs. A stretch goal would be to allow for different geographies.

The main next step that will make this lab challenging is to push ways to pull data directly from the census beaureau to allow for increased possibilities for users. What will make this challenging is fitting it inside a shiny app.

The data is going to come from the US census beaureau. I am going to use the ACS 5-year data because the 2010 census is 9 years out of date at this point. The ACS data has been taken on a rolling basis, and the 5-year dataset uses the last 5 years to statistically describe geographic areas. Important fields will be total population and race populations. To get the geographic boundaries, I am planning to follow a similar workflow to the Sharpie Lab. The column name that I believe I will need for joins will be named id2, although I may have to change some names to make that work. The workflow itself is going to be the same as lab 1, except with the intent to open up the data inputs to the use and to put the result online.

Maybe use the spdebt function? This is not the purpose of the lab, just my interest.

# The project

## Methods

```tarr <- get_acs(geography = "tract", variables = "B25064_001",
                state = "MA", geometry = TRUE, key="3d89f005b11bd0cc562da8eea31dc3ce5011a707")
```
