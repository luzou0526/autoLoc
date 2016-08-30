class String
  # Add methods to String class
  def validated_location
    # If search includes valid zipcode, return zipcode
    # If zipcode doesn't exist, do city search.
    # If city doesn't exist, do state search.
    zipcode(self) || city(self) || state(self) || @default_location
  end

  # Check if zipcode exists
  def zipcode(zipcode)
    zipcode.scan(/\d{5}/).each do |zipcode|
      return { location: zipcode, type: 'zipcode' } if AutoLocation.zips[zipcode] == 1
    end
    return nil
  end

  # Find a city with the search string
  def city(city)
    city = city.downcase
    result = AutoLocation.cities.find do |row|
      # Check if the city regexp matchs to any substring in the search string
      city[Regexp.new(((row[2].split(/[\s,\,]/).map(&:strip) << row[1]).join('.*') + '.*').downcase)]
    end
    { location: {city: result[2], state: result[1]}, type: 'city' } unless result == nil
  end

  # Find a state with the search string
  def state(state)
    state = state.downcase
    result = AutoLocation.states.find do |row|
      state.include? row.downcase
    end
    { location: result, type: 'state' } unless result == nil
  end
end
