1. Objectif de la requête
Cette requête vise à fournir une vue consolidée de plusieurs indicateurs mensuels essentiels pour une entreprise de voyage en ligne :

Revenu mensuel par type (hôtels et voitures).
Nombre de réservations mensuelles par type (hôtels et voitures).
Nombre d’utilisateurs inscrits mensuellement.
Elle permet de suivre la performance des différents secteurs (hôtels, voitures) et l’acquisition de nouveaux utilisateurs, tout en offrant des insights pour optimiser les stratégies marketing et commerciales.

2. Analyse des différentes parties de la requête
2.1. Revenu par mois et par type (hôtel/voiture)
Pourquoi calculer comme ceci ?
Revenu des voitures :

Le revenu est calculé comme SUM(price * commission) parce que chaque réservation de voiture génère un montant basé sur le prix total de la réservation et une commission appliquée.
Exemple : Une réservation de voiture à 100€ avec une commission de 20% rapporte 20€.
Revenu des hôtels :

Le revenu est calculé comme SUM(room_price * DATE_DIFF(end_date, start_date, DAY) * commission). Cela reflète :
Le prix de la chambre multiplié par la durée de la réservation (en jours).
La commission appliquée à la somme totale.
Exemple : Une chambre à 50€/nuit pour 3 nuits avec une commission de 10% rapporte 15€.
Pourquoi ces jointures ?
Car bookings & car_rental_companies :

Cette jointure relie les informations de réservation de voiture (car_bookings) avec les détails de la société de location (car_rental_companies), où se trouve le pourcentage de commission.
Attention : Sans cette jointure, il est impossible de calculer correctement le revenu car la commission est stockée dans une autre table.
Hotel bookings & hotel_rooms & hotels :

Les informations nécessaires pour calculer les revenus des hôtels sont réparties sur plusieurs tables :
hotel_bookings contient les informations de réservation (dates, chambres).
hotel_rooms contient le prix des chambres.
hotels contient la commission.
Ces jointures assurent que chaque réservation est correctement associée à son prix et sa commission.
Attention : Si les conditions de jointure (ON clauses) ne sont pas précises, des doublons ou des erreurs peuvent fausser les calculs.
2.2. Nombre de réservations par mois et par type
Pourquoi calculer comme ceci ?
Les réservations sont comptées simplement via COUNT(booked_at), car chaque enregistrement dans la table représente une réservation unique.
Séparation par type :
Les voitures et les hôtels sont traités séparément pour permettre une analyse individuelle de leurs performances.
Pièges à éviter :
Données manquantes :
Si la colonne booked_at contient des valeurs NULL, elles ne seront pas comptées.
Solution : S'assurer que toutes les réservations ont une date valide ou appliquer un filtre (WHERE booked_at IS NOT NULL).
Données dupliquées :
Des doublons dans les tables sources peuvent gonfler artificiellement les chiffres.
Solution : Vérifiez que les tables ne contiennent pas de doublons, ou utilisez COUNT(DISTINCT <id>) si nécessaire.
2.3. Nombre d’utilisateurs inscrits par mois
Pourquoi calculer comme ceci ?
Les utilisateurs sont comptés via COUNT(user_id), car chaque identifiant utilisateur correspond à une inscription unique.
La granularité mensuelle est obtenue via DATE_TRUNC(created_at, MONTH), ce qui permet d’agréger les inscriptions par mois.
Attention :
Inscriptions multiples :

Vérifiez que chaque user_id est unique dans la table des utilisateurs.
Si un utilisateur peut s’inscrire plusieurs fois, vous devrez peut-être utiliser COUNT(DISTINCT user_id).
Filtres temporels :

Si votre table contient des utilisateurs créés avant la période d’analyse, ajoutez un filtre pour limiter les données.
3. Pourquoi regrouper toutes les données dans une seule table ?
Avantages :
Simplicité pour l’analyse :

Les données consolidées sont faciles à visualiser dans un outil BI comme Tableau ou Google Data Studio.
Chaque ligne contient une valeur (value) et un type (type), ce qui facilite les filtrages et les regroupements.
Flexibilité :

La table combinée permet d’analyser plusieurs indicateurs (revenus, réservations, utilisateurs) en parallèle ou de les comparer directement.
4. Pièges à éviter dans la combinaison des données
Manque d’uniformité :

Toutes les CTE doivent produire les mêmes colonnes (month, value, type) pour que le UNION ALL fonctionne correctement.
Données manquantes ou partielles :

Si une source manque de données pour un mois donné, ce mois peut apparaître incomplet ou absent dans les résultats finaux.
Solution : Ajoutez une table de référence avec tous les mois attendus et effectuez un LEFT JOIN.
Problèmes de performance :

La combinaison de plusieurs tables volumineuses peut ralentir l’exécution.
Solution :
Utilisez des index sur les colonnes fréquemment utilisées dans les jointures (ex. : car_rental_company_id, hotel_id).
Limitez la période d’analyse avec un filtre temporel (WHERE start_date >= '2023-01-01').
5. Recommandations pour l’analyse
Vérifiez les données sources :

Inspectez les tables pour identifier d’éventuelles anomalies (doublons, valeurs NULL, incohérences).
Ajoutez des contextes supplémentaires :

Par exemple, segmentez les résultats par région ou par plateforme (mobile, desktop).
Suivez l’évolution dans le temps :

Comparez les performances mensuelles avec celles des mois précédents pour identifier des tendances ou des anomalies.
Préparez pour la visualisation :

Transformez les types (car_profit, hotel_booking, etc.) en dimensions lisibles pour des graphiques.