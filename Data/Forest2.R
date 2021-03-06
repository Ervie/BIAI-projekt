#install.packages("randomForest")

#U�yj biblioteki
library(randomForest)

# Czytanie parametr�w
args=(commandArgs())

treeNumber <-  as.numeric(args[1])

# Miejscowy random
set.seed(4)

# Stw�rz las drzew decyzyjnych
forest2 <- randomForest(as.factor(good) ~ Continent + resolution + size + latitude + longitude + width + height + proportions + nameLength + captionLength + descriptionLength, data = train, mtry = 11, importance=TRUE, ntree= 100)

# Wypisanie wa�no�ci poszczeg�lnych parametr�w podczas podejmowania decyzji
#importance(forest2)
#varImpPlot(forest2)

# Dokonaj analizy danych na podstawie lasu
random_forest_result2 <- predict(forest2, test, OOB = TRUE, type = "response")

# Stw�rz plik wynikowy
submit2 <- data.frame(Id = test$id, good = random_forest_result2)
write.csv(submit2, file = "CSV/random_forest2.csv", row.names = FALSE)

prop.table(table(submit2$good))

