from flask import Flask, jsonify, request
from flask_cors import CORS

from base import main_base_operation
from data_to_front import get_all_data_from_database

app = Flask(__name__)
CORS(app)

@app.route('/text/', methods=['POST', 'OPTIONS'])
def handle_text():
    if request.method == 'POST':
        data = request.json
        main_base_operation(data['text'])
        print("good")
        return jsonify(get_all_data_from_database(text=data['text']))


    # Используется для корректной связи с браузером и фреймворком
    elif request.method == 'OPTIONS':
        return jsonify({'message': 'Good'})


@app.route('/api/data', methods=['POST'])
def receive_data():
    # Получаем данные из POST-запроса
    data = request.json
    text = data.get('text')
    name = data.get('name')
    area = data.get('area')
    salary = data.get('salary')

    # Проверяем, что все параметры присутствуют
    # if not all([text, name, region, salary]):
    #     return jsonify({"error": "Missing data"}), 400


    response = {
        "text": text,
        "name": name,
        "area": area,
        "salary": salary
    }
    # main_base_operation(text=response['text'], name=response['name'], area=response['region'], salary=response['salary'], response_from_front=response)
    print("good")
    return jsonify(get_all_data_from_database(response_from_front=response))
    # Используется для корректной связи с браузером и фреймворком
    if request.method == 'OPTIONS':
        return jsonify({'message': 'Good'})





if __name__ == '__main__':
    app.run(debug=True)