# R for Data Science - Chapter 1: Data Visualization with ggplot2

library(tidyverse)

#### First Steps ####

## 1. Run ggplot(data = mpg). What do you see?
ggplot(data = mpg) # nothing. It just creates a white canvas with nothing plotted on it

## 2. How many rows are in mtcars? How many columns?
dim(mtcars) # 32 rows, 11 columns

## 3. What does the drv variable describe? Read the help for ?mpg to find out.
?mpg # f = front-wheel drive, r = rear-wheel drive, 4 = 4wd

## 4. Make a scatterplot of hwy versus cyl.
ggplot(data = mpg) + geom_point(mapping = aes(x = hwy, y = cyl))
# scatterplots (geom_point()) are usually used for displaying the relationship
# between 2 continuous or 1 continuous and 1 categorical variable

## 5. What happens if you make a scatterplot of class versus drv?
## Why is the plot not useful?
ggplot(data = mpg) + geom_point(mapping = aes(x = class, y = drv))
# both class and drv are categorial variables

#### Aesthetic Mappings ####

## 1. What's gone wrong with this code? Why are the points not blue?
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))
# wrong: to set an aesthetic manually
# you have to set is as an argument of the geom() function
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy), color = "blue")
# right

## 2. Which variables in mpg are categorical? Which variables are continuous?
?mpg
str(mpg)
# categorical: manufacturer, model, trans, drv, fl, class
# continuous / numerical: displ
# continuous / integer: year, cyl, cty, hwy

## 3. Map a continous variable to color, size and shape. How do these
## aesthetics behave differently for categorical versus continuous variables?
ggplot(data = mpg) + geom_point(mapping = aes(x = hwy, y = cyl, color = displ))
# color, size and shape are better suited for numerical data
# A continuous variable can not be mapped to shape

## 4. What happens if you map the same variable to multiple aesthetics?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = hwy, y = cyl,
                           color = class, size = class, shape = class))

## 5. What does the stroke aesthetics do? What shapes does it work with?
?geom_point
# For shapes that have a border (like 21), you can colour the inside and
# outside separately. Use the stroke aesthetic to modify the width of the
# border
ggplot(data = mtcars, aes(wt, mpg)) +
  geom_point(shape = 21, colour = "pink", fill = "white", size = 3, stroke = 3)

## 6. What happens if you map an aesthetic to something other than a variable name?
ggplot(data = mpg) + geom_point(mapping = aes(x = hwy, y = cyl, color = displ < 5))
# =, <, >, <= and >= will check for a true/false return value
# and will encode that value with an aesthetic

#### Facets ####

## 1. What happens if you facet on a continuous variable?
ggplot(data = mpg) + geom_point(mapping = aes(x = year, y = hwy)) +
  facet_wrap(~ model, nrow = 8)
# It works actually but does not make much sense for variable with a lot of levels

## 2. What do the empty cells in a plot with facet_grid(crv ~ cyl) mean?
ggplot(data = mpg) + geom_point(mapping = aes(x = drv, y = cyl))
# It means that there are no observations of this combination of observed values
# Like in this plot, there are no observations of drv = 4 together with cyl = 5

## 3. What plots does the following code make? What does the . do?
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ .)
# makes a facet with just one variable (like facet_wrap())
# facet variable is horizontally aligned
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(. ~ drv)
# facet variable is vertically aligned
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ drv)
# identical plots

## 4. Take the first faceted plot in this section:
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)
## What are the advantages to using faceting instead of the color aesthetic?
# Advantages: can display more plots than colors to distinct
## What are the disadvantages?
# Disadvantages: gets also confusing by high numbers of plots

## 5. Read ?facet_wrap. What does nrow do? What does ncol do?
# nrow = number of rows, ncol = number of collumns
## What other options control the layout of the individual panels?
# shrink, as.table, strip.position, drop, dir

#### Geometric Objects ####
