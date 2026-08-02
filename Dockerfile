FROM ubuntu:22.04
RUN apt-get update -y && apt-get install nginx -y 
COPY dist/* /var/www/html 
EXPOSE 80
CMD ["nginx", "-g" ,"daemon off;"] 

