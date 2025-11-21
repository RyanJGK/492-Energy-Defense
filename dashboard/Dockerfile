FROM python:3.11-slim

WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY . /app/dashboard/

# Copy backend models (needed for database access)
# This will be mounted via docker-compose volume

EXPOSE 3000

CMD ["uvicorn", "dashboard.main:app", "--host", "0.0.0.0", "--port", "3000"]
