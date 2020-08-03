class CityController < ApplicationController
  def index
    @list_cities_domestic = City.domestic
    @list_cities_international = City.international
  end
end
