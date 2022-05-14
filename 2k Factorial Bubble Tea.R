library(DoE.base)
library(readxl)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(gridExtra)
library(png)
library(cowplot)
library(magick)
library(purrr)
library(reshape2)
library(FrF2)
library(cdparcoord)
library(ggbeeswarm)

#####################
# Setup environment #
#####################


library(knitr)
library(kableExtra)
library(pixiedust)
library(caret)
library(leaps)
library(MASS)
library(rstatix)
library(flextable)

setwd('C:/Users/Wallik/Desktop/Experimental Design/Mini Project')
df <- read_xlsx('Signature Menu of Design Shop.xlsx')
df$Age = as.factor(df$Age)

dataOfAge <- as.data.frame(table(df$Age))
dataOfAge$Age <- factor(dataOfAge$Var1, levels = dataOfAge$Var1[order(dataOfAge$Freq)])

#################
# Visualization #
#################

# 0th visualization
ggparcoord(df.cup,scale = "globalminmax")+
  labs(title='Parallel Coordinate plot of All Menu in Design cafe',
       subtitle = "Tips : Each line represents each voter",
       caption = "Data collected from 4/4/65 - 5/4/65",
       tag = "Figure 0",
       x='',y='Rating score (1 to 10)',
       colour = "Gears")+
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 60, vjust = 0.9, hjust=1))

# 1st Visualization
Time.frequency <- ggplot(df, aes(x=Timestamp))+
                  geom_freqpoly(binwidth=40*60)+
                  labs(
                    title = "The Number of Voter for each time range",
                    subtitle = "The cumulative Number of voters is 63",
                    tag = "Figure 1",
                    x = "Time",
                    y = "Frequency",
                    colour = "Gears")+
                  theme_minimal()

Time.frequency


# 2nd Visualization
Age.distribution <- ggplot(dataOfAge, aes(x=Age,y = Freq, fill = Freq)) +
  coord_flip() +
  geom_bar(width=0.3,stat = "identity")+
  scale_fill_gradient(low = "#EE4B2B", high = "#50C878")+
  labs(
    title = "The Age range distribution of our voters",
    subtitle = "Total Number of voters is 63",
    caption = "Data collected from 4/4/65 - 5/4/65",
    tag = "Figure 2",
    x = "Age Range",
    y = "Frequency",
    colour = "Gears")+
  theme_minimal()

Age.distribution


# 3rd Visualization

df.cup <- df[3:10]
df.cup$type <- rownames(df.cup)

cup.index = 2
title = "The distribution of rating of Green Milk Tea"
tag = "Figure 3b"

dataOfCup <- as.data.frame(table(df.cup[,cup.index]))
dataOfCup$Cup <- factor(dataOfCup$Var1, levels = dataOfCup$Var1[order(dataOfCup$Freq)])

dataOfCup$Var1 <- as.numeric(as.character(dataOfCup$Var1))

# Milk tea scale : #ceb195 , #e5a672
# Green tea scale : #A7DB42, #77B41B

cup.distribution <- ggplot(dataOfCup, 
                           aes(x = Var1,y=Freq,fill=Freq)) + 

  geom_bar(stat = "identity")+

  labs(
    title = title,
    subtitle = 'Total Number of voters is 63',
    caption = 'Data collected from 4/4/65 - 5/4/65',
    tag = tag,
    x = 'Rating Score (1 to 10)',
    y = 'Frequency',
    colour = 'Gears')+
  scale_fill_gradient(low = '#A7DB42', high = '#77B41B')+
  scale_x_continuous(limits=c(0,11),breaks = seq(1, 10, by = 1))+
  ylim(0,20)+
  theme_minimal()+
  theme(legend.position="none",plot.margin = margin(1,1,1.5,3, "cm"))

cup.logo <- image_read("https://github.com/wallik2/BubbleTea-2k_Factorial_Design/blob/main/Menu/menu_2.png?raw=true")
cup.logo <- image_rotate(cup.logo, 10)

ggdraw() +
  draw_image(cup.logo,x=-0.4,y=-0.25,scale = 0.5) +
  draw_plot(cup.distribution)


# Boxplot
df.mod <- melt(df.cup)
df.mod
ggplot(df.mod,aes(x=variable ,y=value,fill=variable)) +
  geom_violin(alpha = 0.5) +
  labs(
    title = "The violin plot of Rating score for each menu",
    subtitle = "The Number of voters is 63",
    tag = "Figure 4",
    x = "",
    y = "Rating score",
    colour = "Gears")+
    geom_quasirandom() +
    theme_minimal()+
    theme(axis.text.x = element_text(angle = 60, vjust = 0.9, hjust=1))

####################
# Statistical test #
####################

# Setup factorial design table
df.cup <- df[3:10]

fac.design = fac.design(nlevels=c(2,2,2), nfactors=3, 
                       factor.names = list(Milk.tea.type = c("-","+"),
                                           Whip.cream  = c("-","+"),
                                           Brown.sugar = c("-","+")),
                       replications=63,randomize=FALSE)

df.cup.T <-    df.cup %>% 
  rownames_to_column() %>% 
  pivot_longer(!rowname, names_to = "col1", values_to = "col2") %>% 
  pivot_wider(names_from = "rowname", values_from = "col2")

df.cup.T <- as.data.frame(df.cup.T)
df.cup.stack <- melt(df.cup.T)
Rating <- df.cup.stack$value
colnames(df.cup.stack)[1] <- "Menu"

# Link to Rating score
df.cup <- as.data.frame(df.cup)
df.cup %>% 
  kbl() %>%
  kable_classic("basic")

fac.design <- add.response(fac.design,response=Rating)
fac.design %>% 
  kbl() %>%
  kable_classic("basic")








# Table 1 : ANOVA

Aov <- aov(value~Menu, data = df.cup.stack)

# Beautify the output
Aov <- tidy(Aov)

p_val_format <- function(x){
  z <- scales::pvalue_format()(x)
  z[!is.finite(x)] <- ""
  z
}

flextable(Aov) %>% 
  set_formatter(values = list("p.value" = p_val_format) ) %>% 
  colformat_int("df", suffix = " dof") %>% 
  # more cosmetics
  set_header_labels(term = "Term", df = "DoF",
                    "sumsq" = "Sum of squares", 
                    meansq = "Mean squared error", 
                    statistic = "F-Statistic", p.value = "p-value"
  ) %>%
  set_caption("Table 1 : The One-way ANOVA table for Design menu ",style = "Table Caption") %>%
  autofit()

# Table 2 : Post-Hoc Test : Tukey HSD
Aov <- aov(value~Menu, data = df.cup.stack)
Tukey <- TukeyHSD(Aov,conf.level = 0.95)

# Beautify the output
Tukey <- tidy(Tukey)

flextable(Tukey) %>% 
  set_formatter(values = list("adj.p.value" = p_val_format) ) %>% 
  colformat_int("df", suffix = " dof") %>% 
  # more cosmetics
  set_header_labels(term = "Term", contrast = "Contrast",
                    estimate = "Estimate", 
                    conf.low = "Low C.I.", 
                    conf.high = "High C.I.", 
                    adj.p.value = "p-value"
  ) %>%
  set_caption("Table 2 : The Tukey HSD Test table of every pairs of Design menu ",style = "Table Caption") %>%
  autofit()


# Estimated Full regression model 
model <- fac.design$Rating~fac.design$Milk.tea.type*fac.design$Whip.cream*fac.design$Brown.sugar
fit = aov(model)
fit.lm <- lm(model)


# Model Adequacy Checking

# ASM.1.Independent ?
plot(fit.lm$residuals,
     main='The residual plot of the estimated model',
     ylab = 'residuals',
     xlab = 'Run order')
abline(h = 0,col = 'red',lty = 2)

# ASM.2.Normal ?
qqnorm(fit.lm$residuals,xlab="Normal Quantiles",ylab="Residuals")
qqline(fit.lm$residuals, col = "blue")

shapiro_test(fit.lm$residuals)

# ASM.3.Homo Variance ?
bartlett.test(resid(fit.lm)~fac.design$Brown.sugar)

# Check the p-value via F-test
dust(eff.model) %>% 
  sprinkle(col = 2:4, round = 3) %>% 
  sprinkle(col = 5, fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", 
                    estimate = "Estimate", 
                    std.error = "SE",
                    statistic = "T-statistic", 
                    p.value = "P-value") %>%
  kable() %>%
  kable_styling()


# (Decided to) Performing Subset Regression
models <- regsubsets(Rating~Milk.tea.type*Whip.cream*Brown.sugar, data = fac.design)
summary(models)

res.sum <- summary(models)

# Check the best number of features (based on 3 metrics)
data.frame(
  Adj.R2 = which.max(res.sum$adjr2),
  CP = which.min(res.sum$cp),
  BIC = which.min(res.sum$bic)
)

### 5 features are the best wrp. to adj. R^2



# create the optimal model (with 5 features) 
formula = fac.design$Rating ~ fac.design$Milk.tea.type + 
  fac.design$Whip.cream + fac.design$Brown.sugar + fac.design$Milk.tea.type:fac.design$Brown.sugar + 
  fac.design$Whip.cream:fac.design$Brown.sugar

fit.lm.opt <- lm(formula)

# Model Adequacy Checking on new model (2)

# ASM.1.Independent ?
plot(fit.lm.opt$residuals,
     main='The residual plot of the estimated model',
     ylab = 'residuals',
     xlab = 'Run order')
abline(h = 0,col = 'red',lty = 2)

# ASM.2.Normal ?
qqnorm(fit.lm.opt$residuals,xlab="Normal Quantiles",ylab="Residuals")
qqline(fit.lm.opt$residuals, col = "blue")

shapiro_test(fit.lm.opt$residuals)

# ASM.3.Homo Variance ?
bartlett.test(resid(fit.lm.opt)~fac.design$Brown.sugar)


########################
# 2^3 Factorial Design #
########################

# Cube plot
cubePlot(obj = fac.design, eff1 = 'Milk.tea.type',
         eff2 = 'Whip.cream',
         eff3 = 'Brown.sugar')


# Average effects model
MEPlot(fac.design,
       main="Main effects plot matrix for the rating score")
IAPlot(fac.design,
       main="Interaction effects plot matrix for the rating score")


# Construct regression model

# Ignore interaction effect model
fit.lm.eff <- lm(data=fac.design,
             formula = Rating~Milk.tea.type + Whip.cream + Brown.sugar)

summary(fit.lm.eff)


# Model Adequacy Checking on effects model (3)

# ASM.1.Independent ?
plot(fit.lm.eff$residuals,
     main='The residual plot of the estimated model',
     ylab = 'residuals',
     xlab = 'Run order')
abline(h = 0,col = 'red',lty = 2)

# ASM.2.Normal ?
qqnorm(fit.lm.eff$residuals,xlab="Normal Quantiles",ylab="Residuals")
qqline(fit.lm.eff$residuals, col = "blue")

shapiro_test(fit.lm.eff$residuals)

# ASM.3.Homo Variance ?
bartlett.test(resid(fit.lm.eff)~fac.design$Brown.sugar)

