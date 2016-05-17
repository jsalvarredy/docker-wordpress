#!/bin/bash
set -e

/etc/init.d/rsyslog start

if [ ! -z "$MAIL_DOMAIN" ]; then
    postconf -e myhostname=$MAIL_DOMAIN
else
    postconf -e myhostname=example.com
fi

postconf -e mydestination=localhost

/etc/init.d/postfix start

source /etc/apache2/envvars

# Map www-data uid to specified USER_ID. If no specified, uid 1000 will be used
if [ ! -z "$USER_ID" ]; then
  usermod -u $USER_ID $APACHE_RUN_USER
else
  usermod -u 1000 $APACHE_RUN_USER
fi

printf "date.timezone=America/Argentina/Buenos_Aires\n" >> /usr/local/etc/php/php.ini
#Se pasa el access.log a archivo
sed -i 's|/proc/self/fd/1|/var/log/apache2/access.log|' /etc/apache2/apache2.conf
#Se pasa el error.log a stdout, para que salga en el log de docker
sed -i 's|/proc/self/fd/2|/proc/self/fd/1|' /etc/apache2/apache2.conf

#Para que se vean en los logs la IP origen
if [ ! -z "$IP_NGINXPROXY" ]; then
	sed -i "s/127.0.0.1/$IP_NGINXPROXY/g" /etc/apache2/mods-available/rpaf.conf
else
	sed -i "s/127.0.0.1/172.17.0.1/g" /etc/apache2/mods-available/rpaf.conf
fi

apache2-foreground


