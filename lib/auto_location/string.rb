class String
  # Add methods to String class
  def validated_location
    # If search includes valid zipcode, return zipcode
    # If zipcode doesn't exist, do city search.
    # If city doesn't exist, do state search.
    zipcode(self) || city_perfect_match(self) || city(self) || state(self) || AutoLocation.not_found_location
  end

  # Check if zipcode exists
  def zipcode(zipcode)
    zipcode.scan(/\d{5}/).each do |token|
      result = AutoLocation.zips[token.to_i]
      return { location: {zipcode: token, city: result[0], state: result[1]}, type: 'zipcode' } unless result == nil
    end
    false
  end

  def city_perfect_match(city)
    city = city.upcase
    result = AutoLocation.cities_hash[city]
    result == nil ? false : { location: {city: result[0], state: result[1]}, type: 'city' }
  end

  # Find a city with the search string
  def city(city)
    city = city.upcase
    results = []
    AutoLocation.cities.find_all do |row|
      results << row unless city[row[0]] == nil
    end
    result = results == [] ? nil : results.max {|a,b| a[1].length <=> b[1].length}
    result == nil ? false : { location: {city: result[1], state: result[2]}, type: 'city' }
  end

  # Find a state with the search string
  def state(state)
    state = state.upcase
    # add a white space for easier regex match
    state.split(/[\s\,]/).each do |token|
      found_state = AutoLocation.states[token]
      return { location: found_state, type: 'state' } unless AutoLocation.states[token] == nil
    end
    false
  end
end
