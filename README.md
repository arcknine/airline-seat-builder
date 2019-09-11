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
1. via curl
  sample: `curl -X GET 'http://localhost:3000/v1/seats' -d 'seats=[[3,4],[4,5],[2,3],[3,4]]&passengers=30'`
  response:
  ```[[[19,25,26,1],[2,27,28,29,3],[4,30,5],[6,"X","X",20]],[[21,"X","X",7],[8,"X","X","X",9],[10,"X",11],[12,"X","X",22]],[[23,"X","X",13],[14,"X","X","X",15],null,[16,"X","X",24]],[null,[17,"X","X","X",18],null,null],[null,null,null,null]]```
2. you can also get the response via browser by adding `seats` and `passenger` parameters on the url endpoint
  sample: `http://localhost:3000/v1/seats?seats=[[2,3],[3,4],[3,2],[4,3]]&passengers=30`
  response:
  ```[[[19,25,26,1],[2,27,28,29,3],[4,30,5],[6,"X","X",20]],[[21,"X","X",7],[8,"X","X","X",9],[10,"X",11],[12,"X","X",22]],[[23,"X","X",13],[14,"X","X","X",15],null,[16,"X","X",24]],[null,[17,"X","X","X",18],null,null],[null,null,null,null]]```

# How to read api response
The response is a 3 Dimentional Array. The outer array are the rows, 2nd inner array are the seat groups and lastly the inner array are the seat columns. The `X` values on last innner array are empty seats while the null values 2nd inner array are non-exisiting seats.