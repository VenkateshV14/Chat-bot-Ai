# Stage 1: Build dependencies
FROM python:3.12-slim AS builder

WORKDIR /app
COPY requirements.txt .
RUN apt-get update && apt-get install -y gcc \
    && pip install --upgrade pip \
    && pip install --prefix=/install -r requirements.txt \
    && apt-get remove -y gcc \
    && apt-get autoremove -y \
    && apt-get clean

# Stage 2: Run
FROM python:3.12-slim

ENV PATH="/install/bin:$PATH"
WORKDIR /app

COPY --from=builder /install /install
COPY . .

CMD ["gunicorn", "chatbot_project.wsgi:application", "--bind", "0.0.0.0:8000"]
