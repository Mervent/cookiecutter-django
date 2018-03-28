#!/usr/bin/env bash

echo build starting nginx config


echo replacing ___my.example.com___/$MY_DOMAIN_NAME

# Put your domain name into the nginx reverse proxy config.
sed -i "s/___my.example.com___/$MY_DOMAIN_NAME/g" /etc/nginx/nginx.conf

cat /etc/nginx/nginx.conf
echo .
echo Firing up nginx in the background.
nginx

# # Check user has specified domain name
if [ -z "$MY_DOMAIN_NAME" ]; then
    echo "Need to set MY_DOMAIN_NAME (to a letsencrypt-registered name)."
    exit 1
fi

# This bit waits until the letsencrypt container has done its thing.
# We see the changes here bceause there's a docker volume mapped.
echo Waiting for folder /etc/letsencrypt/live/$MY_DOMAIN_NAME to exist
while [ ! -d /etc/letsencrypt/live/$MY_DOMAIN_NAME ] ;
do
    sleep 2
done

while [ ! -f /etc/letsencrypt/live/$MY_DOMAIN_NAME/fullchain.pem ] ;
do
	echo Waiting for file fullchain.pem to exist
    sleep 2
done

while [ ! -f /etc/letsencrypt/live/$MY_DOMAIN_NAME/privkey.pem ] ;
do
	echo Waiting for file privkey.pem to exist
    sleep 2
done

echo replacing ___my.example.com___/$MY_DOMAIN_NAME


# Put your domain name into the nginx reverse proxy config.
sed -i "s/___my.example.com___/$MY_DOMAIN_NAME/g" /etc/nginx/nginx-secure.conf

# Add the system's nameserver (the docker network dns) so we can resolve container names in nginx
NAMESERVER=`cat /etc/resolv.conf | grep "nameserver" | awk '{print $2}' | tr '\n' ' '`
echo replacing ___NAMESERVER___/$NAMESERVER
sed -i "s/___NAMESERVER___/$NAMESERVER/g" /etc/nginx/nginx-secure.conf


#go!
nginx -s stop
cp /etc/nginx/nginx-secure.conf /etc/nginx/nginx.conf

echo sleep 3
sleep 3
echo starting nginx
nginx -g 'daemon off;'
