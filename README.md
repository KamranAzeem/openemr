# openemr - Dockerized
This repository contains code (and war stories - coming up) to setup openemr correctly on a linux system, using a docker container. 

I believe this docker image for OpenEMR is much more efficient than the official openemr/openemr version available at docker hub. At least this is true for version 5.0.0 for now.

## About OpenEMR 
It is a 10+ year old software created to serve as some sort of MIS for clinics and hostpitals. It is a hotch-potch of many different pieces of software, with hot fixes made along the way. At the moment I am not sure what all parts of this software are relevant and what are simply there bloating it. I have managed to remove phpmyadmin from it - at least - in my Dockerfile. Because, we can always run phpmyadmin as a separate container. Similarly, we don't need any complicated certs, ssl or openssl setup in the software, because that is something we can manage through a separate reverse proxy such as Traefik. I am also concerned about 'php-gacl' - which seems to be the heart of this software - being 14 year old, being unmaintained, and PHP 7 thowing warnings about that. 

### Why bother?
Well, looks like this software is in use at some places, and most of the people are running it on XAMP in Windows - yuck! I thought I can help them run it on Linux, and that to be in a container form! 

### Story so far:
It has not been fun. Actually it has been horrible so far, but I am not planning to give up just yet. So lets see if we can make some improvements.
