---
sidebar_position: 2
sidebar_label: "Partie 3: Visualisation des données"
hide_title: true
---

# Partie 3 : Visualisation des données avec R

- Utilisation des bibliothèques `ggplot2` et `plotly` pour créer des graphiques
- Personnalisation des graphiques : axes, légendes, couleurs, etc.
- Création de graphiques interactifs avec `plotly`

## GGPLOT2
### Scatterplot (nuage de points)

```R
library(tidyverse)
library(ggpubr) 

theme_set(
  theme_bw() + 
    theme(legend.position = "top")
)

p <- ggplot(mtcars, aes(mpg, wt)) +
  geom_point() +
  geom_smooth(method = lm) +
  stat_cor(method = "pearson", label.x = 20)
p
```


### Scatterplot (nuage de points) avec zoom contextuel

```R
library(ggforce)

ggplot(iris, aes(Petal.Length, Petal.Width, colour = Species)) +
  geom_point() +
  facet_zoom(x = Species == "versicolor")

```


### Scatterplot (nuage de points)
#### Avec encerclement de points

```R
library("ggalt")

circle.df <- iris %>% filter(Species == "setosa")

ggplot(iris, aes(Petal.Length, Petal.Width)) +
  geom_point(aes(colour = Species)) + 
  geom_encircle(data = circle.df, linetype = 2)

```


#### Avec bulles

```R
ggplot(mtcars, aes(mpg, wt)) +
  geom_point(aes(size = qsec), alpha = 0.5) +
  scale_size(range = c(0.5, 12))  # Adjust the range of points size

```


#### Avec densité

```R
ggscatterhist(
  iris, x = "Sepal.Length", y = "Sepal.Width",
  color = "Species", size = 3, alpha = 0.6,
  palette = c("#00AFBB", "#E7B800", "#FC4E07"),
  margin.params = list(fill = "Species", color = "black", size = 0.2)
)
```


### Densité de distributions

```R
ggplot(iris, aes(Sepal.Length, color = Species)) +
  geom_density() +
  scale_color_viridis_d()
```

#### Avec moyennes sur chaque groupe

```R
mu <- iris %>%
  group_by(Species) %>%
  summarise(grp.mean = mean(Sepal.Length))

ggplot(iris, aes(Sepal.Length, color = Species)) +
  geom_density() +
  geom_vline(aes(xintercept = grp.mean, color = Species),
             data = mu, linetype = 2) +
  scale_color_viridis_d()

```


### Histogrammes

```R
# Basic histogram with mean line
ggplot(iris, aes(Sepal.Length)) +
  geom_histogram(bins = 20, fill = "white", color = "black")  +
  geom_vline(aes(xintercept = mean(Sepal.Length)), linetype = 2)

# Add density curves
ggplot(iris, aes(Sepal.Length, stat(density))) +
  geom_histogram(bins = 20, fill = "white", color = "black")  +
  geom_density() +
  geom_vline(aes(xintercept = mean(Sepal.Length)), linetype = 2)
```


#### Couleur par groupe
```R
ggplot(iris, aes(Sepal.Length)) +
  geom_histogram(aes(fill = Species, color = Species), bins = 20, 
                 position = "identity", alpha = 0.5) +
  scale_fill_viridis_d() +
  scale_color_viridis_d()
```


### Barplot
```R
df <- mtcars %>%
  rownames_to_column() %>%
  as.data.frame() %>%
  mutate(cyl = as.factor(cyl)) %>%
  select(rowname, wt, mpg, cyl)
df

ggplot(df, aes(x = rowname, y = mpg)) +
  geom_col() +
  rotate_x_text(angle = 45)

```

#### Barplot avec ajout de couleurs

```R
ggplot(df, aes(x = rowname, y = mpg)) +
  geom_col() +
  geom_col( aes(fill = cyl)) +
  rotate_x_text(angle = 45)
```


### Séries longues

```R
df <- economics %>%
  select(date, psavert, uempmed) %>%
  gather(key = "variable", value = "value", -date)
head(df, 3)

ggplot(df, aes(x = date, y = value)) + 
  geom_line(aes(color = variable), size = 1) +
  scale_color_manual(values = c("#00AFBB", "#E7B800")) +
  theme_minimal()

```

## PLOTLY

### 2D Scatterplot
```R
library(plotly)

data(mtcars)

cars <- mtcars

p <- plot_ly(cars, x=cars$wt, y=cars$mpg, 
             mode="markers", color=cars$hp, size=cars$qsec) %>%
  layout(xaxis = list(title = "Weight (1000 lbs)"),
         yaxis = list(title = "miles per gallon") )

p
```

### 3D Scatterplot
```R
p <- plot_ly(cars, x=cars$wt, y=cars$mpg, z=cars$hp, 
             type="scatter3d", mode="markers", 
             color=cars$drat, size=cars$qsec) %>%
  layout(scene=list(
    xaxis = list(title = "Weight (1000 lbs)"),
    yaxis = list(title = "miles per gallon"),
    zaxis = list(title = "Gross horsepower)"))
  )

p

```

### séries longues

```R
graph <- economics %>% 
  plot_ly(x=~date) %>% 
  add_trace(y=~unemploy/400, type="scatter", mode="lines")

graph
```

### Boites à moustaches

```R
boxplot <- mtcars %>% 
  plot_ly(x=~factor(cyl), y=~mpg) %>% 
  add_trace(type="scatter", name="scatter") %>% 
  add_boxplot(name="Boxplot") %>% 
  layout(
    title="Fuel Efficiency"
  )

boxplot
```