---
sidebar_position: 2
sidebar_label: Types de BDD NoSQL
hide_title: true
---

# Types de bases de données NoSQL

NoSQL regroupe divers types de bases de données, chacune avec des caractéristiques spécifiques, adaptées à des cas d'utilisation particuliers.

## Principaux types de bases de données NoSQL

1. **Bases de données clé-valeur**
   - Structure : Données stockées sous forme de paires clé-valeur.
   - Exemples : Redis, Amazon DynamoDB.
   - Cas d'utilisation : Caching, sessions utilisateurs, journaux d'événements.

2. **Bases de données documentaires**
   - Structure : Données sous forme de documents (souvent JSON).
   - Exemples : MongoDB, CouchDB.
   - Cas d'utilisation : Applications web, contenus multimédia, gestion de catalogues.

3. **Bases de données en colonnes**
   - Structure : Données organisées par colonnes plutôt que par lignes.
   - Exemples : Cassandra, HBase.
   - Cas d'utilisation : Analyses Big Data, applications analytiques, reporting.

4. **Bases de données de graphes**
   - Structure : Données sous forme de nœuds et de relations.
   - Exemples : Neo4j, Amazon Neptune.
   - Cas d'utilisation : Réseaux sociaux, analyses de relations complexes, cartographie.

## Comparaison avec les SGBDR

Contrairement aux SGBDR qui imposent un schéma structuré, les bases NoSQL offrent une **flexibilité de schéma**, permettant d’ajouter des champs sans migration. Cependant, elles ne garantissent pas toujours les propriétés **ACID** (Atomicité, Cohérence, Isolation, Durabilité) dans les transactions.