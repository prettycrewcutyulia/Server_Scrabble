# Server_Scrabble
 In teams of three you should design and implement a backend service that provides an API for a game «Scrabble». The service must accept requests and respond accordingly.

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
