-- Illuminos — схема базы данных (utf8mb4 на всех уровнях).
-- Импортировать в чистую базу или выполнять на существующей.
-- Внимание: DROP TABLE удалит существующие данные этих таблиц.

CREATE DATABASE IF NOT EXISTS illuminos
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

ALTER DATABASE illuminos
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE illuminos;

SET NAMES utf8mb4;

-- Порядок удаления учитывает внешние ключи.
DROP TABLE IF EXISTS episodes;
DROP TABLE IF EXISTS watch_history;
DROP TABLE IF EXISTS favorites;
DROP TABLE IF EXISTS subscriptions;
DROP TABLE IF EXISTS content;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(190) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  role ENUM('user','subscriber','admin') NOT NULL DEFAULT 'user',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE content (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(180) NOT NULL,
  content_type ENUM('movie','series') NOT NULL,
  genre VARCHAR(80) NOT NULL,
  year SMALLINT NOT NULL,
  rating DECIMAL(2,1) NOT NULL DEFAULT 8.0,
  description TEXT NOT NULL,
  director VARCHAR(150) NOT NULL,
  cast_list VARCHAR(255) NOT NULL,
  trailer_url VARCHAR(255) DEFAULT NULL,
  featured TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE episodes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  content_id INT NOT NULL,
  season_number INT NOT NULL,
  episode_number INT NOT NULL,
  title VARCHAR(180) NOT NULL,
  FOREIGN KEY (content_id) REFERENCES content(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE favorites (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  content_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY unique_favorite (user_id, content_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (content_id) REFERENCES content(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE watch_history (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  content_id INT NOT NULL,
  viewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (content_id) REFERENCES content(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE subscriptions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  plan_name VARCHAR(80) NOT NULL,
  price DECIMAL(8,2) NOT NULL,
  status ENUM('active','cancelled') NOT NULL DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO content (title,content_type,genre,year,rating,description,director,cast_list,featured) VALUES
('Грань будущего','movie','Фантастика',2024,8.7,'Захватывающая история о будущем, где команда исследователей пытается изменить ход событий.','Алексей Миронов','Ирина Волкова, Марк Левин, Даниил Орлов',1),
('Тихий город','movie','Триллер',2023,8.2,'В небольшом городе происходят загадочные события, которые меняют жизни его жителей.','Мария Соколова','Анна Белова, Павел Ким, Артём Савин',1),
('После сигнала','series','Драма',2025,9.1,'Группа незнакомцев получает странное сообщение и начинает искать его источник.','Елена Кравцова','Мила Романова, Тимур Алиев, Никита Громов',1),
('Орбита 9','series','Фантастика',2024,8.9,'Экипаж космической станции сталкивается с неизвестным явлением на орбите.','Денис Фролов','Вера Ли, Максим Нестеров, Олег Данилов',1),
('Летний маршрут','movie','Комедия',2022,7.8,'Лёгкая комедия о путешествии, случайных встречах и неожиданных открытиях.','Игорь Беляев','София Мир, Кирилл Денисов',0),
('Ночная смена','movie','Ужасы',2023,7.9,'Одна ночная смена в старом здании превращается в испытание на смелость.','Роман Чернов','Лев Андреев, Алиса Тихая',0),
('Северный ветер','series','Приключения',2021,8.4,'История команды, отправившейся исследовать неизведанные территории.','Ольга Дан','Дмитрий Волков, Лана Ким',0),
('Код памяти','series','Детектив',2025,8.6,'Следователь распутывает дело, в котором каждая улика связана с прошлым.','Сергей Лис','Ева Смирнова, Арсен Павлов',0),
('Последний этаж','movie','Драма',2020,8.0,'Несколько историй жителей одного дома переплетаются в один важный вечер.','Нина Орлова','Андрей Котов, Полина Белая',0),
('Параллель','movie','Фантастика',2025,9.0,'Учёные обнаруживают способ заглянуть в альтернативную реальность.','Виктор Рэй','Марк Левин, Вера Ли',0);

INSERT INTO episodes (content_id,season_number,episode_number,title)
SELECT id,1,1,'Первый сигнал' FROM content WHERE title='После сигнала';
INSERT INTO episodes (content_id,season_number,episode_number,title)
SELECT id,1,2,'Точка контакта' FROM content WHERE title='После сигнала';
INSERT INTO episodes (content_id,season_number,episode_number,title)
SELECT id,1,1,'Пробуждение' FROM content WHERE title='Орбита 9';