FROM python:3.11-slim

WORKDIR /app

# Install PostgreSQL client and other dependencies
RUN apt-get update && apt-get install -y libpq-dev gcc postgresql-client && rm -rf /var/lib/apt/lists/*

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY . .

# Make wait script executable (just in case)
RUN chmod +x scripts/wait-for-it.sh

# Expose port
EXPOSE 8000

# Start server with wait script
CMD ["./scripts/wait-for-it.sh", "${POSTGRES_SERVER:-db}", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
