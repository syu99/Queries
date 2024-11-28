--Nb reservation voitures/hotels par mois 
WITH car_booking AS
(
  SELECT 
    DATE_TRUNC(start_date,MONTH) as month,
    COUNT(booked_at) AS booking_per_month,
    'car' AS type
  FROM
    carteldeladata.travel_bc.car_bookings
  GROUP BY month
),
hotel_booking AS 
(
  SELECT 
    DATE_TRUNC(start_date,MONTH) AS month,
    COUNT(booked_at) AS booking_per_month,
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