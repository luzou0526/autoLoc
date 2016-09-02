if RUBY_VERSION.to_f >= 1.9
  require 'csv'
else
  require 'rubygems'
  require 'faster_csv'
end

require 'auto_location/string'

module AutoLocation
  city_file = File.open(File.join(File.dirname(__FILE__), '..', 'data', 'cities.csv'))
  state_file = File.open(File.join(File.dirname(__FILE__), '..', 'data', 'states.csv'))

  csv_method = lambda{ |x| RUBY_VERSION.to_f >= 1.9 ? CSV.read(x) : FasterCSV.parse(x) }
  # regular expressions for city: CITY_NAME_PART1.*PART2.*....*STATE.*
  # ex. San+.*Jose+.*(CA)*.*
  @cities ||= csv_method.call(city_file).map do |x|
                [ Regexp.new(((x[2].split(/[\s\,]/).map(&:strip) << ('(' + x[1] + ')')).join('.*') + '*.*').upcase),
                  x[2],
                  x[1]
                ]
              end
  @cities_hash ||= Hash[(csv_method.call(city_file)).map do |x|
                [(x[2] + ', ' + x[1]).upcase, [x[2], x[1]]]
              end]
  @zips   ||= Hash[(csv_method.call(city_file)).map do |x|
                [x[0].to_i, [x[2], x[1]]]
              end]
  @states ||= Hash[(csv_method.call(state_file)).map do |x|
                state = x[0]
                x[0] = state.upcase
                x << state
              end]
  # default result if zipcode, city, state search all failed
  @not_found_location ||= {error: "Location Not Found"}.freeze

  class << self
    def cities
      @cities
    end

    def cities_hash
      @cities_hash
    end

    def zips
      @zips
    end

    def states
      @states
    end

    def not_found_location
      @not_found_location
    end
  end
end
