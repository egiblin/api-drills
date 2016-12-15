require "./lib/geolocation"
require "sinatra/base"
require 'pry'
require 'json'
require 'net/http'

require "dotenv"
Dotenv.load

class Dashboard < Sinatra::Base
  get("/") do
    @ip = request.ip
    if @ip == "::1"
      @ip = "50.241.127.209"
    end
    @geolocation = Geolocation.new(@ip)
    erb :dashboard
  end

  get("/news") do
    key = ENV["NYTIMES_KEY"]
    uri = URI("http://api.nytimes.com/svc/topstories/v2/technology.json?api-key=#{key}")
    response = Net::HTTP.get_response(uri)
    response_data = JSON.parse(response.body)
    @news = response_data["results"]
    erb :news
  end

  get("/weather") do
    key = ENV["WUNDERGROUND_KEY"]
    uri = URI("http://api.wunderground.com/api/#{key}/conditions/q/MA/Boston.json")
    response = Net::HTTP.get_response(uri)
    response_data = JSON.parse(response.body)
    @temp = response_data["current_observation"]["temp_f"]
    erb :weather
  end

  get("/events") do
    key = ENV["SEATGEEK_KEY"]
    uri = URI("https://api.seatgeek.com/2/events?venue.city=Boston&client_id=#{key}")
    response = Net::HTTP.get_response(uri)
    response_data = JSON.parse(response.body)
    @events = response_data["events"]
    erb :events
  end
end
