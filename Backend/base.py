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

    update_columns = ', '.join([f"{col}=excluded.{col}" for col in name_column.split(', ')])

    connection.executemany(f'''
        INSERT INTO User ({name_column}) VALUES ({placeholders})
        ON CONFLICT(id) DO UPDATE SET {update_columns}
        ''', data_to_insert)

    connection.commit()
    print("Данные успешно вставлены или обновлены в таблице User")


def main_base_operation(response_from_front):
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


