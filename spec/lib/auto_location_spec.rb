require File.expand_path('../../../lib/auto_location.rb', __FILE__)

describe 'auto location parse location from string' do
  let(:not_found_location_response) do
    {error: "Location Not Found"}
  end

  let(:valid_city_response) do
    {location: {city: "San Jose", state: "CA"}, type: 'city'}
  end

  let(:valid_zip_code_response) do
    {location: '95129', type: 'zipcode'}
  end

  let(:valid_state_response_short) do
    {location: 'CA', type: 'state'}
  end

  let(:valid_state_response_long) do
    {location: 'California', type: 'state'}
  end

  describe 'get zipcode' do
    it 'when input contains valid zipcode' do
      expect('string'.zipcode('hello world, San Jose, CA, 95129')).to eq(valid_zip_code_response)
      expect('string'.zipcode('any random 95129 test here')).to eq(valid_zip_code_response)
      expect('string'.zipcode('verymessystringthatcontains95129aszipcode')).to eq(valid_zip_code_response)
    end

    it 'when input does not contain valid zipcode' do
      expect('string'.zipcode('35000')).to be_falsey
      expect('string'.zipcode('No valid zip 35000 inside string')).to be_falsey
      expect('string'.zipcode('350000')).to be_falsey
    end
  end

  describe 'get city' do
    it 'when input contains valid city' do
      expect('string'.city('1428 downtown south San Jose, San Jose, CA')).to eq(valid_city_response)
      expect('string'.city('San some text Jose, some textCA')).to eq(valid_city_response)
      expect('string'.city('sanjoseca')).to eq(valid_city_response)
      expect('string'.city('some text San some text Jose some text')).to eq(valid_city_response)
    end

    it 'when input does not contain valid city' do
      expect('string'.city('1428 San Josa')).to be_falsey
      expect('string'.city('San Hose, CA')).to be_falsey
    end
  end

  describe 'get state' do
    it 'when input contains valid state' do
      expect('string'.state('ca')).to eq(valid_state_response_short)
      expect('string'.state('california')).to eq(valid_state_response_long)
      expect('string'.state('some text cA')).to eq(valid_state_response_short)
      expect('string'.state('some text California')).to eq(valid_state_response_long)
    end

    it 'when input does not contain valid state' do
      expect('string'.state('cc')).to be_falsey
      expect('string'.state('Calfooooo')).to be_falsey
      expect('string'.state('some text cC')).to be_falsey
      expect('string'.state('some text Califoooo')).to be_falsey
    end
  end

  describe 'get validated location' do
    it 'when input contains valid zip' do
      expect('1428 downtown south San Jose, 95129, San Jose, CA'.validated_location).to eq(valid_zip_code_response)
    end

    it 'when input contains valid city' do
      expect('1428 downtown south San Jose, 35000, San Jose, CA'.validated_location).to eq(valid_city_response)
    end

    it 'when input contains valid state' do
      expect('1428 random text, 35000, San Josa, CA'.validated_location).to eq(valid_state_response_short)
    end

    it 'when input contains no valid location' do
      expect('1428 random text, 35000, San Josa, CC'.validated_location).to eq(not_found_location_response)
    end
  end
end
