# Temporary directory - to be removed
setwd("C:/Users/Nikeeth/Documents/Learning/Kaggle/Titanic/repo/KaggleTitanic/Scripts")
#@todo: try to get this to work:
#source("../UsefulCode/ggcorplot.R")
library(VIM)
library(ggplot2)
library(gridExtra)
library(GGally)
library(dplyr)
library(RColorBrewer)
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

GenerateHistPlotFareVersusPclass <- function(df, split_plots = T){
    # @todo: needs work on the colours for non-split plot
    g <- ggplot(data = df, aes(x = Fare, fill = Pclass, color = Pclass))
    geom_hist <- geom_histogram(binwidth = 15)
    geom_freq <- geom_freqpoly(size = 1.25, binwidth = 5)

    if (split_plots){
        g_hist <- g + geom_hist
        g_freq <- g + geom_freq
        grid.arrange(g_hist, g_freq, nrow = 2)
    } else {
        g + geom_hist + geom_freq
    }

    resetPar()
}

ExtractNonNumericTickets <- function(df){
    ind <- regexpr("[0-9]{2,}", df$Ticket)
    split_ticket_number <- substring(df$Ticket, ind)
    split_ticket_prefix <- substring(df$Ticket, 1, ind-1)

    df$TicketNumber <- split_ticket_number
    df$TicketPrefix <- as.factor(split_ticket_prefix)

    survival_vs_prefix_table <- table(df$TicketPrefix, df$Survived)
    print(survival_vs_prefix_table)
    survival_vs_prefix_table <- as.data.frame(survival_vs_prefix_table)
    names(survival_vs_prefix_table) <- c("TicketPrefix", "Survived", "Freq")

    g <- ggplot(survival_vs_prefix_table, aes(x = TicketPrefix, y = Freq, fill = Survived)) +
        geom_bar(stat = "identity")
    print(g)

    return(df)
}

SurvivalOfFemalesAndChildren <- function(df){
    cat("--------------------------------------------------\n")
    cat("Survival of Females, Children and Families\n")
    cat("--------------------------------------------------\n")

    # Box plots
    # Define children as <= 16 arbitrarily
    children <- df$Age <= 16
    female <- df$Sex == "female"
    female_children <- children & female
    male_children <- children & !female
    female_adults <- !children & female
    male_adults <- !children & !female
    df$PCat <- NA
    df$PCat[female_children] = "female child"
    df$PCat[male_children] = "male child"
    df$PCat[female_adults] = "female adult"
    df$PCat[male_adults] = "male adult"

    df$HasFamily <- NA
    df$HasFamily = df$SibSp > 0 | df$Parch > 0

    df$PCat <- factor(df$PCat)
    df$HasFamily <- factor(df$HasFamily)
    # dplyr group by PCat, Family, and get mean of survival

    df$Survived <- as.numeric(df$Survived) - 1

    result <- as.data.frame(df %>% 
                            group_by(HasFamily, PCat) %>% 
                            summarise(Count = n(), 
                                      SurvivalRate = mean(Survived, 
                                                          na.rm=T)))

    print(result)

    g <- ggplot(result, aes(x=PCat, y=SurvivalRate, fill = PCat)) +
        geom_bar(stat = "identity") +
        facet_grid(HasFamily~.) +
        scale_fill_brewer(palette = "Set1")

    print(g)

    return(result)
    # plot the resultant table (as.dataframe)
}

SurvivalRateByPclass <- function(df){
    cat("--------------------------------------------------\n")
    cat("Survival Rate by Pclass and Fare\n")
    cat("--------------------------------------------------\n")

    fare.cut <- cut(df$Fare, breaks = c(0,10,20,30,100,Inf), right = F)
    df$FareGroup <- fare.cut

    df$Survived <- as.numeric(df$Survived) - 1

    result <- as.data.frame(df %>% 
                            group_by(FareGroup, Pclass)%>% 
                            summarise(Count = n(), 
                                      SurvivalRate = mean(Survived, 
                                                          na.rm=T)))
     
    print(result)
    g <- ggplot(result, aes(x=FareGroup, y=SurvivalRate, fill = Pclass)) +
        geom_bar(stat = "identity", position = position_dodge()) +
        scale_fill_brewer(palette = "Set1")
    print(g)
}

FactorData <- function(df_train, df_test){
    FactorDataHelper <- function(df, is_train){
        if (is_train) df$Survived <- factor(df$Survived)
        df$Pclass <- factor(df$Pclass, levels = c(3,2,1), ordered = T)
        return(df)
    }
    df_train <- FactorDataHelper(df_train, T)
    df_test <- FactorDataHelper(df_test, F)

    return(list(df_train, df_test))
}

# Helper function to reset par
resetPar <- function() {
    dev.new()
    op <- par(no.readonly = TRUE)
    dev.off()
    return(op)
}
####################################################################################################
# @todo: Seperate operations that manipulate training set and repeat them for testing set. This
# should be done in Preprocessing.R [for future reference]
LoadData()
GenerateMissingValuePlots(df_train)
result <- FactorData(df_train, df_test)
df_train <- result[[1]]
df_test <- result[[2]]
GeneratePairwisePlot(df_train)
GenerateHistPlotFareVersusPclass(df_train)
df_train <- ExtractNonNumericTickets(df_train)
result <- SurvivalOfFemalesAndChildren(df_train)

# (nikeethr)TODO: These are temporary operations to be moved to a different file later they are
# here for now for convenience sake.
# (nikeethr)TODO: Refactor analysis by combining the various important aspects, i.e.
# Tickets, Family children, Pclass, Fare etc. and make an educated guess for the classifier
# Do the same with rpart incorporating all the variables
# (nikeethr)TODO: Reformat into google style
