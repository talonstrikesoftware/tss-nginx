Solution: tss-nginx

Description: A basic nginx container with the following charateristics:
- served content is mounted into the container as a volume at /usr/share/nginx/html. 
- It uses TLS and redirects all calls to HTTP to HTTPS.

## Installation/Configuration 

### Create a new directory for the project

### Run the project-setup.sh script
- As the `mark` user
```
./project-setup.sh {path to new directory}
```

### Starting a New Project

### Using an Existing Project

### Post Install Steps

#### Configure '.env' file
* set the name of the project's directory.

TODO:
- 
- compare with deployed setup
- need copy of update_certs.sh script

To use:

- Copy these files to a new directory
- Place website content in a subdirectory
- Copy env.tmp to .env and modify accordingly 
	- this holds substitution variables for the docker-compose.yml file
- Update ./nginx/web.env file (this holds environment variables for the container)
- Update ./nginx/nginx.conf file (see the Udemy course) The server_name directive is the most important part here
	- This is best edited in Visual Studio Code `code {filename}`
- run `docker-compose build`
- If you do not have a public/private key pair you need to generate one now.  See the Notes section on how to do this.
- If you do have public/private keys, create a 'ssl' directory in your site's directory and place them in this sub-directory.
- Generate the dhparam.pem file (if needed).  See Notes section.  
- run `docker-compose up`

Service name is: web

You can attach to it with:

```bash
	docker-compose exec web /bin/sh
``` 

Notes:

- The nginx logs can be found in the subdirectory 'nginx_logs' of the project dir
- The ssl certs and dhparams.pem file can be found in the subdirectory 'ssl' of the project dir


###How do I create my SSL Certificates

This image builds with openssl installed.  To generate your self-signed certificates follow these steps:

- Start the container interactively with this command:

```bash
	docker run -i -t --rm -v $PWD/{project_dir}/ssl:/etc/nginx/ssl {image name} bash
```

- Execute the following command to build your self-signed cert
	- You need to be root to run this command

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx-selfsigned.key -out /etc/nginx/ssl/nginx-selfsigned.crt
```
When you are asked for the FQDN use either 127.0.0.1 or the server's ip address

- Follow the steps on how to create the dhparam.pem file below
- Uncomment the lines in ./nginx/nginx.conf you commented out 

Note: This information is sourced from [here](https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-16-04)

###How do I create the dhparam.pem file
To generate your dhparm.pem file start the image and connect to it in a terminal.  Note: For these steps to work you should have launched the image interactively to a bash shell like was done when creating the ssh keys. Then follow these steps:
	- You need to be root to run this command

```bash
openssl dhparam -out /etc/nginx/ssl/dhparm.pem 2048
```

###Where can I get more information about this image

This image was based off of the nginx_basic image.  There is more information on why I did what I did in it's README.md file.

###How did you know to do all this?

I got a lot of the information from the Udemy course.  Specifically Chapter 26. HTTPS(SSL)

###Why are you not using systemd like in the Udemy course?

I was not sure how to start the service in the container with the CMD directive.  A Google search led me to this page: https://developers.redhat.com/blog/2014/05/05/running-systemd-within-docker-container/ which was for RedHat systems, but I figured I could adapt it.  Given the complexity the writter ran into I shelved that idea for a later date.  My thoughts are if I get into having to build my own install of nginx to support some dynamic modules, for example, I should come back and revisit this but for now I decided to see how far I could get with the standard nginx commands.  I have listed them here (for reference):

```bash
root@8a0f952aeec6:/# nginx -h
nginx version: nginx/1.13.12
Usage: nginx [-?hvVtTq] [-s signal] [-c filename] [-p prefix] [-g directives]

Options:
  -?,-h         : this help
  -v            : show version and exit
  -V            : show version and configure options then exit
  -t            : test configuration and exit
  -T            : test configuration, dump it and exit
  -q            : suppress non-error messages during configuration testing
  -s signal     : send signal to a master process: stop, quit, reopen, reload
  -p prefix     : set prefix path (default: /etc/nginx/)
  -c filename   : set configuration file (default: /etc/nginx/nginx.conf)
  -g directives : set global directives out of configuration file
```

To reload the nginx.conf file you would do this:

```bash
nginx -s reopen
```
What I lose by doing it this way is I can't get status information that systemd would give.
####Things to work on
* The image does not mount the nginx.conf file as rw so if you make a change on the host you'll need to restart the container.


###The Docker Hub comments for the nginx image talk about using a site.template file to pass in variables.  Why aren't you using this?

I'm not doing that because the example rewrites the template file into a nginx conf override file for a site, and then starts the nginx server.  My intent is to keep this whole thing simple so (right now) I intend to make all the changes to the main nginx.conf file directly.  If at some point I want to host multiple sites from the same container, I suspect I will need to go down the template route.
