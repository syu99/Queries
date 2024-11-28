---profit par mois (hotel/voiture)
WITH car_profit AS
(
  SELECT
    DATE_TRUNC(start_date,MONTH) AS month,
    SUM(price * commission) AS profit,
    'car' AS type
  FROM
    carteldeladata.travel_bc.car_bookings
  JOIN
    carteldeladata.travel_bc.car_rental_companies
  ON
    car_bookings.car_rental_company_id = car_rental_companies.car_rental_company_id
  GROUP BY
    month
),

hotel_profit AS 
(
  SELECT 
    DATE_TRUNC(start_date,MONTH) AS month,
    SUM(room_price* DATE_DIFF(end_date,start_date,DAY) * commission) AS profit,
    'hotel' AS type
  FROM
    carteldeladata.travel_bc.hotel_bookings
  JOIN 
    carteldeladata.travel_bc.hotel_rooms
  ON
    hotel_bookings.hotel_id = hotel_rooms.hotel_id
  AND
    hotel_bookings.room_id = hotel_rooms.room_id
  JOIN
    carteldeladata.travel_bc.hotels
  ON
    hotel_bookings.hotel_id = hotels.hotel_id
  GROUP BY 
    month
)

SELECT
  month,
  profit,
  type
FROM
  car_profit
UNION ALL
SELECT
  month,
  profit,
  type
FROM
  hotel_profit
