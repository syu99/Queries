
--revenu par mois et par type (hotel/voiture)
--Nb reservation par mois et par “type”
--Nb users par mois	

WITH 
-- Revenu par mois et par type (hôtel/voiture)
car_profit AS (
  SELECT
    DATE_TRUNC(start_date, MONTH) AS month,
    SUM(price * commission) AS value,
    'car_profit' AS type
  FROM
    carteldeladata.travel_bc.car_bookings
  JOIN
    carteldeladata.travel_bc.car_rental_companies
  ON
    car_bookings.car_rental_company_id = car_rental_companies.car_rental_company_id
  GROUP BY 
    month
),

hotel_profit AS (
  SELECT 
    DATE_TRUNC(start_date, MONTH) AS month,
    SUM(room_price * DATE_DIFF(end_date, start_date, DAY) * commission) AS value,
    'hotel_profit' AS type
  FROM
    carteldeladata.travel_bc.hotel_bookings
  JOIN
    carteldeladata.travel_bc.hotel_rooms
  ON
    hotel_bookings.hotel_id = hotel_rooms.hotel_id
    AND hotel_bookings.room_id = hotel_rooms.room_id
  JOIN
    carteldeladata.travel_bc.hotels
  ON
    hotel_bookings.hotel_id = hotels.hotel_id
  GROUP BY 
    month
),

-- Nombre de réservations par mois et par type (hôtel/voiture)
car_booking AS (
  SELECT
    DATE_TRUNC(booked_at, MONTH) AS month,
    COUNT(booking_id) AS value,
    'car_booking' AS type
  FROM
    carteldeladata.travel_bc.car_bookings
  GROUP BY 
    month
),
hotel_booking AS (
  SELECT
    DATE_TRUNC(booked_at, MONTH) AS month,
    COUNT(booking_id) AS value,
    'hotel_booking' AS type
  FROM
    carteldeladata.travel_bc.hotel_bookings
  GROUP BY 
    month
),

-- Nombre d'utilisateurs par mois
users_signed_per_month AS (
  SELECT
    DATE_TRUNC(created_at, MONTH) AS month,
    COUNT(user_id) AS value,
    'user_signup' AS type
  FROM
    carteldeladata.travel_bc.users
  GROUP BY 
    month
),

-- Combinaison des résultats
combo_data AS (
  SELECT 
    month, 
    value, 
    type 
  FROM 
    car_profit
  UNION ALL
  SELECT 
    month, 
    value, 
    type 
  FROM 
    hotel_profit
  UNION ALL
  SELECT 
    month, 
    value, 
    type 
  FROM 
    car_booking
  UNION ALL
  SELECT 
    month, 
    value, 
    type 
  FROM 
    hotel_booking
  UNION ALL
  SELECT 
    month, 
    value, 
    type 
  FROM 
    users_signed_per_month
)

-- Résultats finaux
SELECT
  month,
  value,
  type
FROM
  combo_data
ORDER BY 
  month DESC, 
  type;
