# Ivanhoe Handyman Services Web server.

This is a complete web server with a builtin letsencrypt client that obtains certs
and serves static content.

The web server deploys a static web site and includes a single live end point /booking

The web server is deployed as a single executable that contains the static content!

The static content is packed into the web server executable using the '[dcli pack](https://dcli.onepub.dev/dcli-tools-1/dcli-pack)' command.

When you start the webserver it:
* unpacks the static content
* obtains a HTTPS certificate from LetsEncrypt (including doing auto renews)
* Listens on http and https ports
* Serves index.html and a varity of associated file times.
* Exposes a single live end point '/booking' that sends an email
   when called with valid parameters.


To build/deploy the IHAServer you need to create your static content and
create the config file under the project:

<project root>/config/config.yaml
<project root>/www_root

# Build/Deploy

## Target system
On the target system create:
`/opt/handyman`

Change the permissions so that you have access:

`sudo chown <me>:<me> /opt/handyman`

## Dev system

The build/deploy process is controlled by tool/build.yaml

Configure your build.yaml

Example
```
target_server:  handyman.com
target_directory: /opt/handyman
scp_command: scp
```


Run tool/build.dart


Once the build has run it will have copied a single exe `deploy` to the
target system in /opt/handyman.

Login to the target system and run:
```
cd /opt/handyman
sudo ./deploy
```

Update your DNS A record to point to your new system.

You are now live.


# configuration

The config.yaml file is used to configure the server.

You will need two config.yaml files, one for development and one for the release
environment:
| usage | location |
| ----- | ----- |
| release path | <project root>/release/config.yaml |
| development path | <project root>/config/config.yaml |

The following is a sample for your **production** environment
`<project root>/release/config.yaml`

```yaml
mail_app_username: bsutton@onepub.dev
gmail_app_password: XXXXXXXXXXX
path_to_static_content: /opt/handyman/www_root
lets_encrypt_live: /opt/handyman/letsencrypt/live
fqdn: ivanhoehandyman.com.au
domain_email: bsutton@onepub.dev
https_port: 443
http_port: 80
production: true
binding_address: 0.0.0.0
logger_path: /var/log/ihserver.log

```

The following is a sample for your **development** environment

`<project root>/config/config.yaml`
```yaml
gmail_app_username: bsutton@onepub.dev
gmail_app_password: XXXXXXXXXXX
path_to_static_content: /home/bsutton/git/handyman/www_root
lets_encrypt_live: /opt/ihs/letsencrypt/live
fqdn: squarephone.biz
domain_email: bsutton@onepub.dev
https_port: 10443
http_port: 1080
production: false
binding_address: 0.0.0.0
logger_path: console

```



| setting | purpose |
| ------------ | ----------------- |
| gmail_app_username | username of google workspace account. Required to using the /booking endpoint to send emails |
| gmail_app_password | password of the google workspace account. |
| path_to_static_content | location where the server will look for the sites static web content |
| lets_encrypt_live | The location to store the lets encrypt certificate. |
| fqdn | The fully qualified domain name of your web site |
|domain_email | The email address we submit to Lets Encrypt so it can send renewal notices and other critical communications. (We do however renew certificates automatically). |
|https_port | The port to listen to https requests on. |
| http_port | The port to listen to http requests on. This port MUST be open as it is required by Lets Encrypt to obtain a certificate |
| production | Controls wheter we obtain a live or staging Lets Encrypt certificate. You should start by setting this to false until you have seen IHAServer successfully obtain a certificate. You can then change the setting to 'true' and restart the IAHServer to obtain a live certificate. **See blow for additional information**|
| binding_address | The IP address that IAHServer will listen to. Using 0.0.0.0 tells the IAHServer to listen on all local addresses. If you use a specific address it must be a local addres on the server. |
| logger_path | The path to write log messages to. If you set this value to 'console' log messages are printed to the stdout (the console). This is useful in a development environment |



**READ THIS !!!**

**production setting**

The production setting in config.yaml, controls  whether we obtain a live or staging Lets Encrypt certificate. 

*This is important* as the production flag controls whether we get a staging
or live Lets Encrypt certificate. Lets Encrypt has *very strict rate limits* on
the number of certificates it will issue to a production system (5 per 48 hrs?)
so if you get something wrong (your http port isn't open) you can end up not being able to get a live
certificate for 48 hrs.


# Email
The IHServer has a '/booking' end-point which can send an email.
It does this by connection to gmail. You will need a gmail app password
for this to work.

If you are not using the /booking end point then you don't need to configure
the gmail app username/password.

Use the following link to get an app password (assumes you have a gmail workspace account.)
https://myaccount.google.com/apppasswords



# Development

Within you development environement you are likely to be behind a NAT.
To test the cert aquistion and renewal you will need to forward 
port 443 and 80 from your local router to your development box.

You will need a DNS server with a real domain name and an A record that 
points to your router's public IP.

On Linux, you will need to make the server use ports above 1024 (you can only
listen to ports below 1024 if you are root - not recommended for dev).

I suggest:
80 -> 8080
443 -> 8443

You will need to change the config/config.yaml port settings to match the port
numbers you choose.

You should generally test using a staging certificate until you are certain your configuration
and NAT are set up correctly.

## Run the service locally

To debug the IAHServer you can simply launch bin/ihserver.dart in your favourite IDE.



You can run this function example on your own machine using Docker to simulate
running in a hosted environment.

```shell
$ docker build -t email_server .
...

$ docker run -it -p 8080:8080 --name app email_server
Listening on :8080
```

You can test the server using postman
Method: post
Body: x-www-form-urlencoded
Args:
name:
email:
phone:
description:
...




If you're curious about the size of the image you created, enter:

```shell
$ docker image ls email_server
REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
email_server        latest    3f23c737877b   1 minute ago     11.6MB
```
