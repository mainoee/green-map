class PlacesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index

    if params[:search].present?
      coordinates = Geocoder.coordinates(params[:search], lookup: :nominatim)
      @places = Place.near(coordinates).geocoded.not_clean_yet.order("created_at DESC")
    else
      @places = Place.geocoded.not_clean_yet.order("created_at DESC")
    end
  end

  def show
    @place = Place.find(params[:id])
    @mission = Mission.new

    @mission_user = @place.missions.find_by(status: 'planned', captaingreen: current_user)

    @markers = [
      {
        lat: @place.latitude,
        lng: @place.longitude,
        # infoWindow: render_to_string(partial: "info_window", locals: { place: @place })
        image_url: helpers.asset_url('icons/red_mapmarker_icon.png')
      }
    ]
  end

  def new
    @place = Place.new
  end

  def create
    @place = Place.new(params_places)
    @place.status = "new"
    @place.mapmaster = current_user
    @place.mapmaster.points += 10
    @place.mapmaster.save


    @place.longitude = cookies[:longitude]
    @place.latitude = cookies[:latitude]


    "#{@place.longitude} #{@place.latitude}"

    if @place.save
      redirect_to congrats_on_alerting_place_path(@place)
    else
      render :new
    end
  end

  def geolocate_user
    cookies[:latitude]
    cookies[:longitude]
    @markers = [{lat: cookies[:latitude], lng: cookies[:longitude]}]
  end

  def congrats_on_alerting
    @place = Place.find(params[:id])
  end

  private

  def params_places
    params.require(:place).permit(:volume, :mapmaster_photo, :latitude, :longitude, trashes_on_site: [])
  end
end
