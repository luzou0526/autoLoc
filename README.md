# AutoLoc
If a string contains a US zipcode/city/state, this gem will convert it into a parsed ruby object including a valid location.

# Install
Add the following into your Rails Gemfile
```ruby
  gem 'auto_location'
```
Then run bundler to install
```ruby
  $ bundle 
  or 
  $ bundle install
```
Or install directly on command line
```ruby
  $ gem install auto_location
```

# Update
In version 0.0.4, added county support. 

# Usage Example
After the gem is installed, in Ruby Code:
```ruby
 '95129'.validated_location => {location: {zipcode: '95129', city: "San Jose", state: "CA"}, type: 'zipcode'}
 'San Jose, CA'.validated_location => {location: {city: "San Jose", state: "CA"}, type: 'city'}
 'CA'.validated_location => {location: 'CA', type: 'state'}
 'Orange County, CA'.validated_location =>  {location: {county: "Orange County", state: "CA"}, type: 'county'}
```
The string can also include some unuseful info:
```ruby
  'San Jose, Wait! Where am I???'.validated_location => {location: {city: "San Jose", state: "CA"}, type: 'city'}
```
If the string is not able to be parsed:
```ruby
  '1428 random text, 35000, San Josa, CC'.validated_location => {error: "Location Not Found"}
```

# Notice
The geo location data in the gem doesn't contain all location in US, and some of the parsing logic may not meet your requirement. But! We will make it better!
