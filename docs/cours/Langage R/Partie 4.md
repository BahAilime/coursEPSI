---
sidebar_position: 3
sidebar_label: "Partie 4: Analyse de données"
hide_title: true
---

# Partie 4 : Analyse de données avec R

## Introduction aux statistiques descriptives
### Statistiques univariées

### Statistiques univariées

| Name | Function | Example |
| --- | :---: | :---: |
| Moyenne | `mean(x)` | `mean(mtcars$hp)` |
| Médiane | `median(x)` | `median(mtcars$hp)` |
| Variance | `var(x)` | `var(mtcars$hp)` |
| Ecart-type | `sd(x)` | `sd(mtcars$hp)` |
| Résumé | `summary(x)` | `summary(mtcars$hp)` |
| Quantiles | `quantile(x)` | `quantile(mtcars$hp)` |

```R
# Résumé complet des statistiques descriptives
describe(mtcars$hp)
describe(mtcars)
```

### Calcul de l'asymétrie : SKEWNESS
    -  L'asymétrie mesure la symétrie de la distribution des données par rapport à 
    -  la moyenne. Une valeur positive indique une queue de distribution plus longue 
    - du côté droit de la moyenne, tandis qu'une valeur négative indique une queue plus 
    - longue du côté gauche.

```R
skew(mtcars$hp)

p <- ggplot(mtcars, aes(x=hp)) + 
  geom_density()
p
```

### Calcul du coefficient d'aplatissement
    - Le coefficient d'aplatissement mesure la forme de la distribution des données 
    - par rapport à la distribution normale. Une valeur positive indique une 
    - distribution plus pointue que la distribution normale, tandis qu'une valeur 
    - négative indique une distribution moins pointue 

```R
kurtosi(mtcars$hp)
  
p <- ggplot(mtcars, aes(x=hp)) + 
    geom_density()
p
```

## Utilisation des tests statistiques (pour comparer des groupes)
### Definition


Un test statistique permet de prendre une décision entre deux hypothèses.
Il est utilisé pour déterminer si une différence ou une relation observée entre les données est statistiquement significative, c'est-à-dire si elle est probablement due à une vraie différence ou relation dans la population étudiée, plutôt que simplement due au hasard.
      
    - **Étape 1 :** Définir l’hypothèse nulle (H0) et l’hypothèse alternative (H1).
      H0 représente généralement l'idée qu'il n'y a pas de différence ou de relation entre les groupes comparés, tandis que H1 suggère qu'il y en a une.
    
    - **Étape 2 :** L’erreur de première et deuxième espèce
      L'erreur suggère que il y a toujours un risque de se tromper. 
      L’erreur de première espèce alpha correspond au risque de rejeter l’hypothèse nulle H0 alors qu’elle est vraie : c’est un « faux positif ».
      L’erreur de seconde espèce beta correspond au risque d’accepter l’hypothèse nulle H0 alors qu’elle est fausse : c’est un « faux négatif ».
      Par défaut, on fixe le paramètre alpha à 5% : c’est-à-dire que la probabilité maximale de rejeter HO si elle est vraie est de 5%. 
    
    - **Étape 3 :** choisir le test approprié
    
    - **Étape 4 :** analyse des résultats
      La p-value est le niveau à partir duquel on se met à rejeter H0. C’est ce qui va nous permettre de répondre au test.
          - Si p-value < alpha, alors on rejette H0 au niveau alpha,  
          - Si p-value > alpha, alors on conserve H0 au niveau alpha. 

### Test t de Student

```
  # Le test de student (ou t-test) est utilisé pour comparer deux moyennes.
  # Comparons les poids de poulpes mâles et femelles à l'âge adulte.
  # Nous disposons des données de 15 poulpes mâles et 13 femelles.
  # Nous souhaitons tester l'égalité des moyennes des poids des poules femmelles (mu 1) et mâles (mu2),
  # avec une erreur de premiere espece de 5%.
```

   1. chargement des données

```R
poulpes <- read.csv("C:/Users/joyce.mbiguidi/Documents/EPSI_Nantes - Orlane CALLAUD/Cours/Développement R/poulpe.csv", 
                      header = TRUE, sep = ";", fileEncoding = "windows-1252")

```
  
   2. Formulation des hypotheses
    -# H0 : les moyennes des poids sont egales entre les sexes (mu1 = mu2)
    -# H1 : les moyennes des poids sont differentes (mu1 != mu2)
     
   3. comparaison graphique : distribution des poids

```R
ggplot(poulpes, aes(x = Sexe, y = Poids, fill = Sexe)) +
  geom_boxplot()+ 
  xlab(label = "Sexe") +
  ylab(label = "Poids") +
  theme(axis.text.x = element_text(angle=30, hjust=1, vjust=1))+
  theme(legend.position="none")+
  ggtitle("Distribution des poids") 

```
 
les mâles sont généralement plus lourd que les femelles (médianes et quartiles de poids)  

4. réalisation du test

```R
t.test(Poids ~ Sexe, 
       alternative = "two.sided", # bi-latérial car H1 : les moyennes des poids sont differentes. Si H1 était les moyennes des poids sont faibles, alors on aurait mis "unilateral" 
       conf.level = .95,
       data = poulpes)
```

conclusion : la p-value vaut 0.001 < 5%. Donc on rejete H0, les moyennes sont significativement différentes.
La moyenne des mâles dans l'échantillon estimée à 2700 grammes est donc significativement différente de celle des femelles estimée à 1405 grammes.

### ANOVA
    # L'ANOVA est l'analyse de la variance.
    # C'est une extension du test de student.
    # L'ANOVA permet de voir si une variable numérique (Poids) a des valeurs différentes en fonction de plusieurs groupes (Sexe)
    
    # 1. Formulation des hypotheses
      # H0 : le sexe n'influence pas le poids des poules (qui des males et des femelles sont les plus lourds ?)
      # H1 : le sexe a une influence sur le poids des poulpes 

```R
anova <- aov(Poids ~ factor(Sexe),
             data = poulpes)

summary(anova)
```

 Conclusion : le facteur sexe est significatif avec une valeur p < 5%. On rejette donc H0. Le sexe influence donc le poids des poulpes.


### Test de Wilcoxon-Mann-Whitney
- Le test de Wilcoxon (test du rang de signe de Wilcoxon) vérifie si les valeurs moyennes de deux groupes dépendants diffèrent significativement l'une de l'autre.
- Exemple en médecine : nous allons vérifier si les performances de la mémoire sont meilleures le matin ou le soir.
- Hypothèse nulle : il n'y a pas de différence entre le matin et le soir
- Hypothèse alternative : il existe une différence (par rapport à la tendance centrale) entre le matin et le soir

```R
temps_reaction_matin <- c(34, 36, 41, 39, 44, 37)
flag1 <- rep("matin", length(temps_reaction_matin))

temps_reaction_soir <- c(45, 33, 35, 43, 42, 42)
flag2 <- rep("soir", length(temps_reaction_soir))

df1 <- data.frame(reaction = temps_reaction_matin, moment = flag1)
df2 <- data.frame(reaction = temps_reaction_soir, moment = flag2)

df <- df1 %>%
  bind_rows(df2)

View(df)


ggplot(df, aes(x = reaction, y = moment, fill = moment)) +
  geom_boxplot() +
  geom_point() +
  xlab(label = "reaction") +
  ylab(label = "moment") +
  theme(axis.text.x = element_text(angle=30, hjust=1, vjust=1))+
  theme(legend.position="none")+
  ggtitle("Distribution des reactions") 

```

#### Test statistique

```R
wilcox.test(reaction ~ moment,
            alternative = "two.sided",
            conf.int = TRUE,
            data = df)
```

#### Taille de l'effet

```R
df %>%
  wilcox_effsize(reaction ~ moment)
```

Critère de taille de l'effet : l'effet varie entre -1 et 1

- si taille effet < 0.1, alors aucun effet sinon très faible
- si taille effet = 0.1, alors effet faible
- si taille effet = 0.3, alors effet moyen
- si taille effet = 0.5, alors effet important

Conclusion : on retient H0 car p-value > 5% et une taille d'effet "petite" est détectée.
Pas étonnant, les moyennes sont proches

```R
df %>% group_by(moment) %>% summarise(avg = mean(reaction),
                                      sd = sd(reaction))
```

### Test de Kruskal-Wallis
### UTest de signe (Wilcoxon)
### Test de Friedman
### Test de khi-deux (test d'indépendance)
Le test du khi-deux implique de vérifier si les fréquences observées dans une ou plusieurs catégories correspondent aux fréquences attendues.

Ici, on étudie la couleur des cheveux des garçons et des filles.
Nous voulons savoir si la couleur des cheveux est indépendante du sexe, avec une erreur de 5%
- HO : la couleur des cheveux est indépendante du sexe
- H1 : la couleur des cheveux dépend du sexe


```R
df <- data.frame("Blond" = c(592, 544),
                 "Roux" = c(119, 97),
                 "Châtain" = c(849, 677),
                 "Brun" = c(504, 451),
                 "Noir_de_jais" = c(36, 14),
                 row.names = c("Garçons", "Filles"))

chisq.test(df)
```

**Conclusion : On accepte H0. La couleur des cheveux est indépendante du sexe.**

### Régression linéaire avec interaction
Test de Levene ou Barlett

### Régression linéaire multiple

```R
# 1. chargement des données
ozone <- read.delim("C:/.../ozone.txt", 
                    header = TRUE, sep = " ", fileEncoding = "windows-1252")
# View(ozone)

# 2. nettoyage des données
ozone <- ozone %>%
  select(-c(vent, pluie, maxO3v))

# 3. modélisation
lin_reg1 <- lm(maxO3 ~ ., data = ozone)
summary(lin_reg1)

# 4. stepwise model
lin_reg2 <- step(lin_reg1, direction = "backward", )
summary(lin_reg2)
```