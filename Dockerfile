# базовый образ
FROM python:3.12-slim-bookworm

# ────────────────────────────────────────
# Системные пакеты для компиляции cffi
# ────────────────────────────────────────
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential libffi-dev && \
    rm -rf /var/lib/apt/lists/*

# ────────────────────────────────────────
# Копируем исходники и ставим сам пакет
# ────────────────────────────────────────
WORKDIR /app
COPY . .

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir .

# (опционально) короткая проверка – можно удалить после отладки
RUN which yfmcp && yfmcp --version

# ────────────────────────────────────────
# Экспонируем порт и запускаем сервер
# ────────────────────────────────────────
EXPOSE 8000
CMD ["yfmcp", "--transport", "http", "--host", "0.0.0.0", "--port", "8000"]


