# README

Demo version of the crypto exchange.
Using this application, it is possible to create a bitcoin address on the `testnet` network and use this address to exchange from `USDT` to `BTC`, calculating the commission of the exchanger itself and taking into account the commission of miners (fixed). The current exchange rate is obtained from the public API (according to the schedule and also manually). The balance of a bitcoin address is updated automatically, as well as with each exchange operation.

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

### Docker build, up, down

* Build or rebuild services

      docker compose build

* Create DB and run migration

      docker compose run --rm web rails db:create
      docker compose run --rm web rails db:migrate

* Create and start containers

      docker compose up -d

* Stop and remove containers, networks

      docker compose down

### Credentials setup

* Generate Active Record encryption keys

      bin/rails db:encryption:init

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
