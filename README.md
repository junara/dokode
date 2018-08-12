# Dokode
Simple event search site

* Environment
  * Docker
    * 18.06.0-ce-mac70 (26399)
  * Rails (If you use docker, you don't need this.)
    * 5.2
  * Ruby version (If you use docker, you don't need this.)
    * 2.5.1

  
* How to run
  * prepare environmental variables
      * see `.env_sample` 
  * initialize
      ```console
      > docker-compose build
      > docker-compose run web rails db:create
      > docker-compose run web rails db:migrate
      > docker-compose run web rails db:seed
      ```
  * run
      ```console
      > docker-compose up
      ```
* Importing event data
  * under construction