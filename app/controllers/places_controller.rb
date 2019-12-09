class PlacesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :new]

  def index
    @places = Place.all
    @places = @places.order("updated_at DESC")
  end

  def show
    @place = Place.find(params[:id])
    @mission = Mission.new
  end

  def new
    @place = Place.new
  end

  def create
    @place = Place.new(params_places)
    @place.status = "new"
    @place.mapmaster = current_user
    @place.mapmaster.points += 10

    # COOKIE STUFF
    @place.longitude = cookies[:longitude]
    @place.latitude = cookies[:latitude]

    #testing
    puts "#{@place.longitude} #{@place.latitude}"

    if @place.save
      redirect_to place_congratulations_path(@place)
    else
      render :new
    end
  end

  def geolocate_user
    p cookies[:latitude]
    p cookies[:longitude]
    @markers = [{lat: cookies[:latitude], lng: cookies[:longitude]}]
  end

  private

  def params_places
    params.require(:place).permit(:volume, :mapmaster_photo, :latitude, :longitude, trashes_on_site: [])
  end
end
