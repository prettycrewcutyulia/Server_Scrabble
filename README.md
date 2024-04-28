# Server_Scrabble
 In teams of three you should design and implement a backend service that provides an API for a game «Scrabble». The service must accept requests and respond accordingly.

## Развертывание и администрирование системы
### Как развернуть систему
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

### Добавление API ключа: 

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

## Использование API на клиентах
Эндпоинты API, которые доступны клиентам представены в Postman:

[<img src="https://run.pstmn.io/button.svg" alt="Run In Postman" style="width: 128px; height: 32px;">](https://app.getpostman.com/run-collection/16591743-09507c13-eb6d-4a22-9dac-9e45f5a9ad75?action=collection%2Ffork&source=rip_markdown&collection-url=entityId%3D16591743-09507c13-eb6d-4a22-9dac-9e45f5a9ad75%26entityType%3Dcollection%26workspaceId%3D3e05b8c0-ac2f-46ad-b9b1-934571107a79#?env%5BNew%20Environment%5D=W10=)

### Как устроен запрос к API
* У любого запроcа должен присутствовать header `ApiKey: <YOUR_API_KEY>` - ключ, который добавлен в базу данных, которая подключена к серверу. Если данный header не установлен или установлен с неправильным значением, пользователь получит ошибку
* Для запросов, которым требуется авторизация (то есть всем, кроме `/auth/login` и `/auth/register`), должен присутствовать header `Authorization: Bearer <JWT_TOKEN>`, значением которого является JWT-токен, полученный при авторизации
