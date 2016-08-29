if RUBY_VERSION.to_f >= 1.9
  require 'csv'
else
  require 'rubygems'
  require 'faster_csv'
end

module AutoLocation
  city_file = File.open(File.join(File.dirname(__FILE__), '..', 'data', 'cities.csv'))
  zip_file = File.open(File.join(File.dirname(__FILE__), '..', 'data', 'zips.csv'))
  state_file = File.open(File.join(File.dirname(__FILE__), '..', 'data', 'states.csv'))

  if RUBY_VERSION.to_f >= 1.9
    @cities = CSV.read(city_file)
    @zips = CSV.read(zip_file)
    @states = CSV.read(state_file)
  else
    @cities = FasterCSV.parse(city_file)
    @zips = FasterCSV.parse(zip_file)
    @states = FasterCSV.parse(state_file)
  end

  # default result if zipcode, city, state search all failed
  @default_location = {location: 'San Francisco, CA', type: 'city'}.freeze

  class << self
    def validated_location(search_string)
      # If search includes valid zipcode, return zipcode
      search_string.scan(/\d{5}/).each do |zipcode|
        return { location: zipcode, type: 'zipcode' } if valid_zipcode?(zipcode)
      end
      # If zipcode doesn't exist, do city search.
      # If city doesn't exist, do state search.
      city(search_string) || state(search_string) || @default_location
    end

    # Check if zipcode is valid
    def valid_zipcode?(zipcode)
      @zips.find do |zip|
        zip[0] == zipcode
      end
    end

    # Find a city with the search string
    def city(city)
      city = city.downcase
      result = @cities.find do |row|
        # create an array of tokens, and convert it into regexp
        regexp_query_str = ''
        (row[2].split(/[\s,\,]/).map(&:strip)).each do |token|
          regexp_query_str += token + '.*'
        end
        regexp_query_str += '(' + row[1] + ')?'
        # Check if the regexp matchs to any substring in the search string
        city[Regexp.new(regexp_query_str.downcase)]
      end
      { location: [result[2], result[1]].compact.join(', '), type: 'city' } unless result == nil
    end

    # Find a state with the search string
    def state(state)
      state = state.downcase
      result = @states.find do |row|
        state.include? row[0].downcase
      end
      { location: result[0], type: 'state' } unless result == nil
    end
  end
end
