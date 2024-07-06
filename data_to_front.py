import sqlite3
import pandas as pd
import json

def get_all_data_from_database(response_from_front):
    text = response_from_front['text']
    area = response_from_front['area']
    salary = response_from_front['salary']
    name = response_from_front['name']


    db_path = "database_vacancie"  # Путь к вашей базе данных
    search_key = text + name + area + salary
    conn = sqlite3.connect(db_path)
    print(search_key)


    query = "SELECT * FROM User WHERE search_key = ?"
    df = pd.read_sql_query(query, conn, params=(search_key,))



    conn.close()
    df = df.fillna('')
    df['department'] = df['department'].apply(lambda x: json.loads(x) if pd.notna(x) else None)
    df['area'] = df['area'].apply(lambda x: json.loads(x) if pd.notna(x) else None)
    df['salary'] = df['salary'].apply(lambda x: json.loads(x) if pd.notna(x) else None)
    df['type'] = df['type'].apply(lambda x: json.loads(x) if pd.notna(x) else None)
    df['address'] = df['address'].apply(lambda x: json.loads(x) if pd.notna(x) else None)
    df['insider_interview'] = df['insider_interview'].apply(lambda x: json.loads(x) if pd.notna(x) else None)
    df['relations'] = df['relations'].apply(lambda x: json.loads(x) if pd.notna(x) else None)
    df['employer'] = df['employer'].apply(lambda x: json.loads(x) if pd.notna(x) else None)
    df['snippet'] = df['snippet'].apply(lambda x: json.loads(x) if pd.notna(x) else None)
    df['schedule'] = df['schedule'].apply(lambda x: json.loads(x) if pd.notna(x) else None)
    df['working_days'] = df['working_days'].apply(lambda x: json.loads(x) if pd.notna(x) else None)
    df['working_time_intervals'] = df['working_time_intervals'].apply(lambda x: json.loads(x) if pd.notna(x) else None)
    df['working_time_modes'] = df['working_time_modes'].apply(lambda x: json.loads(x) if pd.notna(x) else None)
    df['professional_roles'] = df['professional_roles'].apply(lambda x: json.loads(x) if pd.notna(x) else None)
    df['experience'] = df['experience'].apply(lambda x: json.loads(x) if pd.notna(x) else None)
    df['employment'] = df['employment'].apply(lambda x: json.loads(x) if pd.notna(x) else None)
    list_of_dicts = df.to_dict(orient='records')
    # print('TOLIST')

    # если данные с зп пришли
    # print(salary)
    if salary != '' and salary != ',':
        salary_list = salary.split(",")
        from_salary = salary_list[0] if salary_list[0] != "" else (-1)
        to_salary = salary_list[1] if salary_list[1] != "" else (10**10)
        nothing_data = False
        from_salary = int(from_salary)
        to_salary = int(to_salary)
        print("to_salary")
        print(to_salary)
        print("from_salary")
        print(from_salary)
        print('nothing_data')
        print(nothing_data)

    # Если параметр пустой, то значит фильтр просто не был выбран
    else:
        nothing_data = True



    result_list = []
    for index in range(len(list_of_dicts)):
    # for index in range(1):
        flag = False
        if name != '':
            if not (name.lower() in list_of_dicts[index]["name"].lower()):
                flag = True
        if not flag:

            if area != '':
                print('FIRST:', list_of_dicts[index]['area']["id"])
                if not (str(area) == list_of_dicts[index]['area']["id"]):
                    flag = True
            if not(list_of_dicts[index]['salary']["from"] is  None) and not(list_of_dicts[index]['salary']["to"] is None) and not nothing_data and not flag:
                # если зпОт > словарьЗначениеОт и зпДо < словарьЗначениеДо
                if (from_salary > list_of_dicts[index]['salary']["from"] or (to_salary < list_of_dicts[index]['salary']["to"])):
                    flag = True

            # если словарьЗначениеОт нуль И словарьЗначениеДо НЕ нуль И инфа есть
            elif (list_of_dicts[index]['salary']["from"] is None) and (not (list_of_dicts[index]['salary']["to"] is None)) and not nothing_data and not flag:
                # Если словарьЗначениеДо > зпДо то поднимаем флаг
                if (list_of_dicts[index]['salary']["to"] > to_salary) or (list_of_dicts[index]['salary']["to"] < from_salary):
                    flag = True
            # Если (словарьЗначениеОт НЕ нуль) и словарь ЗначениеДо == нуль и данные есть
            elif (not (list_of_dicts[index]['salary']["from"] is None)) and (list_of_dicts[index]['salary']["to"] is None) and not nothing_data and not flag:
                # если словарьЗначениеОт меньше зпОт то поднимаем флаг
                if (list_of_dicts[index]['salary']["from"] < from_salary) or (list_of_dicts[index]['salary']["from"] > to_salary):
                    flag = True
            else:
                if not nothing_data:
                    flag = True
        test_slovar = {}
        # Добавляем то что буде показываться на фронт
        test_slovar['name'] = list_of_dicts[index]["name"]
        test_slovar['area'] = list_of_dicts[index]["area"]
        test_slovar['id'] = list_of_dicts[index]['id']
        test_slovar['salary'] = list_of_dicts[index]['salary']
        if not flag:
            result_list.append(test_slovar)
            # result_list.append(json.dumps(slovar))
    # if  (result_list != []):
    #     print(result_list)
    print('IF/Else stop')
    return result_list

