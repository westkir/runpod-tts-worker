# api/main.py
import os
import torch
from fastapi import FastAPI, HTTPException
from fastapi.responses import Response
from pydantic import BaseModel, Field
from TTS.api import TTS
import numpy as np
import soundfile as sf
import io

# --- НАСТРОЙКА ---
VOICES_DIR = "/workspace/voices/"
os.makedirs(VOICES_DIR, exist_ok=True)

device = "cuda" if torch.cuda.is_available() else "cpu"
print(f"🚀 Используется устройство: {device}")

print(">>> Загрузка модели Coqui XTTS-v2...")

# ⭐️ ИСПРАВЛЕНИЕ: Убираем 'model_args', так как он больше не нужен со старой версией PyTorch
tts = TTS("tts_models/multilingual/multi-dataset/xtts_v2").to(device)

print(">>> Модель успешно загружена.")

# --- МОДЕЛЬ ЗАПРОСА ---
class TTSRequest(BaseModel):
    text: str = Field(...)
    speaker_wav: str = Field(...)
    language: str = Field("ru")

# --- API ---
app = FastAPI(title="Direct Install TTS API", version="1.2.0")

@app.post("/tts_to_audio/", responses={200: {"content": {"audio/wav": {}}}})
def tts_to_audio(request: TTSRequest):
    speaker_wav_path = os.path.join(VOICES_DIR, f"{request.speaker_wav}.wav")

    if not os.path.exists(speaker_wav_path):
        raise HTTPException(status_code=404, detail=f"Голос '{request.speaker_wav}' не найден.")

    try:
        wav_list = tts.tts(text=request.text, speaker_wav=speaker_wav_path, language=request.language)
        wav_numpy_float = np.array(wav_list, dtype=np.float32)
        wav_numpy_int16 = (wav_numpy_float * 32767).astype(np.int16)
        
        buffer = io.BytesIO()
        sf.write(buffer, wav_numpy_int16, tts.synthesizer.output_sample_rate, format='WAV')
        wav_bytes = buffer.getvalue()

        return Response(content=wav_bytes, media_type="audio/wav")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/voices")
def list_voices():
    voices = [f.split('.')[0] for f in os.listdir(VOICES_DIR) if f.endswith('.wav') or f.endswith('.flac')]
    return {"available_voices": voices}
