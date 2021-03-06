#library(rpart)
#library(rattle)
#library(rpart.plot)
#library(RColorBrewer)

# Info o tabeli
str(train)

# Ilo�� dobrych i z�ych zdj��
table(train$good)

# Proporcje dobrych i z�ych zdj��
prop.table(table(train$good))

# Dodanie nowej kolumny i wype�nienie zerami
test$good <- rep(0, 12000)

# W�asna kolumna - kontynent
train$Continent <- 'Ocean'
train$Continent[train$longitude > -80 & train$longitude < -35 & train$latitude > -55 & train$latitude < 12] <- 'South America'
train$Continent[train$longitude > -115 & train$longitude < -60 & train$latitude > 12 & train$latitude < 30] <- 'Middle America'
train$Continent[train$longitude > -125 & train$longitude < -53 & train$latitude > 30 & train$latitude < 80] <- 'North America'
train$Continent[train$longitude > -168 & train$longitude < -125 & train$latitude > 50 & train$latitude < 72] <- 'North America'
train$Continent[train$longitude >  113 & train$longitude < 168 & train$latitude > -48 & train$latitude < -12] <- 'Australia'
train$Continent[train$longitude > -10 & train$longitude < 40 & train$latitude > 36 & train$latitude < 72] <- 'Europe'
train$Continent[train$longitude > -18 & train$longitude < 35 & train$latitude > 5 & train$latitude < 36] <- 'Africa'
train$Continent[train$longitude > 50 & train$longitude < 10 & train$latitude > -35 & train$latitude < 5] <- 'Africa'
train$Continent[train$longitude > 35 & train$longitude < -50 & train$latitude > 13 & train$latitude < 0] <- 'Africa'
train$Continent[train$longitude > 40 & train$longitude < 145 & train$latitude > 30 & train$latitude < 85] <- 'Asia'
train$Continent[train$longitude > 35 & train$longitude < 125 & train$latitude > 10 & train$latitude < 40] <- 'Asia'
train$Continent[train$longitude > 30 & train$longitude < 85 & train$latitude > -10 & train$latitude < 20] <- 'Asia'
train$Continent[train$longitude > 140 & train$longitude < 180 & train$latitude > 50 & train$latitude < 75] <- 'Asia'

test$Continent <- 'Ocean'
test$Continent[test$longitude > -80 & test$longitude < -35 & test$latitude > -55 & test$latitude < 12] <- 'South America'
test$Continent[test$longitude > -115 & test$longitude < -60 & test$latitude > 12 & test$latitude < 30] <- 'Middle America'
test$Continent[test$longitude > -125 & test$longitude < -53 & test$latitude > 30 & test$latitude < 80] <- 'North America'
test$Continent[test$longitude > -168 & test$longitude < -125 & test$latitude > 50 & test$latitude < 72] <- 'North America'
test$Continent[test$longitude >  113 & test$longitude < 168 & test$latitude > -48 & test$latitude < -12] <- 'Australia'
test$Continent[test$longitude > -10 & test$longitude < 40 & test$latitude > 36 & test$latitude < 72] <- 'Europe'
test$Continent[test$longitude > -18 & test$longitude < 35 & test$latitude > 5 & test$latitude < 36] <- 'Africa'
test$Continent[test$longitude > 50 & test$longitude < 10 & test$latitude > -35 & test$latitude < 5] <- 'Africa'
test$Continent[test$longitude > 35 & test$longitude < -50 & test$latitude > 13 & test$latitude < 0] <- 'Africa'
test$Continent[test$longitude > 40 & test$longitude < 145 & test$latitude > 30 & test$latitude < 85] <- 'Asia'
test$Continent[test$longitude > 35 & test$longitude < 125 & test$latitude > 10 & test$latitude < 40] <- 'Asia'
test$Continent[test$longitude > 30 & test$longitude < 85 & test$latitude > -10 & test$latitude < 20] <- 'Asia'
test$Continent[test$longitude > 140 & test$longitude < 180 & test$latitude > 50 & test$latitude < 75] <- 'Asia'

train$Continent <- factor(train$Continent)
test$Continent <- factor(test$Continent)

# Pozbycie si� niewygodnych zer
train$width[train$width == 0] <- as.integer(1)
train$height[train$height == 0] <- as.integer(1)

# W�asna kolumna - proporcjie
train$proportions[(train$width / train$height) < 1.33] <- '< 4:3'
train$proportions[(train$width / train$height) >= 1.33] <- '4:3'
train$proportions[(train$width / train$height) >= 1.45] <- '3:2'
train$proportions[(train$width / train$height) >= 1.55] <- '> 3:2'

test$proportions[(test$width / test$height) < 1.33] <- '< 4:3'
test$proportions[(test$width / test$height) >= 1.33] <- '4:3'
test$proportions[(test$width / test$height) >= 1.45] <- '3:2'
test$proportions[(test$width / test$height) >= 1.55] <- '> 3:2'

train$proportions <- factor(train$proportions)
test$proportions <- factor(test$proportions)

prop.table(table(test$proportions))

# W�asna kolumna - rozdzielczo�� (w�a�ciwie: przek�tna)
train$resolution <- 0
train$resolution <- as.integer(sqrt(train$height^2 + train$width^2))
test$resolution <- as.integer(sqrt(test$height^2 + test$width^2))

train$nameLength <- sapply(gregexpr("\\W+", train$name), function(x) sum(x>0) ) + 1 
train$nameLength[nchar(train$name) < 1] <- 0

test$nameLength <- sapply(gregexpr("\\W+", test$name), function(x) sum(x>0) ) + 1 
test$nameLength[nchar(test$name) < 1] <- 0

train$captionLength <- sapply(gregexpr("\\W+", train$caption), function(x) sum(x>0) ) + 1 
train$captionLength[nchar(train$caption) < 1] <- 0

test$captionLength <- sapply(gregexpr("\\W+", test$caption), function(x) sum(x>0) ) + 1 
test$captionLength[nchar(test$caption) < 1] <- 0

train$descriptionLength <- sapply(gregexpr("\\W+", train$description), function(x) sum(x>0) ) + 1 
train$descriptionLength[nchar(train$description) < 1] <- 0

test$descriptionLength <- sapply(gregexpr("\\W+", test$description), function(x) sum(x>0) ) + 1 
test$descriptionLength[nchar(test$description) < 1] <- 0

prop.table(table(train$descriptionLength, train$good), 1)

# UserInput - wykorzystywany przy w�asnych danych.
userInput = data.frame(matrix(NA, nrow = 1, ncol = 16))
dim(userInput)
names(userInput) <- colnames(train)

# Poni�ej tylko zabawa drzewami decyzyjnymi

#aggregate(good ~ resolution, data=train, FUN=function(x){sum(x)/length(x)})

#tree1 <- rpart(good ~ descriptionLength, data=train, method = "class", control=rpart.control(minsplit=300, cp=0,1))
#fancyRpartPlot(tree1)

#Prediction <- predict(tree1, test, type = "class")
#submit <- data.frame(Id = test$id, good = Prediction)
#write.csv(submit, file = "myfirstdtree.csv", row.names = FALSE)

#table(submit$good)
#prop.table(table(submit$good))

