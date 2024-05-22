

-- Для показу топ-3 тури за кількістю бронювань, ми можемо використати такий запит:
SELECT tours.*, COUNT(bookings.id) AS booking_count FROM tours 
LEFT JOIN bookings ON tours.id = bookings.tour_id 
GROUP BY tours.id 
ORDER BY booking_count DESC 
LIMIT 3;
 
-- Для видалення всіх бронювань для конкретного клієнта:
DELETE FROM bookings WHERE client_id = {client_id};
Для підрахунку загальної суми всіх оплачених платежів:
SELECT SUM(amount) AS total_paid_amount 
FROM payments 
WHERE status = 'paid';
 
-- Вибірка найбільш активних клієнтів(топ-5) за кількістю бронювань:
SELECT clients.*, COUNT(bookings.id) AS booking_count 
FROM clients 
LEFT JOIN bookings ON clients.id = bookings.client_id 
GROUP BY clients.id 
ORDER BY booking_count DESC 
LIMIT 5;
 
-- Вибірка турів, які ще не почалися:
SELECT * FROM tours 
WHERE start_date > CURRENT_DATE;
 
-- Вибірка середньої кількості бронювань на клієнта:
SELECT AVG(booking_count) AS average_bookings_per_client 
FROM ( 
SELECT client_id, COUNT(*) AS booking_count FROM bookings GROUP BY client_id 
) 
AS subquery;
 
-- Вибірка клієнтів, які здійснили бронювання на тури після 01.01.2024 та заплатили за них:
SELECT clients.*
FROM clients
INNER JOIN bookings ON clients.id = bookings.client_id
INNER JOIN payments ON bookings.id = payments.booking_id
INNER JOIN tours ON bookings.tour_id = tours.id
WHERE tours.start_date > '2024-01-01' AND payments.status = 'paid';
 
-- Вибірка клієнтів з кількістю їх бронювань:
SELECT clients.*, COUNT(bookings.id) AS booking_count 
FROM clients 
LEFT JOIN bookings ON clients.id = bookings.client_id 
GROUP BY clients.id;
 
-- Вибірка турів, які ще не мають бронювань:
SELECT * FROM tours 
LEFT JOIN bookings ON tours.id = bookings.tour_id 
WHERE bookings.id IS NULL;

-- Вибірка всіх клієнтів, які ще не здійснили бронювань:
SELECT * FROM clients 
LEFT JOIN bookings ON clients.id = bookings.client_id 
WHERE bookings.id IS NULL;

-- Вибірка кількості бронювань для кожного туру:
SELECT tour_id, COUNT(*) AS booking_count FROM bookings GROUP BY tour_id;
 
-- Вибірка всіх бронювань для туру, які починаються з певної дати:
SELECT * FROM bookings 
INNER JOIN tours ON bookings.tour_id = tours.id 
WHERE tours.start_date > '2024-05-01';
 
-- Запит для оновлення інформації про клієнта:
UPDATE clients SET first_name = 'Нове ім'я' WHERE id = {client_id};
 
-- Запит для оновлення статусу на “confirmed” для конкретного бронювання:
UPDATE bookings SET status = 'approved' WHERE id = {booking_id};
 
-- Вибірка турів, ціна яких перевищує середню вартість всіх турів:
SELECT *
FROM tours
WHERE price > (SELECT AVG(price) FROM tours);
 
-- Вибірка турів, які мають кількість бронювань менше середнього значення кількості бронювань для всіх турів:
SELECT tours.*, COUNT(bookings.id) AS booking_count
FROM tours
LEFT JOIN bookings ON tours.id = bookings.tour_id
GROUP BY tours.id
HAVING booking_count < (SELECT AVG(booking_count) FROM (SELECT COUNT(*) AS booking_count FROM bookings GROUP BY tour_id) AS subquery);
 
-- Вибірка інформації про тури, які ще не почалися і впорядкована за датою початку:
SELECT * FROM tours WHERE start_date > CURRENT_DATE ORDER BY start_date;
 
-- У якого працівника(1 чи 10) було більше бронювань:
SELECT 
CASE WHEN SUM(CASE WHEN processed_by = 1 THEN 1 ELSE 0 END) > SUM(CASE WHEN processed_by = 10 THEN 1 ELSE 0 END) 
THEN 'Employee 1' 
ELSE 'Employee 10' 
END AS employee_with_more_bookings 
FROM bookings;
 
-- У якого працівника було більше підтверджених бронювань:
SELECT 
CASE WHEN SUM(CASE WHEN processed_by = 1 AND status = 'approved' THEN 1 ELSE 0 END) > SUM(CASE WHEN processed_by = 10 AND status = 'approved' THEN 1 ELSE 0 END) 
THEN 'Employee 1' 
ELSE 'Employee 10' 
END AS employee_with_more_approved_bookings 
FROM bookings;
 
-- На яку суму бронювання у працівника 1 та 10:
SELECT processed_by, SUM(booking_price) AS total_booking_amount
FROM bookings 
WHERE processed_by IN (1, 10) 
GROUP BY processed_by;
 
-- Запит, який підраховує кількість бронювань у кожного працівника за статусами бронювань:
SELECT processed_by, status, COUNT(*) AS num_bookings 
FROM bookings 
WHERE processed_by IN (1, 10) 
GROUP BY processed_by, status;
 
-- Запит, який виводить список всіх турів, від бронювання яких відмовилися:
SELECT 
t.id, 
t.tour_name, 
t.description 
FROM tours t 
INNER JOIN bookings b ON t.id = b.tour_id 
WHERE b.status = 'rejected';

