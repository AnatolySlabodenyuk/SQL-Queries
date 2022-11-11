-- Курс "Интерактивный тренажер по SQL" на Stepik

-- Создание таблицы
CREATE TABLE book(
    book_id INT PRIMARY KEY AUTO_INCREMENT, 
    title	VARCHAR(50),
    author	VARCHAR(30),
    price	DECIMAL(8, 2),
    amount	INT
);

-- Добавление записей в таблицу
INSERT INTO book (title, author, price, amount) 
VALUES ('Белая гвардия', 'Булгаков М.А.', 540.50, 5),
       ('Идиот', 'Достоевский Ф.М.', 460.00, 10),
       ('Братья Карамазовы', 'Достоевский Ф.М.', 799.01, 2);

-- Просмотр всех записей
SELECT * FROM book;

-- Выборка отдельных столбцов
SELECT author, title, price 
FROM book;

-- Присвоение имен
SELECT title AS Название, 
	   author AS Автор
FROM book;

-- Математические функции
SELECT title, author, amount,
       ROUND(price - (price * 30 / 100), 2) AS new_price -- округление значения
FROM book;

-- IF / ELSE
SELECT author, title,
    ROUND (
    	IF(
    		author = 'Булгаков М.А.', price*1.1, IF(
    			author = 'Есенин С.А.', price*1.05, price
    			)
    		), 2
    	) AS new_price
FROM book;

-- Условие WHERE
SELECT author, title, price
FROM book
WHERE amount < 10;

-- Логические операции
SELECT  title, author, price, amount
FROM book
WHERE 
(price < 500 OR price > 600) AND price * amount >= 5000;

-- BETWEEN / IN
SELECT title, author
FROM book
WHERE 
(price BETWEEN 540.50 AND 800) AND amount IN (2, 3, 5, 7);

-- Сортировка
SELECT author, title
FROM book
WHERE amount BETWEEN 2 AND 14
ORDER BY 1 DESC, 2;

-- LIKE
SELECT title,
    author
FROM book
WHERE title LIKE "_% _%"
    AND author LIKE "%С.%"
ORDER BY 1;

-- Уникальные элементы 
SELECT DISTINCT amount 
FROM book;

-- Группировка 
SELECT author AS Автор, COUNT(title) AS Различных_книг, SUM(amount) AS Количество_экземпляров
FROM book
GROUP BY author;

-- MIN / MAX / AVG
SELECT author, 
	   MIN(price) AS Минимальная_цена , 
	   MAX(price) AS Максимальная_цена, 
	   AVG (price) AS Средняя_цена
FROM book
GROUP BY author;

-- Группировка с условием
SELECT ROUND(AVG(price),2) AS Средняя_цена,
       ROUND(SUM(price * amount),2) AS Стоимость
FROM book
WHERE amount BETWEEN 5 AND 14;

-- HAVING
SELECT author, SUM(price * amount) AS Стоимость
FROM book 
WHERE title <> 'Идиот' AND title <> 'Белая гвардия'
GROUP BY author
HAVING Стоимость > 5000
ORDER BY Стоимость DESC;

-- Вложенные запросы
SELECT author, title, price
FROM book 
WHERE price <= (
      SELECT AVG(price)
      FROM book
    )
ORDER BY price DESC;

-- Вложенный запрос + IN
SELECT author, title, amount
FROM book
WHERE amount IN (
	  SELECT amount
	  FROM book
	  GROUP BY amount
      HAVING COUNT(amount) = 1
 	);

-- Вложенный запрос в результатах 
SELECT title, author, amount, 
	   abs(amount - (SELECT MAX(amount) FROM book)) AS Заказ
FROM book
WHERE amount != (SELECT max(amount) FROM book);

-- Добавление записей из другой таблицы
INSERT INTO book
(title, author, price, amount)
SELECT title, author, price, amount
FROM supply
WHERE author NOT IN ('Булгаков М.А.', 'Достоевский Ф.М.');
SELECT * FROM book;

-- Добавление записей через вложенные запросы
INSERT INTO book (title, author, price, amount)
SELECT title, author, price, amount FROM supply
WHERE author NOT IN(
      SELECT author FROM book
	  );
SELECT * FROM book;

-- Обновление записей
UPDATE book
SET price = 0.9 * price
WHERE amount BETWEEN 5 AND 10; 

-- Обновление нескольких столбцов
UPDATE book
SET buy = IF(buy > amount, amount, buy), 
    price = IF(buy = 0, 0.9 * price, price);
SELECT * FROM book;

-- Обновление записей в нескольких таблицах
UPDATE book, supply
SET book.amount = book.amount + supply.amount,
    book.price = (book.price + supply.price) / 2
    WHERE book.title = supply.title AND book.author = supply.author;
SELECT * FROM book;

-- Удаление записей
DELETE FROM supply
WHERE author IN (
      SELECT author FROM book
      GROUP BY author
      HAVING SUM(amount) > 10
     );









