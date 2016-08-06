# Phase 1 Notes

## Missing value analysis
Cabin seems to have the highest missing values followed by age. An interesting note about Cabin is
that there are repeated cases in it, e.g. by those in the same family.

Why is Cabin important?
- Cabin is important as it may highlight regions of the boat that was susceptible to the iceberg
  which may in turn affect survival rates.

Why was most of the Cabin entries missing?
- Perhaps privacy, it may be in the best interest of the passangers that whoever has access to this
  list not know the locations of passangers.
- Although... I would assume that when signing off someone has a record of which cabin each
  passanger belongs to (just like in a hotel?)
- Even so the ones that were filled up were done by families, perhaps this is necessary in order to
  locate family members in times of emergency.

Why is age important?
- Reports show that women and children were most likely to survive, it may have a correlation with
  survival rates.

Why was age missing?
- In several data sets, age often has a high missing value rate. Again this may be a privacy thing.
- Though I don't see why people will hide the age of their children, so it may be useful to
  identify children

## Data Analysis
Perform the following:
- Correlation plot between all variables
- Particularly interested in:
    - What is the relationship between Pclass and Fare?
    - What is the significance of the tickets with non-numbers?
    - Examine the claim of women and children have higher survival rate?
    - What is the survival rate of families vs individuals?
    - what is the survival rate based on Pclass? (Perhaps split this by group to get an unbiased
      figure)

Correlation Plots show some interesting observations:
- Females have a much higher chance of survival
- More Males than females
- The person with the highest fare survived
- Fare has a slight positive correlation with survival
- Some variables may need to be turned into factors, since these graphs seem a bit weird

## Initial Models
- Re-create simple python model for gender survival rate in R
- Run simple random forest model in R
- Run sample python scripts to see what they do
