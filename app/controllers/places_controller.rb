class PlacesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :new]

  def index
    @places = Place.all
    @markers = @places.map do |place|
      {
        lat: place.latitude,
        lng: place.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { place: place })
      }
    end
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
    @place.save

    redirect_to place_path(@place)
  end

  private

  def params_places
    params.require(:place).permit(:address, :volume, :mapmaster_photo)
  end
end
