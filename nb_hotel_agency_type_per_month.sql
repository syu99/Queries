-- Analyse des entités signées par mois
-- Cette requête SQL calcule le nombre d'hôtels, d'agences de location de voitures, et d'utilisateurs
-- signés chaque mois. Les résultats sont combinés dans une seule table pour une analyse consolidée.

-- Nombre d'agences de location de voitures signées par mois
WITH car_agencies_signed_per_month AS (
  SELECT
    DATE_TRUNC(created_at, MONTH) AS month, -- Troncature de la date au mois
    COUNT(car_rental_company_id) AS total_signed, -- Nombre total d'agences signées
    'car' AS type -- Type d'entité (agence de location)
  FROM
    carteldeladata.travel_bc.car_rental_companies
  GROUP BY
    month
),

-- Nombre d'hôtels signés par mois
hotels_signed_per_month AS (
  SELECT
    DATE_TRUNC(created_at, MONTH) AS month,
    COUNT(hotel_id) AS total_signed,
    'hotel' AS type -- Type d'entité (hôtel)
  FROM
    carteldeladata.travel_bc.hotels
  GROUP BY
    month
),

-- Nombre d'utilisateurs signés par mois
users_per_month AS (
  SELECT
    DATE_TRUNC(created_at, MONTH) AS month,
    COUNT(user_id) AS nb_users, -- Nombre d'utilisateurs signés
    'user' AS type -- Type d'entité (utilisateur)
  FROM
    carteldeladata.travel_bc.users
  GROUP BY
    month
),

-- Combinaison des résultats
combined_signed_per_month AS (
  SELECT 
    month,
    total_signed,
    type
  FROM 
    car_agencies_signed_per_month
  UNION ALL
  SELECT
    month,
    total_signed,
    type
  FROM
    hotels_signed_per_month
  UNION ALL
  SELECT
    month,
    nb_users AS total_signed,
    type
  FROM
    users_per_month
)

-- Résultats finaux triés par type et par mois décroissant
SELECT 
  *
FROM
  combined_signed_per_month
ORDER BY
  type, month DESC;
