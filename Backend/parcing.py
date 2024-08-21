
import json

import requests
import pandas as pd


def preparate_data(df):
    def salary_prepare(df):
        default_salary = {"from": None, "to": None, 'currency': "non"}
        df['salary'] = df['salary'].apply(lambda x: default_salary if pd.isna(x) else x)
    # Обходим вопрос с типом данных в sqlite3
    salary_prepare(df)
    df['department'] = df['department'].apply(json.dumps)
    df['area'] = df['area'].apply(json.dumps)
    df['salary'] = df['salary'].apply(json.dumps)
    df['type'] = df['type'].apply(json.dumps)
    df['address'] = df['address'].apply(json.dumps)
    df['insider_interview'] = df['insider_interview'].apply(json.dumps)
    df['relations'] = df['relations'].apply(json.dumps)
    df['employer'] = df['employer'].apply(json.dumps)
    df['snippet'] = df['snippet'].apply(json.dumps)
    df['schedule'] = df['schedule'].apply(json.dumps)
    df['working_days'] = df['working_days'].apply(json.dumps)
    df['working_time_intervals'] = df['working_time_intervals'].apply(json.dumps)
    df['working_time_modes'] = df['working_time_modes'].apply(json.dumps)
    df['professional_roles'] = df['professional_roles'].apply(json.dumps)
    df['experience'] = df['experience'].apply(json.dumps)
    df['employment'] = df['employment'].apply(json.dumps)
    return df


def add_key_to_front(df,response_from_front):
    search_key = response_from_front["text"] + response_from_front["name"] + response_from_front["area"] +  response_from_front["salary"]
    df["search_key"] = search_key
    print(search_key)
    print(df)
    return df


def parcing(response_from_front):
    pages = 10
    dict_keys = ['id', 'premium', 'name', 'department', 'has_test', 'response_letter_required', 'area', 'salary',
                 'type', 'address', 'response_url', 'sort_point_distance', 'published_at', 'created_at', 'archived',
                 'apply_alternate_url', 'show_logo_in_search', 'insider_interview', 'url', 'alternate_url', 'relations',
                 'employer', 'snippet', 'contacts', 'schedule', 'working_days', 'working_time_intervals',
                 'working_time_modes', 'accept_temporary', 'professional_roles', 'accept_incomplete_resumes',
                 'experience', 'employment', 'adv_response_url', 'is_adv_vacancy', 'adv_context']
    data = []
    url = 'https://api.hh.ru/vacancies'
    df_parcing = pd.DataFrame(columns=dict_keys)
    for i in range(pages):
        par = {'text': response_from_front["text"], 'area': '113', 'per_page': '10', 'page': i}
        r = requests.get(url, params=par)
        response = r.json()
        data.append(response)
        ind = 0
        try:
            for i in range(len(data)):
                for j in range(len(data[i]['items'])):
                    df_parcing.loc[ind] = data[i]['items'][j]
                    ind += 1
        except:
            print('Error')
    df_parcing = add_key_to_front(df=df_parcing, response_from_front=response_from_front)
    return preparate_data(df_parcing)


