### Используем официальный Python образ в качестве базового
#FROM python:3.9-slim
#
## Устанавливаем рабочую директорию
#WORKDIR /app
#
## Копируем файлы в контейнер
#COPY app /app
#COPY data /data
#
## Копируем и устанавливаем зависимости
#COPY requirements.txt .
#
#RUN pip install --no-cache-dir -r requirements.txt
#
## Устанавливаем команду по умолчанию
#CMD ["python", "server_api.py"]


FROM python:3.9-slim

WORKDIR /app

COPY app/ /app
COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade pip
RUN pip install -r requirements.txt

EXPOSE 5000

CMD ["python", "server_api.py"]
