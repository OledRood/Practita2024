import requests
def getAreaId():

    url = "https://api.hh.ru/areas"
    response = requests.get(url)

    if response.status_code == 200:
        areas = response.json()
        # Обрабатываем данные и выводим список городов
        for country in areas:
            for region in country['areas']:
                for city in region['areas']:
                    print(city['name'])
    else:
        print("Ошибка при получении данных:", response.status_code)
    return []


getAreaId()