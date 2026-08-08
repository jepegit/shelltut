# Tiny image for shelltut Docker build/run drills.
FROM python:3.12-alpine

WORKDIR /app
COPY index.html server.py ./

EXPOSE 8080
CMD ["python", "server.py"]
