library(ggplot2)
library(readr)
library(tidyr)

# Read in the data
mtcars <- read.csv("new_mtcars.csv")

# Modify the data
mtcars_g <- gather(mtcars)

# Save the modified data to disk
write.csv(mtcars_g, "new_mtcars_gathered.csv")

# Make a plot and save it to disk
ggplot(mtcars_g, aes(key, value)) + geom_boxplot()
ggsave("new_mtcars_g.png", width = 6, height = 4)

