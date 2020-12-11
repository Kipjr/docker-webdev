*Docker container for Website developement*


# Contents

- [Changelog](#changelog)
- [Purpose](#purpose)
- [Installation](#installation)
  - [Dependencies](#dependencies)
  - [Steps](#steps)
- [Dir & Files](#dir--files)
  - [Before initialize](#before-initialize)
  - [After initialization](#after-initialization)
- [Advanced](#advanced)
  - [Alternative use for this repo](#alternative-use-for-this-repo)
  - [Git commit / push in Laravel App](#git-commit)
- [Troubleshoot](#troubleshoot)

# Changelog
- Clone of docker-laravel
- Removed laravel things

# Purpose
- Easy spawn of web dev environment
- No 'installation' on host device

# Installation 

## Dependencies

## Steps

1. ```git clone https://github.com/kipjr/docker-webdev``` 
2. Wait x minutes , grab some coffee
3. Access your server files on ./www (instant-edit using bind mount)
4. Visit on http://{docker-host}:1234

![alt text](https://user-images.githubusercontent.com/12066560/89425998-f1ea6700-d739-11ea-8058-f7dcaeb96cf4.png)

# Dir & Files
## Before initialize
- Dockerfile
- docker-compose.yml
- README.md

## After initialization
- above mentioned files
- ./etc
  -  config of php
  -  config of mysql
  -  config of apache2
- ./www


# Troubleshoot
- App wont start.
  - Check error in build and report back with issue


- How to start over?
  - Remove ./laravel-app 
  - Remove ./etc
  - Remove all older images and containers
    - `docker image prune`
    - `docker container prune`
    - `docker image rm {REPOSITORY_IMAGE_NAME ie. 'docker-mensa_app'}`
