---
sidebar_position: 1
sidebar_label: "Partie 2: Gestion des données"
hide_title: true
---

# Partie 2 : Gestion des données avec R

## Importation et exportation des données

### donnees R
```R
data <- iris
```

| Name | Function | Example |
| --- | :---: | --- |
| CSV | `read.csv()` | `read.csv("C:/.../territory.csv", header = TRUE, sep = ";")` |
| XLSX | `xlsx::read.xlsx()` | `xlsx::read.xlsx("C:/.../reseller.xlsx", sheetIndex = 1, header = TRUE)` |
| Web CSV | `read.csv()` | `read.csv("https://s3.amazonaws.com/.../swimming_pools.csv")` |
| Git | `read.csv()` | `read.csv("https://raw.githubusercontent.com/.../c159s.csv")` |
| SAS | `haven::read_sas()` | `haven::read_sas("C:/.../event.sas7bdat")` |
| SPSS | `haven::read_sav()` | `haven::read_sav("C:/.../health_control.sav")` |

### data from xml

```R
require(xml2)
path_xml <- "C:/.../Books.xml"
data_xml <- xml2::read_xml(path_xml)

xml2::xml_structure(data_xml)

id = xml_find_all(data_xml, "//book")
author = xml_text(xml_find_all(id, "//author"))
title = xml_text(xml_find_all(id, "//title"))
category = xml_text(xml_find_all(id, "//genre"))
price = xml_text(xml_find_all(id, "//price"))

df <- data.frame(NAME = author, 
                 TITLE = title,
                 GENRE = category,
                 PRICE = price) 

View(df)
```

## Manipulation des données avec dplyr
### Chargement des trois tables du jeu de données
```R
data(flights)
data(airports)
data(airlines)

View(airports)
```

### Slice
```R
slice(airports, 345) # slice(airports, 345)
slice(airports, 1:5) # les 5 premières lignes
```

### Filter
```R
filter(flights, month == 1)
filter(flights, dep_delay >= 10 & dep_delay <= 15)
filter(flights, distance == max(distance))
```

### select, renamen relocate
```R
select(airports, lat, lon)
select(airports, -lat, -lon)
select(flights, starts_with("dep_"))

select(flights, all_of(c("year", "month", "day")))# all_of retourne une liste de colonnes définies
select(flights, all_of(c("century", "year", "month", "day"))) # all_of renverra une erreur si une variable n’est pas trouvée
select(flights, any_of(c("century", "year", "month", "day"))) # any_of ne renvoie pas d'erreur si une variable n’est pas trouvée
select(flights, where(is.character)) # where permet de selectionner des variables textuelles (logique)
select(airports, name, everything())
relocate(airports, lon, lat, name)
dplyr::rename(airports, longitude = lon, latitude = lat)
dplyr::arrange(flights, dep_delay) # arrange tri les lignes d'un tableau (croissant)
dplyr::arrange(flights, month, dep_delay) # tri selon le mois et le retard au départ
dplyr::arrange(flights, desc(dep_delay)) # tri décroissant

tmp <- dplyr::arrange(flights, desc(dep_delay)) %>%
  slice(1:3)

```

### mutate
```R
airports <- mutate(airports, alt_m = alt / 3.2808)
select(airports, name, alt, alt_m)


flights <- mutate(flights, 
                  distance_km = distance / 0.62137,
                  vitesse = distance_km / air_time * 60)
select(flights, distance, distance_km, vitesse)


flights <- mutate(flights,
                  type_retard = case_when(
                    dep_delay > 0 & arr_delay > 0 ~ "Retard départ et arrivée",
                    dep_delay > 0 & arr_delay <= 0 ~ "Retard départ",
                    dep_delay <= 0 & arr_delay > 0 ~ "Retard arrivée",
                    TRUE ~ "Aucun retard"))
```


### recode
```R
flights$month_name <- recode_factor(flights$month,
                                    "1" = "Jan",
                                    "2" = "Feb",
                                    "3" = "Mar",
                                    "4" = "Apr",
                                    "5" = "May",
                                    "6" = "Jun",
                                    "7" = "Jul",
                                    "8" = "Aug",
                                    "9" = "Sep",
                                    "10" = "Oct",
                                    "11" = "Nov",
                                    "12" = "Dec"
)
```


# operations groupées
```R
flights %>% group_by(month)


flights %>% group_by(month) %>% slice(1)


flights %>% 
  group_by(month) %>% 
  mutate(mean_delay_month = mean(dep_delay, na.rm = TRUE)) %>% 
  select(dep_delay, month, mean_delay_month)



flights %>% 
  group_by(month) %>% 
  dplyr::arrange(desc(dep_delay))

```


# summirize

```R
flights %>% 
  dplyr::summarise(
    retard_dep = mean(dep_delay, na.rm=TRUE),
    retard_arr = mean(arr_delay, na.rm=TRUE)
  )



flights %>%
  group_by(month) %>%
  dplyr::summarise(
    max_delay = max(dep_delay, na.rm=TRUE),
    min_delay = min(dep_delay, na.rm=TRUE),
    mean_delay = mean(dep_delay, na.rm=TRUE)
  )


flights %>%
  group_by(dest) %>%
  dplyr::summarise(nb = n())



flights %>%
  group_by(month, dest) %>%
  dplyr::summarise(nb = n()) %>%
  dplyr::arrange(desc(nb))

```

## Introduction aux techniques de nettoyage des données
### Identification des données manquantes

```R
# tester s'il y a une valeur manquante
y <- c(1,2,3,NA)
is.na(y) # returns a vector (F F F T)

# localiser la valeur manquante
which(is.na(y))

# compter les valeurs manquantes
sum(is.na(y))

# compter les valeurs manquantes sur plusieurs colonnes
colSums(is.na(iris))

```

## Exercice :

```R
# 1. Combien il y a de valeurs manquantes dans le jeu de données fligths ?
sum(is.na(flights))
# 2. Sur quelles colonnes trouvent t-on des valeurs manquantes ?
colSums(is.na(flights))
# 3. Imputez les valeurs manquantes par la moyenne ou mode, colonne par colonne
glimpse(flights)

flights_imputed <- flights %>%
  mutate(dep_time = mean(na.omit(dep_time)),
         dep_delay = mean(na.omit(dep_delay)),
         arr_time = mean(na.omit(arr_time)),
         arr_delay = mean(na.omit(arr_delay)),
         tailnum = mode(na.omit(tailnum)),
         air_time = mean(na.omit(air_time)))

sum(is.na(flights_imputed))
```


## Gestion des valeurs aberrantes et exrêmes

```R
ggplot(mpg, aes( x=class,y=hwy, fill=class)) +
  geom_boxplot()+ 
  xlab(label = "Type of car") +
  ylab(label = "Highway miles per gallon") +
  theme(axis.text.x = element_text(angle=30, hjust=1, vjust=1))+
  theme(legend.position="none")+
  ggtitle("Exemple de boxplots sur les données mpg") 

# les outliers sont représentés sous forme de points.

## récupération des outliers
# sélection des données suv
suv <- mpg %>%
  filter(class=="suv") # liste des outliers des SUV

outlier_val <- boxplot.stats(suv$hwy)$out
outlier_val

## récupérer l'indice des outliers
outlier_idx <- which(suv$hwy %in% c(outlier_val))
outlier_idx

suv[outlier_idx,] # verifions les lignes concernées


# remplacemement des valeurs extremes par la moyenne du groupe
suv[outlier_idx, "hwy"] <- as.integer(mean(suv$hwy))
print(suv[outlier_idx, "hwy"])

```



 
### Détection et gestion des doublons

```R
# trouver les doublons
x <- c(1, 1, 4, 5, 4, 6)
duplicated(x)
 
# extraire les doublons
x[duplicated(x)] 

# retirer les doublons
x[!duplicated(x)]

# retirer les doublons d'un datagrame
df <- iris %>%
  distinct() # ou unique()

# retirer les doublons à partir de deux colonnes : Sepal.Length and Petal.Width
df %>% distinct(Sepal.Length, Petal.Width, .keep_all = TRUE)
```


### Conversion des types de données

```R
# Conversion de character à numeric
char_vector <- c("1", "2", "3")
numeric_vector <- as.numeric(char_vector)

# Conversion de numeric à character
numeric_vector <- c(1, 2, 3)
char_vector <- as.character(numeric_vector)

# Conversion de factor à character
factor_vector <- factor(c("A", "B", "C"))
char_vector <- as.character(factor_vector)

# Conversion de factor à numeric
numeric_vector <- as.numeric(factor_vector)

# Conversion de character à date
char_date <- "2022-01-01"
date <- as.Date(char_date)

# Conversion de factor à date
factor_date <- factor("2022-01-01")
date <- as.Date(as.character(factor_date))

# Conversion de date à character
date <- as.Date("2022-01-01")
char_date <- as.character(date)

# Conversuion de logical à numeric
logical_vector <- c(TRUE, FALSE)
numeric_vector <- as.numeric(logical_vector)

# Conversion de logical à character
char_vector <- as.character(logical_vector)
```


### Correction des erreurs de saisies
```R
# détecter les motifs
data_from_git <- data_from_git %>%
  mutate(Experiment = if_else(str_detect(Experiment, "EXP")==TRUE, "Experiment", ""))

# remplacer des motifs
data_from_git <- data_from_git %>%
  mutate(Virus = str_replace(Virus, "C", "Corona"))
```


### Introduction aux techniques de nettoyage des données : normalisation et standardisation

```R
# normalisation
df = c(1200,34567,3456,12,3456,0985,1211) %>%
  as.data.frame()

summary(data)
library(caret)
process <- preProcess(df, method=c("range"))

norm_scale <- predict(process, as.data.frame(df))
norm_scale

# standardisation
scale_df <- as.data.frame(scale(df))
scale_df
```


### Validation des formats de date et heure

```R
today()
now()
ymd("2017-01-31")
ymd_hms("2017-01-31 20:11:59")
mdy_hm("01/31/2017 08:01")


# créer une date ou une date-heure à partir de colonnes séparées,
flights |> 
  select(year, month, day, hour, minute) |> 
  mutate(
    departure = make_datetime(year, month, day, hour, minute),
    departure_date = make_date(year, month, day)  ) |> 
  head()

# durées
diff <- ymd("2021-06-30") - ymd("1979-10-14")
diff
```