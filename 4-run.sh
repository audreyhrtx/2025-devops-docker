set -e 

docker build -t exo4 -f 4-dev-app.dockerfile ./broken-app
docker run -d -p 3000:3000 exo4