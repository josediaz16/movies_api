# Movies api

This is a very small example of an API built using the following tools and considerations:
  - Docker
  - Sinatra
  - Test driven development using RSpec
  - RESTFUL concepts
  - Sequel
  - Dry-Transaction / Dry-Validation

# Dependencies

  This project was built using the following versions:
    - Docker version 18.09.1
    - docker-compose version 1.23.2

# Configuration

  As initial step run the following command to setup the database:

  `sudo docker-compose run web rake db:create db:migrate`

  Run `sudo docker-compose run web rake db:seed` to initialize the database with a couple of records.

# Tests

  To run the tests run `sudo docker-compose run web bundle exec rspec spec/`

# API Documentation

* POST /movies

  Params
  
  <table>
  <tr>
    <th>Param name</th>
    <th>Required</th>
    <th>Type</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>name</td>
    <td>true</td>
    <td>String</td>
    <td>Name of the movie</td>
  </tr>
  <tr>
    <td>description</td>
    <td>true</td>
    <td>String</td>
    <td>Short preview text about the movie</td>
  </tr>
  <tr>
    <td>image_url</td>
    <td>true</td>
    <td>String</td>
    <td>an URL link to the image movie preview</td>
  </tr>
  <tr>
    <td>show_days</td>
    <td>true</td>
    <td>Array</td>
    <td>a list with the days the movie is available from 1 to 7</td>
  </tr>
</table>

  Example:
  
  ```
  curl -XPOST http://localhost:5000/movies -H 'Content-Type: application/json' -d '
    {
    "name": "Back to the future",
    "description": "Marty Mcfly is sent back to 1955 and he has to save Doc Emmet Brown",
    "image_url": "https://myimages.com/back_to_the_future",
    "show_days": [1, 2, 5]
    }
  '
  ```

  Response:
  ```
    {
      "id":1,
      "name":"Back to the future",
      "description":"Marty Mcfly is sent back to 1955 and he has to save Doc Emmet Brown",
      "image_url":"https://myimages.com/back_to_the_future",
      "created_at":"2019-09-11 17:14:35 +0000",
      "updated_at":"2019-09-11 17:14:35 +0000"
    }
  ```

  * GET /movies

  Example:

  `curl http://localhost:5000/movies?show_day=1`

  Response:
  
  ```
  [
    {
        "description": "Marty Mcfly is sent back to 1955 and he has to save Doc Emmet Brown",
        "id": 1,
        "image_url": "https://myimages.com/back_to_the_future"
    }
  ]
  ```
