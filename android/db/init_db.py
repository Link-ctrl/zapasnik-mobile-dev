import sqlite3

# Подключаемся к базе данных (файл будет создан, если не существует)
conn = sqlite3.connect("mydatabase.db")
cursor = conn.cursor()

# Читаем SQL-скрипт из файла
with open("init.sql", "r") as sql_file:
    sql_script = sql_file.read()

# Выполняем скрипт
cursor.executescript(sql_script)

# Сохраняем изменения и закрываем соединение
conn.commit()
conn.close()

print("База данных успешно инициализирована!")