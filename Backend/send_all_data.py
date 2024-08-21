import json
import sqlite3


def send_all_data():
    conn = sqlite3.connect("database_vacancie")
    conn.row_factory = sqlite3.Row  # Это позволяет обращаться к колонкам по именам
    cursor = conn.cursor()

    # Выполнение запроса для получения всех строк из указанной таблицы
    try:
        cursor.execute("SELECT * FROM User")
        # Извлечение всех строк и преобразование их в список словарей
        rows = cursor.fetchall()
        list_slovar = [dict(row) for row in rows]

        result = []
        for index in range(len(list_slovar)):
            new_slovar = {}
            new_slovar['name'] = list_slovar[index]["name"]
            new_slovar["id"] = list_slovar[index]['id']
            new_slovar['area'] = json.loads(list_slovar[index]['area'])
            new_slovar['salary'] = json.loads(list_slovar[index]['salary'])
            result.append(new_slovar)

    except:
        return []


    conn.close()
    print(result)

    return result
