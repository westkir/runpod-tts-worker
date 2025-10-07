#!/bin/bash

echo "--- НАЧАЛО АВТОМАТИЧЕСКОЙ НАСТРОЙКИ TTS СЕРВЕРА (v3) ---"

# ⭐️ ГЛАВНОЕ ИСПРАВЛЕНИЕ: Используем флаг --break-system-packages
# Этот флаг говорит pip: "Я знаю, что делаю, устанавливай мои пакеты, даже если это конфликтует с системными".
# Это решает проблему с 'blinker' и гарантирует установку всего списка.
pip install --break-system-packages --upgrade pip
pip install --break-system-packages TTS==0.22.0 transformers==4.38.2 protobuf==3.20.3 fastapi==0.111.0 uvicorn[standard]==0.30.1 numpy==1.26.4 soundfile==0.12.1

# Создаем папку для голосов
mkdir -p /workspace/voices/

# Скачиваем тестовые голоса
echo "--- Скачиваю тестовые голоса ---"
wget -O /workspace/voices/female.wav "https://github.com/coqui-ai/TTS/raw/dev/tests/data/ljspeech/wavs/LJ001-0001.wav"

# ⭐️ ИСПРАВЛЕНИЕ: Новая рабочая ссылка на мужской голос
wget -O /workspace/voices/male.wav "https://huggingface.co/datasets/coqui/vctk/resolve/main/wav48_silence_trimmed/p225/p225_003_mic1.flac"


# Запускаем uvicorn через 'python3 -m' для обхода проблем с PATH
echo "--- Запускаю API сервер на порту 8000 ---"
python3 -m uvicorn api.main:app --host 0.0.0.0 --port 8000
