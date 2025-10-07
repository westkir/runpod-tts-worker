#!/bin/bash

echo "--- НАЧАЛО АВТОМАТИЧЕСКОЙ НАСТРОЙКИ TTS СЕРВЕРА (v4) ---"

# ⭐️ ГЛАВНОЕ ИСПРАВЛЕНИЕ: Создаем и активируем изолированное виртуальное окружение
# Это защитит нас от всех системных конфликтов.
python3 -m venv /workspace/tts_env
source /workspace/tts_env/bin/activate

# Теперь все 'pip' команды будут работать внутри 'tts_env'
echo "--- Устанавливаю зависимости в виртуальное окружение ---"
pip install --upgrade pip
pip install TTS==0.22.0 transformers==4.38.2 protobuf==3.20.3 fastapi==0.111.0 uvicorn[standard]==0.30.1 numpy==1.26.4 soundfile==0.12.1

# Создаем папку для голосов
mkdir -p /workspace/voices/

# Скачиваем тестовые голоса
echo "--- Скачиваю тестовые голоса ---"
# ⭐️ ИСПРАВЛЕНИЕ: Используем только одну, 100% рабочую ссылку
wget -O /workspace/voices/speaker.wav "https://github.com/coqui-ai/TTS/raw/dev/tests/data/ljspeech/wavs/LJ001-0001.wav"

# Запускаем uvicorn из виртуального окружения
echo "--- Запускаю API сервер на порту 8000 ---"
python3 -m uvicorn api.main:app --host 0.0.0.0 --port 8000
