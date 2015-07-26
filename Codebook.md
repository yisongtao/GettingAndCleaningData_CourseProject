---
title: "Codebook"
author: "yisong"
date: "July 25, 2015"
output: 
  html_document: 
    keep_md: yes
---

This is the codebook for the tidy dataset created by run_analysis.R.

| Variables | Description |
| --------- |:-----------:|
| subject | ID of the subject whose activity has been recorded |
| activity | Activity name |
| fDomain | feature: Time domain signal or Frequency domain signal (Time of Freq) |
| fDevice | feature: Measuring device (Accelerometer of Gyroscope) |
| fAcceleration | feature: Acceleration signal (Body or Gravity) |
| fVariable | feature: (Mean or SD) |
| fJerk | feature: Jerk signal |
| fMagnitude | feature: Magnitude of the signal |
| fAxis | feature: signal in X, Y and Z directions (X, Y or Z) |
| count | number of datapoints used to compute variable average |
| average | Average of each variable for each activity and each subject |

Dataset structure

```r
str(dtTidy)
```

```
## Classes 'data.table' and 'data.frame':	11880 obs. of  11 variables:
##  $ subject      : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ activityName : Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ fDomain      : Factor w/ 2 levels "Time","Freq": 1 1 1 1 1 1 1 1 1 1 ...
##  $ fAcceleration: Factor w/ 3 levels NA,"Body","Gravity": 1 1 1 1 1 1 1 1 1 1 ...
##  $ fDevice      : Factor w/ 2 levels "Accelerometer",..: 2 2 2 2 2 2 2 2 2 2 ...
##  $ fJerk        : Factor w/ 2 levels NA,"Jerk": 1 1 1 1 1 1 1 1 2 2 ...
##  $ fMagnitude   : Factor w/ 2 levels NA,"Magnitude": 1 1 1 1 1 1 2 2 1 1 ...
##  $ fVariable    : Factor w/ 2 levels "Mean","SD": 1 1 1 2 2 2 1 2 1 1 ...
##  $ fAxis        : Factor w/ 4 levels NA,"X","Y","Z": 2 3 4 2 3 4 1 1 2 3 ...
##  $ count        : int  50 50 50 50 50 50 50 50 50 50 ...
##  $ average      : num  -0.0166 -0.0645 0.1487 -0.8735 -0.9511 ...
##  - attr(*, "sorted")= chr  "subject" "activityName" "fDomain" "fAcceleration" ...
##  - attr(*, ".internal.selfref")=<externalptr>
```

Key variables of the data table

```r
key(dtTidy)
```

```
## [1] "subject"       "activityName"  "fDomain"       "fAcceleration"
## [5] "fDevice"       "fJerk"         "fMagnitude"    "fVariable"    
## [9] "fAxis"
```

Summary fo variables

```r
summary(dtTidy)
```

```
##     subject                 activityName  fDomain     fAcceleration 
##  Min.   : 1.0   LAYING            :1980   Time:7200   NA     :4680  
##  1st Qu.: 8.0   SITTING           :1980   Freq:4680   Body   :5760  
##  Median :15.5   STANDING          :1980               Gravity:1440  
##  Mean   :15.5   WALKING           :1980                             
##  3rd Qu.:23.0   WALKING_DOWNSTAIRS:1980                             
##  Max.   :30.0   WALKING_UPSTAIRS  :1980                             
##           fDevice      fJerk          fMagnitude   fVariable   fAxis    
##  Accelerometer:7200   NA  :7200   NA       :8640   Mean:5940   NA:3240  
##  Gyroscope    :4680   Jerk:4680   Magnitude:3240   SD  :5940   X :2880  
##                                                                Y :2880  
##                                                                Z :2880  
##                                                                         
##                                                                         
##      count          average        
##  Min.   :36.00   Min.   :-0.99767  
##  1st Qu.:49.00   1st Qu.:-0.96205  
##  Median :54.50   Median :-0.46989  
##  Mean   :57.22   Mean   :-0.48436  
##  3rd Qu.:63.25   3rd Qu.:-0.07836  
##  Max.   :95.00   Max.   : 0.97451
```

All combinations of features

```r
dtTidy[, .N, by=c(names(dtTidy)[grep("^f", names(dtTidy))])]
```

```
##     fDomain fAcceleration       fDevice fJerk fMagnitude fVariable fAxis
##  1:    Time            NA     Gyroscope    NA         NA      Mean     X
##  2:    Time            NA     Gyroscope    NA         NA      Mean     Y
##  3:    Time            NA     Gyroscope    NA         NA      Mean     Z
##  4:    Time            NA     Gyroscope    NA         NA        SD     X
##  5:    Time            NA     Gyroscope    NA         NA        SD     Y
##  6:    Time            NA     Gyroscope    NA         NA        SD     Z
##  7:    Time            NA     Gyroscope    NA  Magnitude      Mean    NA
##  8:    Time            NA     Gyroscope    NA  Magnitude        SD    NA
##  9:    Time            NA     Gyroscope  Jerk         NA      Mean     X
## 10:    Time            NA     Gyroscope  Jerk         NA      Mean     Y
## 11:    Time            NA     Gyroscope  Jerk         NA      Mean     Z
## 12:    Time            NA     Gyroscope  Jerk         NA        SD     X
## 13:    Time            NA     Gyroscope  Jerk         NA        SD     Y
## 14:    Time            NA     Gyroscope  Jerk         NA        SD     Z
## 15:    Time            NA     Gyroscope  Jerk  Magnitude      Mean    NA
## 16:    Time            NA     Gyroscope  Jerk  Magnitude        SD    NA
## 17:    Time          Body Accelerometer    NA         NA      Mean     X
## 18:    Time          Body Accelerometer    NA         NA      Mean     Y
## 19:    Time          Body Accelerometer    NA         NA      Mean     Z
## 20:    Time          Body Accelerometer    NA         NA        SD     X
## 21:    Time          Body Accelerometer    NA         NA        SD     Y
## 22:    Time          Body Accelerometer    NA         NA        SD     Z
## 23:    Time          Body Accelerometer    NA  Magnitude      Mean    NA
## 24:    Time          Body Accelerometer    NA  Magnitude        SD    NA
## 25:    Time          Body Accelerometer  Jerk         NA      Mean     X
## 26:    Time          Body Accelerometer  Jerk         NA      Mean     Y
## 27:    Time          Body Accelerometer  Jerk         NA      Mean     Z
## 28:    Time          Body Accelerometer  Jerk         NA        SD     X
## 29:    Time          Body Accelerometer  Jerk         NA        SD     Y
## 30:    Time          Body Accelerometer  Jerk         NA        SD     Z
## 31:    Time          Body Accelerometer  Jerk  Magnitude      Mean    NA
## 32:    Time          Body Accelerometer  Jerk  Magnitude        SD    NA
## 33:    Time       Gravity Accelerometer    NA         NA      Mean     X
## 34:    Time       Gravity Accelerometer    NA         NA      Mean     Y
## 35:    Time       Gravity Accelerometer    NA         NA      Mean     Z
## 36:    Time       Gravity Accelerometer    NA         NA        SD     X
## 37:    Time       Gravity Accelerometer    NA         NA        SD     Y
## 38:    Time       Gravity Accelerometer    NA         NA        SD     Z
## 39:    Time       Gravity Accelerometer    NA  Magnitude      Mean    NA
## 40:    Time       Gravity Accelerometer    NA  Magnitude        SD    NA
## 41:    Freq            NA     Gyroscope    NA         NA      Mean     X
## 42:    Freq            NA     Gyroscope    NA         NA      Mean     Y
## 43:    Freq            NA     Gyroscope    NA         NA      Mean     Z
## 44:    Freq            NA     Gyroscope    NA         NA        SD     X
## 45:    Freq            NA     Gyroscope    NA         NA        SD     Y
## 46:    Freq            NA     Gyroscope    NA         NA        SD     Z
## 47:    Freq            NA     Gyroscope    NA  Magnitude      Mean    NA
## 48:    Freq            NA     Gyroscope    NA  Magnitude        SD    NA
## 49:    Freq            NA     Gyroscope  Jerk  Magnitude      Mean    NA
## 50:    Freq            NA     Gyroscope  Jerk  Magnitude        SD    NA
## 51:    Freq          Body Accelerometer    NA         NA      Mean     X
## 52:    Freq          Body Accelerometer    NA         NA      Mean     Y
## 53:    Freq          Body Accelerometer    NA         NA      Mean     Z
## 54:    Freq          Body Accelerometer    NA         NA        SD     X
## 55:    Freq          Body Accelerometer    NA         NA        SD     Y
## 56:    Freq          Body Accelerometer    NA         NA        SD     Z
## 57:    Freq          Body Accelerometer    NA  Magnitude      Mean    NA
## 58:    Freq          Body Accelerometer    NA  Magnitude        SD    NA
## 59:    Freq          Body Accelerometer  Jerk         NA      Mean     X
## 60:    Freq          Body Accelerometer  Jerk         NA      Mean     Y
## 61:    Freq          Body Accelerometer  Jerk         NA      Mean     Z
## 62:    Freq          Body Accelerometer  Jerk         NA        SD     X
## 63:    Freq          Body Accelerometer  Jerk         NA        SD     Y
## 64:    Freq          Body Accelerometer  Jerk         NA        SD     Z
## 65:    Freq          Body Accelerometer  Jerk  Magnitude      Mean    NA
## 66:    Freq          Body Accelerometer  Jerk  Magnitude        SD    NA
##     fDomain fAcceleration       fDevice fJerk fMagnitude fVariable fAxis
##       N
##  1: 180
##  2: 180
##  3: 180
##  4: 180
##  5: 180
##  6: 180
##  7: 180
##  8: 180
##  9: 180
## 10: 180
## 11: 180
## 12: 180
## 13: 180
## 14: 180
## 15: 180
## 16: 180
## 17: 180
## 18: 180
## 19: 180
## 20: 180
## 21: 180
## 22: 180
## 23: 180
## 24: 180
## 25: 180
## 26: 180
## 27: 180
## 28: 180
## 29: 180
## 30: 180
## 31: 180
## 32: 180
## 33: 180
## 34: 180
## 35: 180
## 36: 180
## 37: 180
## 38: 180
## 39: 180
## 40: 180
## 41: 180
## 42: 180
## 43: 180
## 44: 180
## 45: 180
## 46: 180
## 47: 180
## 48: 180
## 49: 180
## 50: 180
## 51: 180
## 52: 180
## 53: 180
## 54: 180
## 55: 180
## 56: 180
## 57: 180
## 58: 180
## 59: 180
## 60: 180
## 61: 180
## 62: 180
## 63: 180
## 64: 180
## 65: 180
## 66: 180
##       N
```


