# Server_Scrabble
 In teams of three you should design and implement a backend service that provides an API for a game «Scrabble». The service must accept requests and respond accordingly.

## Как развернуть систему
1. Установить [brew](https://brew.sh/)
2. Установить Docker и PostgreSQL:
```bash
brew install --cask docker
brew install postgresql
```
3. Запустить PostgreSQL:
```
brew services start postgresql
```
4. Создать базу данных, к которой будет подключаться сервер
```
psql postgres
CREATE ROLE vapor_username WITH LOGIN PASSWORD 'vapor_password';
ALTER ROLE vapor_username CREATEDB;

psql postgres -U vapor_username;
CREATE DATABASE vapor_database;
```
5. Запустить докер-контейнер с базой данных:
```
docker-compose up db
```

## Добавление API ключа: 

Сначала нужно подключиться к базе данных: 
```bash
psql vapor_database
```

После подключения ввести скрипт:
```sql
DO $$
DECLARE 
    key uuid := gen_random_uuid ();
BEGIN
INSERT INTO api_keys
(id, expires_at)
VALUES(key, NULL);
RAISE NOTICE 'New API key: %', key;
END $$;
```
Вместо `NULL` в `expires_at` можно указать время, до которого API ключ действителен
