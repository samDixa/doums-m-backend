import asyncio
import json
from httpx import AsyncClient
from app.main import app

async def fetch_articles():
    async with AsyncClient(app=app, base_url="http://test") as ac:
        response = await ac.get("/api/v1/feed/articles")
        print("Status:", response.status_code)
        print("Body:", response.json())

if __name__ == "__main__":
    asyncio.run(fetch_articles())
