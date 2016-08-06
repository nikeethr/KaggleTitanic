# Temporary directory - to be removed
setwd("C:/Users/Nikeeth/Documents/Learning/Kaggle/Titanic/repo/KaggleTitanic/Scripts")
#@todo: try to get this to work:
#source("../UsefulCode/ggcorplot.R")
library(VIM)
library(ggplot2)
library(GGally)

####################################################################################################
LoadData <- function(){
    # Loads the data and dumps them into the main environment
    df_gender_class <<- read.csv("../Data/genderclassmodel.csv", header=T)
    df_gender_model <<- read.csv("../Data/gendermodel.csv", header=T)
    df_test <<- read.csv("../Data/test.csv", header=T, na.strings = "")
    df_train <<- read.csv("../Data/train.csv", header=T, na.strings = "")
}

GenerateMissingValuePlots <- function(df){
    # Plot 1: Aggregate plot shows a summary of the missing data
    aggr_plot <- aggr(df, 
        col=c('navyblue', 'red'),
        numbers=TRUE,
        sortVars=TRUE,
        labels=names(df),
        cex.axis=.7,
        gap=3,
        cex.numbers = 0.9,
        ylab=c("Histogram of missing data", "Pattern"))

    # Plot 2: Image plot gives an idea of the missing data pattern
    image(is.na(df))
}

GeneratePairwisePlot <- function(df){
    ggpairs(data = df, columns = c("Fare","Age","Sex","Survived"))
    #ggcorr(df, palette = "RdBu", label = TRUE)
    #@todo: try to get this to work:
    #ggcorplot(data = df)
}

# Helper function to reset par
resetPar <- function() {
    dev.new()
    op <- par(no.readonly = TRUE)
    dev.off()
    return(op)
}
####################################################################################################

LoadData()
GenerateMissingValuePlots(df_train)
GeneratePairwisePlot(df_train)
