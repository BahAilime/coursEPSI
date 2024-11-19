---
sidebar_position: 4
sidebar_label: "Partie 5: Programmation avancée"
hide_title: true
---

# Partie 5 : Programmation avancée avec R

## Structures de contrôle
### Boucles

Afficher les nombres de 1 à 10

```R
for (i in 1:10) {
  print(i)
}
```

Boucle for pour calculer la somme des carrés des nombres de 1 à 5.

```R
somme_carres <- 0
for (i in 1:5) {
  somme_carres <- somme_carres + i^2
}
print(somme_carres)
```

Une boucle for pour trouver la moyenne d'une liste de nombres.

```R
nombres <- c(5, 10, 15, 20, 25)
somme <- 0
for (nombre in nombres) {
  somme <- somme + nombre
}
moyenne <- somme / length(nombres)
print(moyenne)
```

Une boucle for pour créer un vecteur de carrés des nombres de 1 à 10.

```R
carres <- c()
for (i in 1:10) {
  carres <- c(carres, i^2)
}
print(carres)
```

Une boucle while pour afficher les carrés des nombres de 1 à 5.

```R
i <- 1
while (i <= 5) {
  print(i^2)
  i <- i + 1
}
```
### Conditions

Une structure if pour déterminer si un nombre est pair ou impair.

```R
nombre <- 10

if (nombre %% 2 == 0) {
  print("Le nombre est pair.")
} else {
  print("Le nombre est impair.")
}
```

Une structure if-else pour déterminer la catégorie d'âge en fonction de l'âge fourni.

```R
age <- 25

if (age < 18) {
  cat("Mineur")
} else if (age >= 18 && age < 65) {
  cat("Adulte")
} else {
  cat("Senior")
}

```

### Fonctions

Une fonction pour calculer la somme de deux nombres.

```R
addition <- function(a, b) {
  return(a + b)
}

resultat <- addition(3, 5)
print(resultat)
```

Une fonction pour calculer la moyenne d'une liste de nombres.

```R
moyenne <- function(nombres) {
  return(mean(nombres))
}

liste_nombres <- c(10, 20, 30, 40, 50)
resultat <- moyenne(liste_nombres)
print(resultat)
```

Une fonction pour déterminer si un nombre est pair ou impair.

```R
parite <- function(nombre) {
  if (nombre %% 2 == 0) {
    return("Pair")
  } else {
    return("Impair")
  }
}

resultat <- parite(7)
print(resultat)
```

Une fonction pour calculer la factorielle d'un nombre.

```R
factorielle <- function(n) {
  if (n == 0) {
    return(1)
  } else {
    return(n * factorielle(n - 1))
  }
}

resultat <- factorielle(5)
print(resultat)
```


Une fonction pour inverser une chaîne de caractères.

```
inverser_chaine <- function(chaine) {
  return(paste0(rev(strsplit(chaine, "")[[1]]), collapse = ""))
}

resultat <- inverser_chaine("hello")
print(resultat)
```






#### exercice : creez deux fonctions. L'une aura pour but de normaliser et l'autre de standardiser les données

Min-max normalization

```R
normalize <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}

df_normalized <- as.data.frame(lapply(df, normalize))
```

Standardization

```
standardize <- function(x) {
  return((x - mean(x)) / sd(x))
}

df_standardized <- as.data.frame(lapply(df, standardize))
```

## Programmation fonctionnelle avec purrr

map() pour appliquer une fonction à chaque élément d'un vecteur.

```R
library(purrr)
```

Créer un vecteur

```R
vecteur <- c(1, 2, 3, 4, 5)
```
Ajouter 1 à chaque élément du vecteur

```R
resultat <- map(vecteur, ~ .x + 1)
print(resultat)
```

map_dbl() pour appliquer une fonction à chaque élément d'un vecteur et obtenir un vecteur numérique en sortie.

Créer un vecteur

```R
vecteur <- c(1, 2, 3, 4, 5)
```

Calculer le carré de chaque élément du vecteur

```R
resultat <- map_dbl(vecteur, ~ .x^2)
print(resultat)
```

map_df() pour appliquer une fonction à chaque élément d'une liste et obtenir un dataframe en sortie.

Créer une liste de vecteurs

```R
liste <- list(vecteur1 = c(1, 2, 3), vecteur2 = c(4, 5, 6))
```

Calculer la moyenne de chaque vecteur et créer un dataframe

```R
resultat <- map_df(liste, ~ tibble(moyenne = mean(.x)))
print(resultat)
```

reduce() pour réduire une liste en un seul résultat en appliquant une fonction d'accumulation.
Créer une liste de nombres

```R
liste <- list(1, 2, 3, 4, 5)
```

Calculer la somme des nombres dans la liste

```R
resultat <- reduce(liste, `+`)
print(resultat)
```

pmap() pour appliquer une fonction à plusieurs arguments sur chaque élément d'une liste.

Créer une liste de vecteurs

```R
liste <- list(c(1, 2, 3), c(4, 5, 6), c(7, 8, 9))
```

Ajouter les éléments correspondants des vecteurs

```R
resultat <- pmap(liste, ~ sum(c(...)))
print(resultat)
```

## Création de packages R

**Exercice :**
Créez un package R appelé monpackage contenant une fonction nommée carre() qui prend un nombre comme argument et renvoie son carré.

**Solution :**

1. Créez un nouveau répertoire nommé monpackage.

2. À l'intérieur de ce répertoire, créez un fichier R nommé `carre.R` dans le répertoire R/. 

  ```R
  carre <- function(x) {
    return(x^2)
  }
  ```

3. Dans le même répertoire, créez un fichier DESCRIPTION avec les métadonnées de votre package :

| Champ       | Exemple de valeur                                         |
| ----------- | --------------------------------------------------------- |
| Package     | `monpackage`                                              |
| Type        | `Package`                                                 |
| Title       | `Une démo de package R`                                   |
| Version     | `0.1.0`                                                   |
| Author      | `Votre nom`                                               |
| Maintainer  | `Votre nom <votre@email.com>`                             |
| Description | `Un package R simple pour calculer le carré d'un nombre.` |
| License     | `MIT + file LICENSE`                                      |
| Encoding    | `UTF-8`                                                   |
| LazyData    | `true`                                                    |

4. Créez un fichier NAMESPACE avec la directive d'exportation pour rendre la fonction carre() accessible :

```R	
export(carre)
```

5. Enfin, exécutez roxygen2::roxygenize() pour générer la documentation à partir des commentaires roxygen2.

6. Vous pouvez maintenant construire et installer votre package avec devtools :

```R
devtools::build()
devtools::install()
```

7. Une fois cela fait, vous pouvez utiliser votre package en l'important avec library(monpackage) et en appelant la fonction carre()

```R
library(monpackage)
carre(3)
```
