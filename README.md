# README

Demo version of the crypto exchange.
Using this application, it is possible to create a bitcoin address on the `testnet` network and use this address to exchange from `USDT` to `BTC`, calculating the commission of the exchanger itself and taking into account the commission of miners (fixed). The current exchange rate is obtained from the `public API` (according to the schedule and also manually). The balance of bitcoin address is updated automatically, as well as with each exchange operation and also manually.

The application uses encryption of sensitive information at the application level. It works by declaring which attributes are to be encrypted, and seamlessly encrypts and decrypts them as needed. The encryption layer is between the database and the application. The application will have access to unencrypted data, but the database will store it encrypted.

## Ruby and Ruby on Rails version

* Ruby 3.1.2
* Rails 7.0.4

## Frontend

* Hotwire Turbo
* Hotwire Stimulus
* Bootstrap

## Local deployment instructions

### Install Docker (Ubuntu)

* Set up the repository

      sudo apt-get update
      sudo apt-get install ca-certificates curl gnupg lsb-release

* Add Docker’s official GPG key:

      sudo mkdir -p /etc/apt/keyrings
      curl -fsSL <https://download.docker.com/linux/ubuntu/gpg> | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
      echo \ "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] <https://download.docker.com/linux/ubuntu> \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

* Install Docker Engine

      sudo apt-get update
      sudo chmod a+r /etc/apt/keyrings/docker.gpg
      sudo apt-get update
      sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
      sudo docker run hello-world

### Installing required Javascript packages

* Dependencies from package.json

      yarn install

### Credentials setup

* Generate Active Record encryption keys

      rails db:encryption:init

* Add keys to your credentials

      EDITOR=nano rails credentials:edit

      secret_key_base:

      active_record_encryption:
        primary_key:
        deterministic_key:
        key_derivation_salt:

      http_auth:
        name:
        password:

### Docker build, up, down

* Build services and test start containers

      docker compose build
      docker compose up -d
      docker compose down

* Create DB and run migration and seeds

      docker compose run --rm web rails db:create
      docker compose run --rm web rails db:migrate
      docker compose run --rm web rails db:seed

* Stop and remove containers, networks before clean start

      docker compose down

* Create and start containers

      docker compose up -d

* To terminate the application correctly

      docker compose down
