docker build -t exo4 -f 4-dev-app.dockerfile .
docker run exo4 -d -p 3000:3000