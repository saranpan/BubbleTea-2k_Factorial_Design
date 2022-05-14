2^k Full factorial design is well known as one of the popular design analysis which used to analyze k factors which each factors are fixed to have just 2 levels, In this experimental design have 3 factors: 

# Bubble Tea 2^3 Full Factorial Design
## Experimental design with R

[![AllMenu](https://github.com/wallik2/BubbleTea-2k_Factorial_Design/blob/main/Menu/%E0%B8%A3%E0%B8%A7%E0%B8%A1%E0%B9%80%E0%B8%A1%E0%B8%99%E0%B8%B9.jpg?raw=true)]()


2^k Full factorial design is well known as one of the popular design analysis which used to analyze k factors which each factors are fixed to have just 2 levels, In this experimental design have 3 factors: 

- 🍵 Milk tea type (plain/green tea) 🍵
- 🍦 Whip Cream (yes/no) 🍦
- 🍩 Brown Sugar (yes/no) 🍩

With respect to these factors, we can conduct 2^3 full factorial design, hence we can obtain 8 (treatment) combinations, as you can see in the above picture. However, we need to know which combination deserves to be the best signature menu, so we could attract most of our customers. We have been thinking about collecting the data by asking for the rating score for each of these 8 cups via Google Form. The anonymized dataset have been uploaded here.
- [Dataset] 

If you would like to use this dataset for any kind of purpose, please give us a credit too.

After we have done analyzing our data, we found out that the Milk tea with every topping deserves sto be the signature menu due to the highest overall rating score, furthermore, we found out that there is none of any interaction effects, while there are 3 main effects (with 95% confidence level).

## Dataset
Let's obtaining a breif information of our dataset first before we conduct our 2^3 factorial design, and the limitation of uses from our metadata

[![PAP](https://github.com/wallik2/BubbleTea-2k_Factorial_Design/blob/main/Plot/1-PAP.png?raw=true)]()

The above plot shows the Parallel coordinate plot which visualize every observation within one graph (tips: one line represent one observation)

[![Time](https://github.com/wallik2/BubbleTea-2k_Factorial_Design/blob/main/Plot/2-Timeline.png?raw=true)]()

Our Dataset was collected from 4/4/65 to 5/4/65 (Note that every voters are Thai)

[![Age](https://github.com/wallik2/BubbleTea-2k_Factorial_Design/blob/main/Plot/3-AgeRange.png?raw=true)]()

Most of our voters age are around 19-22, but what about the distribution of the rating score of every menu?

[![dist1](https://github.com/wallik2/BubbleTea-2k_Factorial_Design/blob/main/Plot/4-Dist1.png?raw=true)]()
[![dist2](https://github.com/wallik2/BubbleTea-2k_Factorial_Design/blob/main/Plot/4-Dist2.png?raw=true)]()
[![dist3](https://github.com/wallik2/BubbleTea-2k_Factorial_Design/blob/main/Plot/4-Dist3.png?raw=true)]()
[![dist4](https://github.com/wallik2/BubbleTea-2k_Factorial_Design/blob/main/Plot/4-Dist4.png?raw=true)]()
[![dist5](https://github.com/wallik2/BubbleTea-2k_Factorial_Design/blob/main/Plot/4-Dist5.png?raw=true)]()
[![dist6](https://github.com/wallik2/BubbleTea-2k_Factorial_Design/blob/main/Plot/4-Dist6.png?raw=true)]()
[![dist7](https://github.com/wallik2/BubbleTea-2k_Factorial_Design/blob/main/Plot/4-Dist7.png?raw=true)]()
[![dist8](https://github.com/wallik2/BubbleTea-2k_Factorial_Design/blob/main/Plot/4-Dist8.png?raw=true)]()

We observed that when adding topping slightly increase the overall rating score. Furthermore, we observed that most of our voters prefer Plain milk tea than green. We hope this samples can represent the rating score of Thai teen in which age is around 19-22 years. 

## 2^3 Full factorial Design

First of all, we set the low (-) and high (+) level for each treatment combination, as the following.

[![design](https://github.com/wallik2/BubbleTea-2k_Factorial_Design/blob/main/Plot/8-Design.png?raw=true)]()

We set low and high level as the following:
- 🍵  Plain milk tea type as low level, while Green as high level 🍵 
- 🍦 No Whip cream as low level, while have Whip Cream as high level 🍦 
- 🍩 No Brown sugar as low level, while have Brown sugar as high level 🍩

[![cubep](https://github.com/wallik2/BubbleTea-2k_Factorial_Design/blob/main/Plot/9-CubePlot.png?raw=true)]()
Cube plot represents the average score of each treatment combination. 

There are two types of effects; Main and Interaction effect:
We analyze the main effect by observaing the alone factor.

[![maine](https://github.com/wallik2/BubbleTea-2k_Factorial_Design/blob/main/Plot/10-MainEff.png?raw=true)]()

Above plot, we observe that the plain milk tea type average score tends to be significantly higher than green with our naked eye. While Have whipCream and Have Brown sugar are both better. We quietly assume that there should be 3 main effects, but that is not statistically robust, so will conduct another statistical test to verify the significance


[![interace](https://github.com/wallik2/BubbleTea-2k_Factorial_Design/blob/main/Plot/11-IntrcEff.png?raw=true)]()

However, None of interaction effects are significant. With a good rule of thumb, if there is an interaction effect, their line are likely to be crossing. 

If we fit the regression model to this data, we obtain

[![reg](https://github.com/wallik2/BubbleTea-2k_Factorial_Design/blob/main/Plot/16-reg-model.png?raw=true)]()

However, some coefficient might not be significant enough, so we decided to use Analysis of Variance (ANOVA) to test for both main effects and interactions. Let's say we accept the Type I error less than 0.05

[![ANOVA](https://github.com/wallik2/BubbleTea-2k_Factorial_Design/blob/main/Plot/12-ANOVA.png?raw=true)]()

According to the ANOVA table, we observe that all main effects of every factor are not zero, while there seems to be insufficient evidence to conclude that there is an interaction effect. Not even one interaction!

Again, ANOVA might not be appropriate for our design, so we better have to do model adequacy checking from the residual our model made

#### ✔️Assumption 1 : The residual is independent
[![indp](https://github.com/wallik2/BubbleTea-2k_Factorial_Design/blob/main/Plot/13-Indp.png?raw=true)]()
Comment: with our naked eye, we think the positive and negative residual are independent. (However, we slightly observe that the model often overestimate the rating score)

#### ❌ Assumption 2 : The residual is normally distributed
[![QQ](https://github.com/wallik2/BubbleTea-2k_Factorial_Design/blob/main/Plot/14-QQ.png?raw=true)]()

[![shap](https://github.com/wallik2/BubbleTea-2k_Factorial_Design/blob/main/Plot/14-Shapiro.png?raw=true)]()

Comment: There is only 0.0000951 % chance that the residual is actually normally distributed. In practice, it is not significant enough to conclude that it is normally distributed.

#### ✔️Assumption 3:  The variance of residual is the same for any factor
[![bar1](https://github.com/wallik2/BubbleTea-2k_Factorial_Design/blob/main/Plot/15-Barlett1.png?raw=true)]()

[![bar2](https://github.com/wallik2/BubbleTea-2k_Factorial_Design/blob/main/Plot/15-Barlett2.png?raw=true)]()

[![bar3](https://github.com/wallik2/BubbleTea-2k_Factorial_Design/blob/main/Plot/15-Barlett3.png?raw=true)]()

---

It turns out that the effect model violates the second assumption. We conclude that the residual is not normally distributed with 95% confidence level.


However, everything is possible, in case that 0.0000951 % that the residual is actually normally distributed is true but got rejected, then it leads us to construct the following effects model.

Hence, we decided to drop all of the interaction effects due to the p-value being less than the alpha level.

[![last-reg](https://github.com/wallik2/BubbleTea-2k_Factorial_Design/blob/main/Plot/17-last-reg.png?raw=true)]()


The interpretation of this model is that when the cup is green tea, the mean of rating score is reduced by 0.56944, when the cup has whip cream, the mean of rating score is increased by 0.426459. Similarly,  has brown sugar will increase the mean of rating score by 0.30357

[![winner](https://github.com/wallik2/BubbleTea-2k_Factorial_Design/blob/main/Menu/menu_7.png?raw=true)]()
Regarding the effects model, we can conclude that the cup that deserves to be the signature menu is Milk tea + whip cream + brown sugar. In which the mean of rating score is

 6.46627 - 0.56944(0)  +0.42659 (1) +0.30357 (1) = 7.19643
 
 [![loser](https://github.com/wallik2/BubbleTea-2k_Factorial_Design/blob/main/Menu/menu_2.png?raw=true)]()
Oppositely, it is most unlikely that the green milk tea will be the signature menu, since its mean of the rating score is the lowest ( 6.46627 - 0.56944(1) = 5.89683 ) among other cups.




Anyway, We do not recommend to use our effects model to apply to the real world uses, due to many statistics violation. For example, we have to let the people to assume that 0.0000951 % that the residual is actually normally distributed is true. 

So, In future, we will develop the statistical model which is used to handle our data better.

# Acknowledgement

We would like to acknowledge these people for taking google form and consent to have their name publicly visible as a part of contribution.

1. ธรรมธัช โคตมี

2. ณัฐกุล คงสระ

3. จิตวัต พันธ์ไพศาล

4. พิชชญามญช์ ส.สกุล

5. สิโรฒม์ ติสสพงษ์กุล

6. เจตณัฐ รอดประเสริฐ

7. ณัชชา เมืองสมบูรณ์

8. พิชชาภา รุ่งหลำ



# Limitation

1. The taste of the milk tea menu does not affect the rating score, only the visualization of the menu does.

2. The people who took our google form are mostly friends of Saran and Pornnapa, so this dataset may or may not represent Thai people well enough.

3. Most of the people who took our form are 19-22 and Thai, so the signature menu may not apply well to the other age range and other countries.
4. The model we created relies on the assumption which state that 0.0000951 % that the residual is actually normally distributed is true but got rejected, then it leads us to construct the following effects model. 

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)
   [Dataset]: <https://rpubs.com/wallik/887563>

