---
sidebar_position: 2
title: Engorgement des Urgences
hide_title: false
---

# Conférence : Engorgement des Urgences - Comment l'IA change la donne au Centre Hospitalier de Maubeuge
**Conférencier : Valentin Gillot**

## Introduction

Le Centre Hospitalier de Maubeuge fait face à une importante pression dans son Service d’Accueil des Urgences (SAU), avec entre **110 et 140 passages par jour**, dont **15 à 20% nécessitent une hospitalisation**. Pour répondre à cette demande croissante et améliorer la gestion des patients, le CH de Maubeuge a intégré des solutions basées sur l'intelligence artificielle (IA). L'objectif est de rendre les flux plus prévisibles et d'optimiser l'occupation des lits, tout en soutenant les équipes médicales.

## Les Applications de l’IA au SAU

### 1. **Optimisation de la Gestion des Lits : Prédiction sur 5 jours**

La première utilisation concrète de l’IA au CH de Maubeuge vise à **prédire l’occupation des lits sur 5 jours**. Grâce à ce modèle prédictif, le service est réorganisé en fonction du nombre attendu de patients hospitalisés. 

- Les prédictions sont **mises à jour toutes les 4 heures**.
- Le modèle IA détermine également si un patient sera orienté vers une **filière longue ou courte**, selon la gravité de son état.
- Un focus particulier est porté sur les patients âgés de **plus de 75 ans**, qui représentent un enjeu majeur en termes de gestion des ressources.

Le modèle s'appuie sur une base de données solide de **300 000 passages enregistrés sur 5 ans**. Parmi les **40 variables** prises en compte pour affiner la prédiction, on trouve :
- La météo (température),
- Le calendrier (y compris les périodes de vacances scolaires),
- Les épidémies (via Google Trends),
- Les statistiques issues de la médecine de ville.

Les **tests d'hypothèses** et l'analyse des **corrélations** permettent de sélectionner les variables les plus pertinentes pour le modèle, améliorant ainsi sa performance. Le modèle utilisé, **Prophet**, offre l’avantage d’être ajustable en termes de sensibilité, tout en mettant en évidence les facteurs influents. 

- **Résultats :** une **moyenne d'erreur de 3,8 patients** (en dessous de l’objectif fixé de 5).
- **Succès global : 82%**, un excellent résultat pour une première phase d’implémentation.

Les prochaines étapes incluent l’**automatisation** complète et l’intégration d’une **interface utilisateur** (IHM) pour restituer les résultats en temps réel via l'outil **Dash** en Python, avec un **indice de confiance** pour chaque prédiction.

### 2. **Prédiction du Destin des Patients : Hospitalisation ou Retour à Domicile**

Le deuxième volet de l’utilisation de l’IA vise à prédire le **destin du patient** dès son arrivée aux urgences. L’objectif est de savoir si le patient devra être hospitalisé ou pourra rentrer chez lui.

La prédiction s’effectue en trois étapes :
1. **Accueil :** prise en compte des données initiales (âge, motif de consultation, température, antécédents médicaux, etc.).
2. **Consultation médicale :** diagnostic du médecin, prescriptions biologiques et imagerie.
3. **Résultats d’analyse/scanner.**

Deux modèles sont utilisés pour cette prédiction :
- Un modèle de **classification** basé sur **LightGBM**,
- Un modèle de traitement du langage naturel pour analyser les textes des médecins, avec **BERT**.

- **Fiabilité des modèles :** 80% pour BERT, 78% pour les statistiques.
- Lors de l’étape 1, la prédiction atteint une précision de **83%**, qui grimpe à **85%** à l’étape 2, après le diagnostic médical.

## Retours d’Expérience et Enjeux

**Challenges rencontrés :**
- La **performance des modèles** reste un défi, malgré les bons résultats obtenus.
- L'**accès aux données** a été un processus long et complexe, nécessitant une année complète de négociations avec la CNIL.
- Les questions **éthiques** liées à l’utilisation de l’IA en médecine sont omniprésentes et nécessitent une réflexion approfondie.

**Enseignements tirés :**
- Il est crucial de développer des modèles **expliquables** pour garantir la confiance des professionnels de santé.
- L’aspect **juridique**, notamment les contraintes imposées par la CNIL, doit être pris en compte dès le début du projet.
- La **collaboration interdisciplinaire** (entre médecins, data scientists, et juristes) est essentielle à la réussite de tels projets.