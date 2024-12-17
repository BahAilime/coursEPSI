---
sidebar_position: 0
sidebar_label: "Partie 1: Introduction"
hide_title: true
---

# Partie 1 : Introduction à R


[Dossier R de Joyce](/R/DéveloppementR-Joyce.zip)

## Chargement des bibliothèques nécessaires

:::tip[Bibliotèques utilisées dans ce cours (toutes les parties)]

devtools dplyr readr xlsx stringr haven nycflights13 knitr forstringr lubridate tidyverse

:::

```r
if(!require(XXX)){
  install.packages("XXX")
  library(XXX)
```

## Vecteurs



```R
x = c(1, 2, 3, 4, 5) # creation d'un vecteur
w = c("France", "Italie", "Senegal")

typeof(letters) # donne le type de vecteur
typeof(1:10)

x <- list("a", "b", 1:10)
length(x) # donne la longueur d'un vecteur ou d'une liste
```


### Vecteurs logiques

```R
1:10 %% 3 == 0 # modulo, renvoie le reste de la division
```

### Subsetting

```R
x <- c("one", "two", "three", "four", "five") # sous sélection en fonction de la position
x[c(3, 2, 5)]

x[c(1, 1, 5, 5, 5, 2)] # sous sélection par la répétition

x[c(-1, -3, -5)] # les valeurs negatives retirent les élements en fonction de leurs positions
```

### Toutes les valeurs non manquantes

```
x <- c(10, 3, NA, 5, 8, 1, NA)
x[!is.na(x)]
```

### Si tu as nommé un vecteur, tu peux extraire son element en l'appellant

```R
x <- c(abc = 1, def = 2, xyz = 5)
x[c("xyz", "def")]
```


## Matrice

```R
matrix(1:6) # matrice de type vecteur colonne

matrix(1:6, ncol = 2) # creation d'une matrice avec 2 colonnes

matrix(1:6, nrow = 2) # creation d'une matrice avec 2 lignes

```

:::warning[Attention]

    Par défaut, le remplissage d’une matrice se fait par colonne

    :::tip[Remplissage par colonne ou par ligne]

        Si vous voulez un remplissage par ligne, il faut utiliser l’argument `byrow` avec la valeur `TRUE`.

    ```R
    matrix(1:6, nrow = 1, byrow = TRUE)
    matrix(1:6, nrow = 2, byrow = TRUE)

    ```
:::



### Dimension d'une matrice

```R
xm <- matrix(1:6, nrow = 5, ncol = 10)
dim(xm)
```


### Fonctions colnames() et rownames()
Avec les fonctions colnames() et rownames() on peut récupérer ou définir les noms des colonnes et des lignes .

```R
colnames(xm) <- paste("X", 1:10, sep = "")
rownames(xm) <- paste("Y", 1:5, sep = "")
xm
```

### Accéder aux éléments (lignes, colonnes) d’une matrice

```R
xm[1, ]  # ligne 1 (l'output est un vecteur)
xm[c(1, 3), ]  # ligne 1 et 3
xm[c("i1", "i3"), ]  # ligne "i1" et "i3"
xm[, 1:2]  # colonnes 1 et 2
xm[, c(TRUE, TRUE, rep(FALSE, 8))]  # idem
xm[, c("X1", "X2")]  # colonnes "X1" et "X2"
xm[, -c(1, 3)] # toutes les colonnes sauf 1 et 3
rbind(xm, 1:10) # ajoute une ligne à la matrice

```

### Operations sur les matrices

```R
X <- matrix(c(9, 2, -3, 2, 4, -2, -3, -2, 16), 3, byrow = TRUE)
Y <- matrix(0:8, ncol = 3)
```

| Opération | Opérateur ou fonction | Exemple |
| --- | :---: | :---: |
| Addition | `+` | `X + Y` |
| Soustraction | `-` | `X - Y` |
| Multiplication | `*` | `X * Y` |
| Division | `/` | `X / Y` |
| Déterminant | `det` | `det(X)` |
| Inverse | `solve` | `solve(X)` |
| Moyenne par colonne | `colMeans` | `colMeans(X)` |


## Data frames

Pour créer un data frame, créons des vecteurs qui vont le constituer

```R
taille <- c(167, 192, 173, 174, 172, 167, 171, 185, 163, 170) # mesures en cm
poids <- c(86, 74, 83, 50, 78, 66, 66, 51, 50, 55) # mesures en Kg
prog <- c("Bac+2", "Bac", "Master", "Bac", "Bac", "DEA", "Doctorat", NA, "Certificat", "DES") # programme d'étude
sexe <- c("H", "H", "F", "H", "H", "H", "F", "H", "H", "H")

mydata <- data.frame(height = taille, weight = poids, prog, sexe, 11:20)
mydata
```

### Struture du dataframe

```R
length(mydata)
dim(mydata)
glimpse(mydata)
```

### Parcourir son dataframe numero ou position

```R
mydata[c(2, 3)]                    # colonnes 2 et 3
mydata[, c(2, 3)]                  # idem
mydata |> subset(select = c(2, 3)) # idem
```

### Parcourir son dataframe par nom

```R
mydata$weight                       # colonne "weight" (resultat = vecteur)
mydata["weight"]                    # colonne "weight" (resultat = data.frame)
mydata |> subset(select = "weight") # idem
mydata |> subset(select = weight)   # idem
```

### Parcourir son dataframe par condition logique

```R
mydata[mydata$sexe == "H", ]           # sélectionner uniquement les hommes
mydata |> subset(subset = sexe == "H") # idem
mydata |> subset(sexe == "H")          # idem
```