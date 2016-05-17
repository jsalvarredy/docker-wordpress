# docker-wordpress

Contenedor que tiene 5.6 con el modulo de mysql pensado para wordpress.
Además tiene un servidor de correo postfix para el envio de mail.
Si se esta atras de un nginx-proxy utilizando una variable se puede ver la dirección IP origen con el modulo rpaf de apache.

## Uso
```
	docker run -d -e MAIL_DOMAIN=ejemplo.com.ar \
	-e USER_ID=`id -u`-v `pwd`:/var/www/html \
	jsalvarredy/wordpress
```

## Uso detras de un nginx-proxy
```
	docker run -d -e MAIL_DOMAIN=ejemplo.com.ar \
	-e USER_ID=`id -u`-v `pwd`:/var/www/html \
	-e IP_NGINXPROXY=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' nginxproxy` \
	jsalvarredy/wordpress
```
