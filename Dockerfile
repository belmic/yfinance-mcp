# syntax=docker/dockerfile:1.4

########### STAGE 1: build with uv ###########
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim AS build
WORKDIR /app

# если они у вас есть – скопировать файлы зависимостей
COPY pyproject.toml uv.lock ./

# === УБРАЛИ cache-mount ===
RUN uv sync --frozen --no-install-project --no-dev --no-editable

# код приложения
ADD . /app
RUN uv sync --frozen --no-dev --no-editable

########### STAGE 2: final image ###########
FROM python:3.12-slim-bookworm

# создаём системного пользователя, чтобы сработал --chown
RUN adduser --disabled-login --gecos "" app

WORKDIR /app
COPY --from=build --chown=app:app /app/.venv /app/.venv
COPY --from=build --chown=app:app /app /app

ENV PATH="/app/.venv/bin:$PATH"

ENTRYPOINT ["yfmcp"]


COPY --from=uv --chown=app:app /app/.venv /app/.venv

ENV PATH="/app/.venv/bin:$PATH"

ENTRYPOINT ["yfmcp"]
