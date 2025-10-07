#!/bin/bash

echo "--- НАЧАЛО АВТОМАТИЧЕСКОЙ НАСТРОЙКИ TTS СЕРВЕРЕ (v5) ---"

# Создаем и активируем изолированное виртуальное окружение
python3 -m venv /workspace/tts_env
source /workspace/tts_env/bin/activate

echo "--- Устанавливаю зависимости в виртуальное окружение ---"
pip install --upgrade pip

# ⭐️ ГЛАВНОЕ ИСПРАВЛЕНИЕ: Устанавливаем PyTorch более старой, но совместимой версии (2.1.2)
# Это решает проблему с 'weights_only', так как в этой версии ее еще нет.
pip install torch==2.1.2 torchaudio==2.1.2 --index-url https://download.pytorch.org/whl/cu121

# Устанавливаем остальные пакеты
pip install TTS==0.22.0 transformers==4.38.2 protobuf==3.20.3 fastapi==0.111.0 uvicorn[standard]==0.30.1 numpy==1.26.4 soundfile==0.12.1

# Создаем папку для голосов и скачиваем тестовый голос
mkdir -p /workspace/voices/
echo "--- Скачиваю тестовый голос ---"
wget -O /workspace/voices/speaker.wav "https://github.com/coqui-ai/TTS/raw/dev/tests/data/ljspeech/wavs/LJ001-0001.wav"

# Запускаем uvicorn
echo "--- Запускаю API сервер на порту 8000 ---"
python3 -m uvicorn api.main:app --host 0.0.0.0 --port 8000
