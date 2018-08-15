Repostiory for Docker image built with Apache, Anaconda & Django.

## How to build

`./build_docker.sh`

## How to use

Assume we have a directory called `public` containing HTML & JS content say from an Angular app.
Assume we have a directory called `webapp` containing a Django app to serve dynamic API requests.

We can start a container called my-webapp as such:

```
docker run --rm -i -d --name my-webapp -p 8090:80 -v "$PWD":/app arunsworld/django-apache:Anaconda3-5.2.0

docker cp 000-default.conf my-webapp:/etc/apache2/sites-available/
docker exec my-webapp apachectl restart
```

## Contents of `000-default.conf`

```
<VirtualHost *:80>

	ServerAdmin arunsworld@gmail.com
	DocumentRoot /app/public

	<Directory "/app/public">
		Options Indexes FollowSymLinks
		AllowOverride All 
		Require all granted
	</Directory>

	Alias /api /app/webapp/public
	<Location /api>
		PassengerBaseURI /api
		PassengerAppRoot /app/webapp

		PassengerAppType wsgi
		PassengerStartupFile passenger_wsgi.py
	</Location>

	<Directory /app/webapp/public>
		Allow from all
		Options -MultiViews
		Require all granted
	</Directory>

	ErrorLog /dev/stderr
	CustomLog /dev/stdout combined

</VirtualHost>
```

## Stopping the container

`docker exec my-webapp stop`

## Configuring `.htaccess`

`.htaccess` can be configured to redirect Angular path URLs to the main index page. CORS headers may also be set if required.

```
RewriteEngine On
RewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} -f [OR]
RewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} -d
RewriteRule ^ - [L]
RewriteRule ^ /channel_org/index.html
Header set Access-Control-Allow-Origin "*"
```
