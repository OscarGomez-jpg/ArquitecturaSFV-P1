if command -v docker >/dev/null 2>"$1"; then
  echo "Docker is installed"
else
  echo "You need to install Docker first"
fi

sudo docker build -t taller_docker .
sudo docker run -p 8080:8080 -e PORT=8080 -e NODE_ENV=production -it --rm taller_docker

if curl -s http://localhost:8080/health | grep -q "Ok"; then
  echo "The service is running correctly"
else
  echo "The service is not running correctly"
fi
