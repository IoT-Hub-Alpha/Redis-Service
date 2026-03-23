Redis Microservice

Based on Debian linux

How to start locally
```bash
docker build -t redis-service .

docker run -d \
  --name redis-dev \
  -p 6379:6379 \
  -e REDIS_PASSWORD=your_password \
  -e REDIS_MAXMEMORY=512mb \
  redis-service
```
