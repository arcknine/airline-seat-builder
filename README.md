# README

## System dependencies

* Ruby version 2.5.0
* Rails version 5.2.3

## Running in localhost

1. run bundler `bundle install`
2. create database `rake db:setup`
3. start server `rails s`

## How to Run the Test Suite

1. run test by typing `rspec .`

## How to use the api

- `GET /api/v1/seats?seats=<[2d array string]>&passengers=<passenger_count>`
- `seats` parameter is a 2d array in string format
- `passengers` parameter should be a positive int value
- `seats` and `passengers` are required parameters

## Samples

1. via curl
  * `curl -X GET 'http://localhost:3000/v1/seats' -d 'seats=[[2,3],[3,4],[3,2],[4,3]]&passengers=30'`
2. via url browser
  * `http://localhost:3000/v1/seats?seats=[[2,3],[3,4],[3,2],[4,3]]&passengers=30`

## Response
```json
[
  [
    [19,25,1],[2,26,27,3],[4,5],[6,28,20]
  ],
  [
    [21,29,7],[8,30,"X",9],[10,11],[12,"X",22]
  ],
  [
    null,[13,"X","X",14],[15,16],[17,"X",23]
  ],
  [
    null,null,null,[18,"X",24]
  ]
]
```

# How to read api response
The response is a 3 Dimentional Array. The outer array are the rows, 2nd inner array are the seat groups and lastly the inner array are the seat columns. The `X` values on last innner array are empty seats while the `null` values 2nd inner array means there are no seats on that row and group.