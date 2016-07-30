setwd("../Data")

library(VIM)

####################################################################################################
LoadData <- function(){
    # Loads the data and dumps them into the main environment
    df_gender_class <<- read.csv("genderclassmodel.csv", header=T)
    df_gender_model <<- read.csv("gendermodel.csv", header=T)
    df_test <<- read.csv("test.csv", header=T, na.strings = "")
    df_train <<- read.csv("train.csv", header=T, na.strings = "")
}

PlotMissingValueImage <- function(df){
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

# Helper function to reset par
resetPar <- function() {
    dev.new()
    op <- par(no.readonly = TRUE)
    dev.off()
    return(op)
}
####################################################################################################

LoadData()
PlotMissingValueImage(df_train)
