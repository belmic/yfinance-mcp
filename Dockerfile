FROM python:3.12-slim-bookworm

# build deps для cffi/curl_cffi
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential libffi-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

RUN pip install --no-cache-dir yfinance-mcp

# --- проверка, можно удалить после debug ---
RUN which yfmcp && yfmcp --version
# -------------------------------------------

EXPOSE 8000
CMD ["yfmcp", "--transport", "http", "--host", "0.0.0.0", "--port", "8000"]

