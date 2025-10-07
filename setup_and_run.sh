#!/bin/bash

echo "--- НАЧАЛО АВТОМАТИЧЕСКОЙ НАСТРОЙКИ TTS СЕРВЕРА ---"

# Обновляем pip и ставим все зависимости
pip install --upgrade pip
pip install TTS==0.22.0 transformers==4.38.2 protobuf==3.20.3 fastapi==0.111.0 uvicorn[standard]==0.30.1 numpy==1.26.4 soundfile==0.12.1

# Создаем папку для голосов
mkdir -p /workspace/voices/

# Скачиваем тестовые голоса (добавь сюда свои)
echo "--- Скачиваю тестовые голоса ---"
wget -O /workspace/voices/female.wav "https://github.com/coqui-ai/TTS/raw/dev/tests/data/ljspeech/wavs/LJ001-0001.wav"
wget -O /workspace/voices/male.wav "https://github.com/coqui-ai/TTS/raw/dev/TTS/tests/data/mas/mas_1.wav"

# Запускаем API сервер
echo "--- Запускаю API сервер на порту 8000 ---"
uvicorn api.main:app --host 0.0.0.0 --port 8000
