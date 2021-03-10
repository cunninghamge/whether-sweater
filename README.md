# Whether Sweater

## Table of Contents

-   [Description](#description)
-   [Learning Goals](#learning-goals)
-   [API Contract](#api-contract)
-   [Technologies Used](#technologies-used)
-   [Local Setup](#local-setup)


## Description
Weather Sweater is a back-end for an application to be used to plan road trips. Users can see weather for a specified location, and can enter a start and end location to see the travel time as well as the destination's forecasted weather at arrival time. This app exposes five endpoints to be consumed by the front-end application. The responses for all endpoints adhere to the [JSON:API v1.0 specifications](https://jsonapi.org/).

## Learning Goals

- [x] Expose an API that aggregates data from multiple external APIs
- [x] Expose an API that requires an authentication token
- [x] Expose an API for CRUD functionality
- [x] Determine completion criteria based on the needs of other developers
- [x] Research, select, and consume an API based on your needs as a developer

## API Contract
- `POST /api/v1/users`: creates/registers a new user and generates a unique api key

  - required information (*must be sent as JSON in the body of the request*): <br>`email, password, password_confirmation`
  - example request: http://localhost:3000/api/v1/users
  ```
  {
      "email": "user@example.com",
      "password": "password123",
      "password_confirmation": "password123"
  }
  ```
  - example response:
  ```
  {
      "data": {
        "id": "6",
        "type": "user",
        "attributes": {
          "email": "user@example.com",
          "api_key": "UAUMJpJ9eEu1A4dr7ZWrMjij"
        }
      }
  }
  ```

___
- `POST /api/v1/sessions`: logs in an existing user and returns the user's unique api key
  - required information (*must be sent as JSON in the body of the request*): <br>`email, password`
  - example request: http://localhost:3000/api/v1/sessions
  ```
  {
      "email": "user@example.com",
      "password": "password123"
  }
  ```
  - example response:
  ```
  {
      "data": {
        "id": "6",
        "type": "user",
        "attributes": {
          "email": "user@example.com",
          "api_key": "UAUMJpJ9eEu1A4dr7ZWrMjij"
        }
      }
  }
  ```

  ___
- `GET /api/v1/forecast`: gets a detailed forecast for the specified location, including current weather, hourly forecasts for the next 8 hours, and daily forecasts for the next 5 days
  - required parameters: `location`
  - example request: http://localhost:3000/api/v1/forecast?location=asheville,nc
  - example response:
  ```
  {
      "data": {
        "id": null,
        "type": "forecast",
        "attributes": {
          "current_weather": {
            "datetime": "2021-03-09 20:54:43 -0500",
            "sunrise": "2021-03-09 06:49:05 -0500",
            "sunset": "2021-03-09 18:32:27 -0500",
            "temperature": 48.6,
            "feels_like": 42.75,
            "humidity": 28,
            "uvi": 0,
            "visibility": 10000,
            "conditions": "clear sky",
            "icon": "01n"
          },
          "hourly_weather": [
            {
              "time": "21:00:00",
              "temperature": 46.27,
              "conditions": "few clouds",
              "icon": "02n"
            },
            {...},
            {...},
            {...},
            {...},
            {...},
            {...},
            {...}
          ],
          "daily_weather": [
            {
              "date": "2021-03-10",
              "sunrise": "2021-03-10 06:47:42 -0500",
              "sunset": "2021-03-10 18:33:19 -0500",
              "min_temp": 38.55,
              "max_temp": 64.78,
              "conditions": "scattered clouds",
              "icon": "03d"
            },
            {...},
            {...},
            {...},
            {...}
          ]
        }
      }
    }
  ```

  ___
- `GET /api/v1/background`: fetches a background image for a front-end page displaying details about a city

  - required parameters: `location`
  - example request: http://localhost:3000/api/v1/background?location=asheville,nc
  - example response:
  ```
  {
      "data": {
        "id": null,
        "type": "image",
        "attributes": {
          "location": "asheville,nc",
          "image_url": "https://images.unsplash.com/photo-1550583096-ddf7d9332e42?ixid=MnwyMTI3ODZ8MHwxfHNlYXJjaHwxfHxhc2hldmlsbGUsbmN8ZW58MHx8fHwxNjE1MzQxODA5&ixlib=rb-1.2.1",
          "credit": {
            "source": "Unsplash",
            "source_url": "https://unsplash.com/?utm_source=weather-sweater&utm_medium=referral",
            "photographer": "Wes Hicks",
            "photographer_url": "https://unsplash.com/@sickhews?utm_source=weather-sweater&utm_medium=referral"
          }
        }
      }
  }
```

___
- `POST /api/v1/road_trip`: fetches travel time and the weather forecast for the anticipated time of arrival at the destination

  - required information (*must be sent as JSON in the body of the request*): <br>`api_key, origin, destination`
  - example request: http://localhost:3000/api/v1/road_trip
  ```
  {
      "api_key": "UAUMJpJ9eEu1A4dr7ZWrMjij",
      "origin": "Boise, ID",
      "destination": "San Antonio, TX"
  }
  ```
  - example response:
  ```
  {
      "data": {
        "id": null,
        "type": "roadtrip",
        "attributes": {
          "start_city": "Boise, ID",
          "end_city": "San Antonio, TX",
          "travel_time": "26 hours, 12 minutes",
          "weather_at_eta": {
              "conditions": "broken clouds",
              "temperature": 65.35
          }
        }
      }
    }
```

## Technologies Used
- External APIs
  - [MapQuest Geocoding API](https://developer.mapquest.com/documentation/geocoding-api/)
  - [MapQuest Directions API](https://developer.mapquest.com/documentation/directions-api/)
  - [OpenWeather One Call API](https://openweathermap.org/api/one-call-api)
  - [Unsplash Photo Search API](https://unsplash.com/documentation#search-photos)
- Ruby v. 2.5.3
- Rails v. 5.2.4
- Dependencies:
  - Bcrypt
  - Faraday
  - Fast JSON API
  - Figaro
- Testing Tools:
  - RSpec
  - Webmock
  - VCR
  - FactoryBot
  - Faker
  - ShouldaMatchers
  - SimpleCov

## Local Setup
To use the project in your local environment, please follow the instructions below:

1. Apply for API keys from:<br>
  [MapQuest](https://developer.mapquest.com/plan_purchase/steps/business_edition/business_edition_free/register)<br>
  [OpenWeather](https://home.openweathermap.org/users/sign_up)<br>
  [Unsplash](https://unsplash.com/join)
2. Clone the repository:<br>
  `git clone git@github.com:cunninghamge/whether-sweater.git`
  `cd whether-sweater`
3. Install gem packages
  `bundle install`
4. Create the database
  `rails db:{create,migrate}`
4. Install Figaro
  `figaro install`
5. Enter API keys in `config/application.yml` using the following syntax:<br>
  *MapQuest:* `LOCATION_API_KEY: <your api key>`<br>
  *OpenWeather:* `WEATHER_API_KEY: <your api key>`<br>
  *Unsplash:* `BACKGROUND_API_KEY: <your api key>`
6. To launch a local server:<br>
  `rails s`<br>
  Once the server is running you can send requests to `localhost:3000`<br>
  ex: `http://localhost:3000/api/v1/forecast?location=asheville,nc`
7. To run tests and view the test coverage report:<br>
  `bundle exec rspec`  
  `open coverage/index.html`
