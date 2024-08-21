from flask import Flask, jsonify, request
from flask_cors import CORS

from base import main_base_operation
from data_to_front import get_all_data_from_database
from send_all_data import send_all_data

app = Flask(__name__)
CORS(app)

# TODO отправка всей ранее полученных результатов
@app.route('/allData', methods=['POST'])
def send_all_previously_received_resumes():
    return jsonify(send_all_data())
    if request.method == 'OPTIONS':
        return jsonify({'message': 'Good'})



@app.route('/parcingData', methods=['POST'])
#TODO Отправка искомых резюме по фильтрам и тексту поиска
def send_searched_and_filtered_data():
    # Получаем данные из POST-запроса
    data = request.json
    # искомый текст по всему резюме
    text = data.get('text')
    # заголовок (пустой - игнорируется)
    name = data.get('name')
    # Регион (пустой - игнорируется)
    area = data.get('area')
    # зп формат:"от,до" (пустой - игнорируется)
    salary = data.get('salary')

    response = {
        "text": text,
        "name": name,
        "area": area,
        "salary": salary.replace(' ', '')
    }
    print(response)
    # main_base_operation(response_from_front=response)
    print("good")
    result = get_all_data_from_database(response_from_front=response)
    print(response)

    return result
    # Используется для корректной связи с браузером и фреймворком
    if request.method == 'OPTIONS':
        return jsonify({'message': 'Good'})





if __name__ == '__main__':
    app.run(debug=True)
# from flask import Flask, jsonify, request
# from flask_cors import CORS
# from base import main_base_operation
# from data_to_front import get_all_data_from_database
# from send_all_data import send_all_data
# import sqlite3
# import os
#
# app = Flask(__name__)
# CORS(app)
#
# # Получение пути к базе данных из переменной окружения или использование значения по умолчанию
# DATABASE_URL = os.getenv('DATABASE_URL', 'sqlite:///app/database_vacancie.db')
#
# def get_db_connection():
#     conn = sqlite3.connect(DATABASE_URL.split('///')[-1])
#     conn.row_factory = sqlite3.Row
#     return conn
#
# @app.route('/check_true', methods=['POST'])
# def check_true():
#     data = request.json
#     if not data:
#         return jsonify({'error': 'No data provided'}), 400
#
#     if data.get('value') == "true":
#         return jsonify(send_all_data())
#     else:
#         return jsonify({'error': 'Invalid input, expected "true"'}), 400
#
# @app.route('/api/data', methods=['POST'])
# def receive_data():
#     data = request.json
#     if not data:
#         return jsonify({'error': 'No data provided'}), 400
#
#     text = data.get('text')
#     name = data.get('name')
#     area = data.get('area')
#     salary = data.get('salary')
#
#     if not all([text, name, area, salary]):
#         return jsonify({'error': 'Missing required fields'}), 400
#
#     response = {
#         "text": text,
#         "name": name,
#         "area": area,
#         "salary": salary
#     }
#     print(response)
#     main_base_operation(response_from_front=response)
#     print("good")
#     result = get_all_data_from_database(response_from_front=response)
#     print(response)
#
#     return jsonify(result)
#
# if __name__ == '__main__':
#     app.run(host="0.0.0.0", port=5000, debug=True)
