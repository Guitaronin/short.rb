# Short code generation

The method used for the short code generation consists in the translation of the record id from decimal to base 62.
With this approach the system is going to be able to generates short codes that support up to 62^n, where n is the length of the short codes generated.

[Base Translation Implementation](lib/short_code/ShortCodeUtil.rb)

Then:

| Short code length | Available codes |
|:-----------------:|----------------:|
| 2                 | 3,844           |
| 3                 | 238,328         |
| 4                 | 14,776,336      |
| 5                 | 916,132,832     |
| 6                 | 56,800,235,584  |

-----

# Intial Setup

    docker-compose build
    docker-compose up mariadb
    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml build

# To run migrations

    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml run short-app-rspec rails db:test:prepare

# To run the specs

    docker-compose -f docker-compose-test.yml run short-app-rspec

# Run the web server

    docker-compose up

# Adding a URL

    curl -X POST -d "full_url=https://google.com" http://localhost:3000/short_urls.json

# Getting the top 100

    curl localhost:3000

# Checking your short URL redirect

    curl -I localhost:3000/abc
