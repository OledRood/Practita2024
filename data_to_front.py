import sqlite3
import pandas as pd
import json


# def fetch_all_as_dict(db_path, query):
#     # Устанавливаем соединение с базой данных
#     conn = sqlite3.connect(db_path)
#     # Устанавливаем, чтобы результаты запроса возвращались в виде словарей
#     conn.row_factory = sqlite3.Row
#     cursor = conn.cursor()
#     cursor.execute(query)
#     rows = cursor.fetchall()
#     result = [dict(row) for row in rows]
#     conn.close()
#     return result



def get_all_data_from_database(response_from_front):
    text = response_from_front['text']
    area = response_from_front['area']
    salary = response_from_front['salary']
    name = response_from_front['name']
    def filter_salary(x, from_salary, to_salary):
        from_val = x.get('from')
        to_val = x.get('to')

        chet_none = 0
        if from_salary != '' and from_val != None:
            int_from_salary = int(from_salary)
            from_condition = from_val >= int_from_salary
        else:
            from_condition = True
            chet_none += 1
        if to_salary != '' and to_val != None:
            int_to_salary = int(to_salary)
            to_condition = to_val <= int_to_salary
        else:
            to_condition = True
            chet_none += 1
        # Если зп От больше искаемой И зп До меньше/равно искомой И мы знаем хоть один порог - true
        return from_condition and to_condition and (chet_none < 2)
    db_path = 'database_vacancie'  # Путь к вашей базе данных
    search_key = text + name + area + salary
    conn = sqlite3.connect(db_path)
    print(search_key)


    query = "SELECT * FROM User WHERE search_key = ?"
    df = pd.read_sql_query(query, conn, params=(search_key,))
    # print('NEW DF FROM SQLITE')
    # print(df['area'])
    # # name = "Водитель"
    # if (name != ""):
    #     df = df[df['name'].str.contains(name)]
    # print('NAME OK')
    # if (area != '' or area != ' '):
    #     df['area'] = df["area"].apply(json.loads)
    #     df = df[df['area'].apply(lambda x: x['id'] == area)]
    #     df['area'] = df['area'].apply(json.dumps)
    # print('AREA OK')
    # print(salary)

    # if (salary != '' or salary != ","):
    #     salary_list = salary.split(',')
    #     df['salary'] = df["salary"].apply(json.loads)
    #     df = df[df['salary'].apply(lambda x: filter_salary(x=x, from_salary=salary_list[0], to_salary=salary_list[1]))]
    #     df['salary'] = df['salary'].apply(json.dumps)


    conn.close()
    df = df.fillna('')
    # print('FILLNA')
    # print(df)

    index = 0
    # for anketa in fetch_all_as_dict(db_path, query):
    #     result[index] = anketa
    #     index += 1
    # print(f"RESULT FROM GET ALL DATA{result[0]}")
    # print(results[0])
    list_of_dicts = df.to_dict(orient='records')
    print('TOLIST')
    print(list_of_dicts)

    return list_of_dicts
