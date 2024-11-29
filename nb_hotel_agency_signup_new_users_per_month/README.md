# Analyse des entités signées par mois

## Objectif
Cette requête SQL calcule le nombre d'hôtels, d'agences de location de voitures, et d'utilisateurs 
signés chaque mois, puis combine les résultats pour une analyse consolidée.

## Structure de la requête
- **car_agencies_signed_per_month** : Calcule le nombre d'agences de location signées par mois.
- **hotels_signed_per_month** : Calcule le nombre d'hôtels signés par mois.
- **users_per_month** : Calcule le nombre d'utilisateurs inscrits par mois.
- **combined_signed_per_month** : Combine les résultats des trois sous-requêtes en une seule table.

## Résultats
Les résultats finaux incluent :
- **month** : Le mois de l'activité.
- **total_signed** : Le nombre total d'entités signées.
- **type** : Le type d'entité (hôtel, agence, utilisateur).

## Comment utiliser
Exécutez la requête dans un environnement compatible SQL comme BigQuery. Remplacez les noms de
tables et datasets si nécessaire pour s'adapter à votre environnement.

## Exemple de données simulées
Vous pouvez simuler les données en créant des tables temporaires pour tester cette requête :
```sql
CREATE TEMP TABLE car_rental_companies (
    car_rental_company_id INT64,
    created_at TIMESTAMP
);
