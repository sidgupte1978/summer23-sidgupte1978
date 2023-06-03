# --- Stage 1: Install Poetry & Configue -----
FROM python:3.11-slim as venv

# Security Updates
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install curl -y \
    && rm -rf /var/lib/apt/lists/*

# Download and install poetry. Update Path
ENV POETRY_VERSION=1.5.0
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH "/root/.local/bin:$PATH"

# Copy pyproject.toml and poetry.lock for installing dependencies
WORKDIR /app
COPY pyproject.toml poetry.lock ./ 
RUN python3 -m venv --copies /app/venv

# Install poetry dependencies into the virtual environment
RUN . /app/venv/bin/activate && poetry install --only main

# --- Stage 2 -----
FROM python:3.11-slim as prod

# Security Updates
RUN apt-get update \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*

# Set working dir
WORKDIR /app

# Copy the virtual environment from venv to prod
COPY --from=venv /app /app
ENV PATH /app/venv/bin:$PATH

# Add code
COPY ./src /app/src

# Exposure port
EXPOSE 8000

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
