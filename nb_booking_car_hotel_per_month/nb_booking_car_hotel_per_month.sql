--Nb reservation voitures/hotels par mois 
WITH car_booking AS
(
  SELECT 
    DATE_TRUNC(booked_at,MONTH) as month,
    COUNT(booking_id) AS booking_per_month,
    'car' AS type
  FROM
    carteldeladata.travel_bc.car_bookings
  GROUP BY month
),
hotel_booking AS 
(
  SELECT 
    DATE_TRUNC(booked_at,MONTH) AS month,
    COUNT(booking_id) AS booking_per_month,
    'hotel' AS type
  FROM
    carteldeladata.travel_bc.hotel_bookings
  GROUP BY 
    month
)

SELECT
  month,
  booking_per_month,
  type 
FROM
  car_booking
UNION ALL
SELECT
  month,
  booking_per_month,
  type 
FROM
  hotel_booking