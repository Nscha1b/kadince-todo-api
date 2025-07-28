# README

Hi! This is the Ruby on Rails api that powers https://kadince-todo-frontend.onrender.com/. This is a sample Todo application to show off some basic crud, and filtering skills. The base ask was....

> 1 week to complete the assignment while meeting at least the minimum functionality requirements:
> 
> *	View a list of to-do items with the ability to filter the list by
> pending, complete, and all to-dos.
> 
> *	Create a new to-do item
> *	Edit a to-do item
> *	Delete a to-do item
> *	Complete a to-do item

## Frontend Repository

The frontend github can be found here: https://github.com/Nscha1b/kadince-todo-frontend


## Starting the project with Containers

Make sure you have docker installed. The simplest way is:
https://www.docker.com/products/docker-desktop/

**1. Start the Services:**
```
docker-compose  up  --build
```
**2. Access your API at:**  http://localhost:3000
**3. Run Rails Commands:** 
```
docker-compose exec web ./bin/rails console
```
**4. Stopping the  service:** 
```
docker-compose  down
```