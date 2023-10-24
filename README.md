# Singtel Dispatcher project

# How to build & test (tested on Mac on my local)

1. Install & Start Docker App

2. Add below mapping in host file

127.0.0.1 www-test.singtel.org

3. Clone this code and build docker with below commands -

docker stop local-httpd
docker rm local-httpd
docker rmi local-httpd
cd {this repo}
docker build --no-cache -t local-httpd .
docker run -d -p 80:80 -p 8443:8443 --name local-httpd --restart always local-httpd

4. Test home page with below URL 

http://www-test.singtel.org/content/singtel/us/en/home.html