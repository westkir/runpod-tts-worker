#!/bin/bash

echo "--- НАЧАЛО АВТОМАТИЧЕСКОЙ НАСТРОЙКИ TTS СЕРВЕРА (v2) ---"

# Обновляем pip и ставим все зависимости
pip install --upgrade pip
pip install TTS==0.22.0 transformers==4.38.2 protobuf==3.20.3 fastapi==0.111.0 uvicorn[standard]==0.30.1 numpy==1.26.4 soundfile==0.12.1

# Создаем папку для голосов
mkdir -p /workspace/voices/

# Скачиваем тестовые голоса
echo "--- Скачиваю тестовые голоса ---"
wget -O /workspace/voices/female.wav "https://github.com/coqui-ai/TTS/raw/dev/tests/data/ljspeech/wavs/LJ001-0001.wav"

# ⭐️ ИСПРАВЛЕНИЕ: Заменена ссылка на мужской голос
wget -O /workspace/voices/male.wav "https://github.com/coqui-ai/TTS/raw/dev/TTS/tests/data/vctk/wavs/p225_003.wav"

# ⭐️ ГЛАВНОЕ ИСПРАВЛЕНИЕ: Запускаем uvicorn через 'python3 -m' для обхода проблем с PATH
echo "--- Запускаю API сервер на порту 8000 ---"
python3 -m uvicorn api.main:app --host 0.0.0.0 --port 8000
