require 'sinatra'
require './services/movies/create'
require './services/reservations/create'
require './blueprints/movie_blueprint'
require './blueprints/reservation_blueprint'

class App < Sinatra::Base
  before do
    content_type :json
  end

  get '/' do
    {hello: 'world'}.to_json
  end

  post '/movies' do
    input = params.slice(:name, :description, :image_url, :show_days)
    result = Movies::Create.new.(input)

    if result.success?
      status 200
      result.success[:model].values.to_json
    else
      status 400
      result.failure.to_json
    end
  end

  get '/movies' do
    if params[:show_day]
      status 200

      movies = Movie
        .association_join(:show_days)
        .where(day_number: params[:show_day])
        .select_all(:movies)
        .to_a

      MovieBlueprint.render(movies)
    else
      status 400
      {error: "show_day param is required"}.to_json
    end
  end

  post '/movies/:movie_id/reservations' do
    input = params.slice(:reservation_date, :reservation_count, :document).merge(movie_id: params[:movie_id])
    result = Reservations::Create.new.(input)

    if result.success?
      status 200
      result.success[:model].values.to_json
    else
      status 400
      result.failure.to_json
    end
  end

  get '/reservations' do
    if params[:start_date] && params[:end_date]
      status 200

      reservations = Reservation
        .association_join(:movie)
        .where(reservation_date: params[:start_date]...params[:end_date])
        .select_all(:reservations)
        .to_a

      ReservationBlueprint.render(reservations)
    else
      status 400
      {error: "start_date and end_date params are required"}.to_json
    end
  end
end
