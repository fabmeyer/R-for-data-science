# R for Data Science - Chapter 3: Data Visualization with ggplot2

library(tidyverse)

#### First Steps ####

## 1. Run ggplot(data = mpg). What do you see?
ggplot(data = mpg)
# nothing. It just creates a white canvas with nothing
# plotted on it

## 2. How many rows are in mtcars? How many columns?
dim(mtcars)
# 32 rows, 11 columns

## 3. What does the drv variable describe? Read the help for ?mpg to find out.
?mpg
# f = front-wheel drive, r = rear-wheel drive, 4 = 4wd

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
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))
# wrong: to set an aesthetic manually
# you have to set is as an argument of the geom() function
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")
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

## 6. What happens if you map an aesthetic to something other than a variable
## name?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = hwy, y = cyl, color = displ < 5))
# =, <, >, <= and >= will check for a true/false return value
# and will encode that value with an aesthetic

#### Facets ####

## 1. What happens if you facet on a continuous variable?
ggplot(data = mpg) + geom_point(mapping = aes(x = year, y = hwy)) +
  facet_wrap(~ model, nrow = 8)
# It works actually but does not make much sense for variable with a lot of
# levels

## 2. What do the empty cells in a plot with facet_grid(crv ~ cyl) mean?
ggplot(data = mpg) + geom_point(mapping = aes(x = drv, y = cyl))
# It means that there are no observations of this combination of observed
# values. Like in this plot, there are no observations of drv = 4 together with
# cyl = 5

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

## 1. What geom would you use to draw a line chart? A boxplot? A histogram? An
## area chart?
# geom_area()
ggplot(data = mpg) + 
  geom_area(mapping = aes(x = displ, y = hwy))

## 2. Run this code in your head and predict what the output will look like.
## Then, run the code in R and check your predictions.
# plots 2 variables displ, hwy and drv as points, adds a smoother without
# standard deviation
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)

## 3. What does show.legend = FALSE do? What happens if you remove it?
## Why do you think I used it earlier in the chapter?
# removes the legend from the plot
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point(show.legend = FALSE) + 
  geom_smooth(se = FALSE, show.legend = FALSE)

## 4. What does the se argument to geom_smooth() do?
# computes a standard deviation and plots it to the graph

## 5. Will these two graphs look different? Why/why not?
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

ggplot() + 
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))
# they look the same because in the first plot mapping is set on the ggplot function
# and it will be passed to its subsequent functions

#### Statistical transformations ####

## 1. What is the default geom associated with stat_summary()?
## How could you rewrite the previous plot to use that geom function
## instead of the stat function?
# ?stat_summary(): geom_pointrange() is the default geom
ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    geom = "pointrange",
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )

## 2. What does geom_col() do? How is it different to geom_bar()?
# geom_bar() shows counts (or sum of weights)
# geom_col() can be used to show means per example

## 3. Most geoms and stats come in pairs that are almost always used in
## concert. Read through the documentation and make a list of all the pairs.
## What do they have in common?
# stat_count() is used by geom_bar() and geom_col()
# stat_bin_2d() is used by geom_bin2d()
# stat_boxplot() is used by geom_boxplot()
# stat_contour() is used by geom_contour()
# stat_sum() is used by geom_count()
# stat_density() is used by geom_density()
# stat_density_2d() is used by geom_density_2d()
# stat_bin_hex() is used by geom_hex()
# stat_bin is used by geom_freqpoly() and geom_histogram()
# stat_qq_line() is used by geom_qq_line()
# stat_qq() is used by geom_qq()
# stat_quantile() is used by geom_quantile()
# stat_smooth() is used by geom_smooth()
# stat_ydensity() is used by geom_violin()
# stat_sf() is used by geom_sf()

## 4. What variables does stat_smooth() compute? What parameters control its
## behaviour?
# stat_smooth() computes a mean value from the data and plots it as a smoothed
# line. The method arguments accepts all possible modelling functions. The span
# argument controls the smoothness of the loess smoother
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_smooth(method = lm, se = TRUE)

## 5. In our proportion bar chart, we need to set group = 1. Why? In other
## words what is the problem with these two graphs?
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop..))
# with group = 1
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))
# if you want to display a chart of proportions, you need to add group = 1

#### Position adjustments ####
## 1. What is the problem with this plot? How could you improve it?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = cty, y = hwy))
# the plot prevents overplotting by positioning them along a grid
ggplot(data = mpg) +
  geom_point(mapping = aes(x = cty, y = hwy), position = "jitter")

## 2. What parameters to geom_jitter() control the amount of jittering?
ggplot(data = mpg) +
  geom_jitter(mapping = aes(x = cty, y = hwy), width = 0.2, height = 0.2, alpha = 0.2)
# width and height control the amount of jittering

## 3. Compare and contrast geom_jitter() with geom_count().
ggplot(data = mpg) +
  geom_count(mapping = aes(x = cty, y = hwy))
# geom_count() allows to identifies the number of data on a specified place on
# the x- and y-axis by plotting the amount of data with a different sized point
# geom_count() has the argument scale_size_area
ggplot(mpg, aes(cty, hwy)) +
  geom_count() +
  scale_size(breaks = NULL) +
  scale_size_area(max_size = 10)

## 4. What’s the default position adjustment for geom_boxplot()? Create a
## visualisation of the mpg dataset that demonstrates it.
ggplot(mpg, aes(class, hwy)) +
  geom_boxplot(position = "dodge2")
# using class (a categorical variable for the x-axis)
# default position adjustement is position = "dodge"

#### Coordinate systems ####
## 1. Turn a stacked bar chart into a pie chart using coord_polar().
# create a stacked bar chart via the fill attribute that you use for
# another variable
ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = cut, fill = clarity),
    show.legend = TRUE,
    width = 0.75
  )
# convert to a pie chart via + coord_polar()
ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = cut, fill = clarity),
    show.legend = TRUE,
    width = 0.75
  ) +
  coord_polar()

## 2. What does labs() do? Read the documentation.
?labs()
# add individual labels to axes, colours, captions etc.
ggplot(mtcars, aes(mpg, wt, colour = cyl)) + geom_point(size = 10, alpha = 0.5) + 
  labs(x = "MPG", y = "WT", colour = "Cylinders", 
         caption = "(based on data from ...)")

## 3. What’s the difference between coord_quickmap() and coord_map()?
# coord_map() projects a map from the earth (3d) to 2d, using any projection method
# this means usually a more or less distorted projection
# using coord_quickmap() is a fast way to preserve straight lines in maps.

## 4. What does the plot below tell you about the relationship between city and
# highway mpg? Why is coord_fixed() important? What does geom_abline() do?
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + geom_abline() + coord_fixed() +
  expand_limits(x = c(0, NA), y = c(0, NA))
# geom_abline() shows the identity line y = x
# coord_fixed() ensures no transformation of the x- and y-axis
# with expand_limits(x = c(0, NA), y = c(0, NA)) you can show the whole range
# of the x- and the y-axis