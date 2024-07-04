import sqlite3

from parcing import parcing


def createBD(connection):

    cursor = connection.cursor()
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS User (
        id INTEGER PRIMARY KEY,
        premium BOOLEAN,
        name TEXT,
        department TEXT,
        has_test BOOLEAN,
        response_letter_required BOOLEAN,
        area TEXT,
        salary REAL,
        type TEXT,
        address TEXT,
        response_url TEXT,
        sort_point_distance REAL,
        published_at TEXT,
        created_at TEXT,
        archived BOOLEAN,
        apply_alternate_url TEXT,
        show_logo_in_search BOOLEAN,
        insider_interview TEXT,
        url TEXT,
        alternate_url TEXT,
        relations TEXT,
        employer TEXT,
        snippet TEXT,
        contacts TEXT,
        schedule TEXT,
        working_days TEXT,
        working_time_intervals TEXT,
        working_time_modes TEXT,
        accept_temporary BOOLEAN,
        professional_roles TEXT,
        accept_incomplete_resumes BOOLEAN,
        experience TEXT,
        employment TEXT,
        adv_response_url TEXT,
        is_adv_vacancy BOOLEAN,
        adv_context TEXT,
        search_key TEXT
    )
    ''')
    connection.commit()
    print("BD create")



def save_df_to_sql(df, connection):
    name_column = "id, premium, name, department, has_test, response_letter_required, area, salary, type, address, response_url, sort_point_distance, published_at, created_at, archived, apply_alternate_url, show_logo_in_search, insider_interview, url, alternate_url, relations, employer, snippet, contacts, schedule, working_days, working_time_intervals, working_time_modes, accept_temporary, professional_roles, accept_incomplete_resumes, experience, employment, adv_response_url, is_adv_vacancy, adv_context, search_key"
    placeholders = ', '.join(['?'] * 37)
    data_to_insert = [tuple(row) for row in df.itertuples(index=False, name=None)]

    # connection.executemany(f'''
    #     INSERT INTO User ({name_column}) VALUES ({placeholders})
    #     ON CONFLICT(id) DO UPDATE SET name=excluded.name
    #     ''', data_to_insert)
    update_columns = ', '.join([f"{col}=excluded.{col}" for col in name_column.split(', ')])

    connection.executemany(f'''
        INSERT INTO User ({name_column}) VALUES ({placeholders})
        ON CONFLICT(id) DO UPDATE SET {update_columns}
        ''', data_to_insert)

    connection.commit()
    print("Данные успешно вставлены или обновлены в таблице User")


def main_base_operation(text, salary, area, name, response_from_front):
    # Создаем соединение
    name_database = "database_vacancie"
    connection = sqlite3.connect(name_database)

    # Создаем базу данных (если ее нет)
    createBD(connection=connection)
    # Парсим данные и превращаем в df
    parcing_df = parcing(response_from_front)
    # Сохраняем в базу данных
    save_df_to_sql(df=parcing_df, connection=connection)
    print("Завершено без ошибок")

# def get_all_data_from_database():
#     dict_keys = ['id', 'premium', 'name', 'department', 'has_test', 'response_letter_required', 'area', 'salary',
#                  'type', 'address', 'response_url', 'sort_point_distance', 'published_at', 'created_at', 'archived',
#                  'apply_alternate_url', 'show_logo_in_search', 'insider_interview', 'url', 'alternate_url', 'relations',
#                  'employer', 'snippet', 'contacts', 'schedule', 'working_days', 'working_time_intervals',
#                  'working_time_modes', 'accept_temporary', 'professional_roles', 'accept_incomplete_resumes',
#                      'experience', 'employment', 'adv_response_url', 'is_adv_vacancy', 'adv_context']
#     one_vacancy_result = {
#         'id': 0,
#         'premium': 0,
#         'name': 0,
#         'department': 0,
#         'has_test': 0,
#         'response_letter_required': 0,
#         'area': 0,
#         'salary': 0,
#         'type': 0,
#         'address': 0,
#         'response_url': 0,
#         'sort_point_distance': 0,
#         'published_at': 0,
#         'created_at': 0,
#         'archived': 0,
#         'apply_alternate_url': 0,
#         'show_logo_in_search': 0,
#         'insider_interview': 0,
#         'url': 0,
#         'alternate_url': 0,
#         'relations': 0,
#         'employer': 0,
#         'snippet': 0,
#         'contacts': 0,
#         'schedule': 0,
#         'working_days': 0,
#         'working_time_intervals': 0,
#         'working_time_modes': 0,
#         'accept_temporary': 0,
#         'professional_roles': 0,
#         'accept_incomplete_resumes': 0,
#         'experience': 0,
#         'employment': 0,
#         'adv_response_url': 0,
#         'is_adv_vacancy': 0,
#         'adv_context': 0
#     }
#
#     connection = sqlite3.connect('database_vacancie')
#     cursor = connection.cursor()
#     cursor.execute('SELECT * FROM User')
#     raws = cursor.fetchall()
#     result_list = []
#     for vacancy in raws:
#         for index in range(len(dict_keys)):
#             one_vacancy_result[dict_keys[index]] = vacancy[index]
#         result_list.append(one_vacancy_result)
#     # print(result_list)
#     connection.close()
#     return result_list

