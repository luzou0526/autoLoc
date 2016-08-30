if RUBY_VERSION.to_f >= 1.9
  require 'csv'
else
  require 'rubygems'
  require 'faster_csv'
end

require './auto_location/string'

module AutoLocation
  city_file = File.open(File.join(File.dirname(__FILE__), '..', 'data', 'cities.csv'))
  zip_file = File.open(File.join(File.dirname(__FILE__), '..', 'data', 'zips.csv'))
  state_file = File.open(File.join(File.dirname(__FILE__), '..', 'data', 'states.csv'))

  if RUBY_VERSION.to_f >= 1.9
    @cities = CSV.read(city_file)
    @zips = Hash[(CSV.read(zip_file)).map{|x| x << 1}]
    @states = CSV.read(state_file).flatten
  else
    @cities = FasterCSV.parse(city_file).flatten
    @zips = Hash[(FasterCSV.parse(zip_file)).map{|x| x << 1}]
    @states = FasterCSV.parse(state_file).flatten
  end

  class << self
    def cities
      @cities
    end

    def zips
      @zips
    end

    def states
      @states
    end

    def default_location
      # default result if zipcode, city, state search all failed
      @default_location ||= {location: 'San Francisco, CA', type: 'city'}.freeze
    end
  end
end

puts "San Jose, CA".validated_location
puts "San Jose CA".validated_location
puts "SanJoseCA".validated_location
puts "noises aaa 12 noises bbb San noises ccc Jose noises ddd CA".validated_location
puts "San CA".validated_location
