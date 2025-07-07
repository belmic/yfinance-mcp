# syntax=docker/dockerfile:1.4       # ← Важно! включает BuildKit 1.4+

######################################################################
# СТАДИЯ 1: собираем зависимости uv во внутреннем слое
######################################################################
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim AS uv

WORKDIR /app

ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy

# -- добавили id=uv-cache
RUN --mount=type=cache,id=uv-cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock,readonly \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml,readonly \
    uv sync --frozen --no-install-project --no-dev --no-editable

ADD . /app

# -- добавили id=uv-cache
RUN --mount=type=cache,id=uv-cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev --no-editable

######################################################################
# СТАДИЯ 2: финальный, «тонкий» образ
######################################################################
FROM python:3.12-slim-bookworm

WORKDIR /app

# копируем готовое venv из первой стадии
COPY --from=uv --chown=app:app /app/.venv /app/.venv

ENV PATH="/app/.venv/bin:$PATH"

# ⇣⇣ если Railway UI уже переопределяет Start Command,
# этот ENTRYPOINT останется «страховкой», ничего не ломает
ENTRYPOINT ["yfmcp"]


COPY --from=uv --chown=app:app /app/.venv /app/.venv

ENV PATH="/app/.venv/bin:$PATH"

ENTRYPOINT ["yfmcp"]
