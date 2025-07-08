# syntax=ghcr.io/docker/dockerfile:1.4
FROM python:3.12-slim-bookworm

WORKDIR /app
COPY . .

RUN pip install --no-cache-dir yfinance-mcp   # ← CLI попадает в /usr/local/bin

EXPOSE 8000
CMD ["yfmcp", "--transport", "http", "--host", "0.0.0.0", "--port", "8000"]
