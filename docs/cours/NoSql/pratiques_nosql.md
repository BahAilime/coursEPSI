---
sidebar_position: 4
sidebar_label: Pratiques et concepts clés
hide_title: true
---

# Pratiques et concepts clés du NoSQL

Les bases de données NoSQL introduisent plusieurs concepts et pratiques importants pour leur mise en œuvre, en particulier lorsqu’il s’agit de gérer des systèmes distribués et de répondre aux besoins de performance.

## Sharding (Partitionnement)

Le **sharding**, ou partitionnement, est une technique utilisée pour diviser les données entre plusieurs serveurs afin de faciliter la scalabilité :
- **Partitionnement horizontal** : Les données sont réparties entre les serveurs par ligne (ex. : clients A-M sur un serveur et N-Z sur un autre).
- **Clé de partitionnement** : Le choix d'une clé de répartition (ex. : première lettre du nom) est crucial pour équilibrer la charge.

## Réplication et haute disponibilité

La **réplication** est le processus de copie des données sur plusieurs serveurs pour assurer la disponibilité :
- **Réplication maître-esclave** : Un serveur principal (maître) et plusieurs serveurs de sauvegarde (esclaves).
- **Réplication maître-maître** : Permet à plusieurs serveurs d’écrire et de lire des données, assurant une redondance et une tolérance aux pannes.
- **Exemple** : CouchDB permet une réplication maître-maître, idéale pour des applications offline-first.

## MapReduce

Le **modèle MapReduce** permet des traitements parallèles sur de grandes quantités de données, particulièrement pour des calculs distribués.
- **Phase Map** : Chaque fragment de données est traité par une fonction qui crée des paires clé-valeur.
- **Phase Reduce** : Les valeurs sont combinées pour obtenir un résultat final.
- **Utilisation** : CouchDB utilise ce modèle pour gérer des vues indexées de grandes quantités de documents.

## Le modèle BASE

Contrairement au modèle **ACID** (Atomicité, Cohérence, Isolation, Durabilité) des SGBDR, NoSQL utilise souvent le modèle **BASE** (Basically Available, Soft-state, Eventually consistent) :
- **Basically Available** : Le système est conçu pour être disponible même sous forte charge.
- **Soft-state** : La base de données peut changer d'état avec le temps, sans intervention.
- **Eventually Consistent** : La cohérence des données est garantie à terme, mais pas instantanément.

## CAP Theorem (Théorème de Brewer)

Le **théorème CAP** affirme qu'une base de données distribuée ne peut pas garantir simultanément :
1. **Cohérence** : Tous les nœuds voient les mêmes données.
2. **Disponibilité** : Le système est disponible malgré la perte de certains nœuds.
3. **Tolérance au partitionnement** : Le système fonctionne malgré des pannes de réseau.

## Techniques de caching et performances

Les bases de données NoSQL comme Redis et Memcached utilisent le **caching** pour stocker des données en mémoire vive, permettant des accès très rapides.
- **Utilisation des bases en RAM** : Redis stocke toutes les données en RAM avec persistance optionnelle, ce qui permet d'atteindre des vitesses de lecture/écriture élevées.
- **Expiration des données** : Les bases clé-valeur permettent de définir des durées d’expiration pour gérer le cycle de vie des données temporaires.