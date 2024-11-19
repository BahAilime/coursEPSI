---
sidebar_position: 2
sidebar_label: Les différents algorithmes
hide_title: true
---

# Les différents algorithmes d'apprentissage automatique

![scikitlearn algorithm cheatsheet](https://scikit-learn.org/1.3/_static/ml_map.png)

## Définition de l’apprentissage automatique

> L'apprentissage automatique (ML) est un domaine de l'intelligence artificielle qui développe des algorithmes capables d'apprendre à partir des données pour exécuter des tâches sans instructions explicites.  
Des exemples incluent la reconnaissance faciale, la prédiction des prix, ou le tri des e-mails.

## Catégories principales
1. **Apprentissage supervisé** 
   Les algorithmes apprennent à partir de données avec des ***étiquettes*** (labels) connues (ex. : prix d'une maison ou catégorisation d'e-mails).
   
   - Régression : Prédire une variable continue (ex. : prix).  
   - Classification : Attribuer une catégorie (ex. : spam ou non-spam).

   Exemple : Prédire le prix d'une maison en fonction de la surface, l’emplacement, et l’année de construction.  

   ![Regression vs Classification](https://www.startpage.com/av/proxy-image?piurl=https%3A%2F%2Fwww.sharpsightlabs.com%2Fwp-content%2Fuploads%2F2021%2F04%2Fregression-vs-classification_simple-comparison-image_v3.png&sp=1731880855T766819b990a7458230a82adb421751634549b01c265b32a944afa4c882db42b4)

2. **Apprentissage non supervisé**
   Les algorithmes analysent des données sans connaître de vérité préalable.  

   - Clustering : Regrouper des données similaires (ex. : trier automatiquement des e-mails en groupes).  
   - Réduction de dimensions : Simplifier les données sans perdre trop d’information (ex. : compresser une image tout en reconnaissant ses objets).  

## Principaux algorithmes
1. Régression linéaire  
   Trouve une relation linéaire entre une entrée et une sortie pour minimiser l'erreur de prédiction.  

   Exemple : Relation entre taille et pointure : chaque pointure de plus = 2 cm de plus en taille (exemple simplifié).  

   ![linerar regression height shoe size](https://www.startpage.com/av/proxy-image?piurl=https%3A%2F%2Fprd-api-aggregate.statcrunch.com%2Fapi%2Faggregation%2Fdocuments%2F660733OZNZX%3Fcontext%3Dresults_image%26code%3D%26extension%3Dpng&sp=1731881078T795a70a2185ae30ad9a0241c495d7239414deb1196ad3dad2874efd1be67f824)

2. Régression logistique  
   Prédit des probabilités pour des classes (ex. : homme ou femme selon taille/poids).  
   Utilise une fonction sigmoïde pour modéliser les classes.  

3. K-Nearest Neighbors (KNN)  
   Prend la moyenne des K plus proches voisins pour prédire une valeur (classification ou régression).

   :::warning[Attention]

   Problème d’overfitting si K est trop petit ou underfitting si trop grand (tester plusieurs K pour savoir).

   :::

   ![KNN](https://www.startpage.com/av/proxy-image?piurl=https%3A%2F%2Farize.com%2Fwp-content%2Fuploads%2F2023%2F03%2Fknn-algorithm-visual.png&sp=1731881259Tcc72b8208fbc91ad3cc6a15e4da3783386bfb9bd78bf6f62c5bb75dca8d24ddf)

4. SVM (Support Vector Machines)  
   Trace une limite qui sépare des classes avec une marge maximale pour éviter les erreurs.  

   ![SVM](https://www.acte.in/wp-content/uploads/2022/01/Support-Vector-Machine-ACTE.png)

5. **Arbres de décision**
   Modèle des décisions successives sous forme d’arbre, basé sur des règles “oui/non”.  

6. **Forêts aléatoires (Random Forests)**
   Combine plusieurs arbres pour éviter le surapprentissage. Chaque arbre vote pour une prédiction finale.  

7. **Boosting (ex. : AdaBoost, Gradient Boosting)** 
   Corrige les erreurs de modèles précédents pour améliorer la précision.  

8. **Réseaux de neurones (Deep Learning)**
   - Utilisent des layers *cachées* pour détecter automatiquement des relations complexes.  
   - Exemple simplifié : Reconnaître un chiffre malgré des écritures différentes.  

   ![Neural Network](https://www.marktechpost.com/wp-content/uploads/2022/09/Screen-Shot-2022-09-23-at-10.46.58-PM.png)

## Apprentissage non supervisé : Clustering
- K-Means Clustering : Regroupe des données selon leur proximité avec des centres de clusters.  
- Autres techniques : Clustering hiérarchique, DBScan.  

![K Means Clustering](https://www.askpython.com/wp-content/uploads/2020/12/Plotting-K-Means-Clusters-scaled.jpeg)

## Réduction de dimensions
- Exemple : La réduction via PCA (Analyse en Composantes Principales) fusionne des variables corrélées pour simplifier les données.  

## Résumé des algorithmes
| Algorithme                | Type         | Exemple d’utilisation                  |
|---------------------------|--------------|----------------------------------------|
| Régression linéaire       | Régression   | Prédire le prix d’une maison.          |
| KNN                       | Les deux     | Catégoriser des individus.             |
| Forêts aléatoires         | Les deux     | Détection de fraude.                   |
| Réseaux de neurones       | Les deux     | Reconnaissance d’image.                |
| K-Means Clustering        | Non-supervisé| Groupement d’e-mails similaires.       |