require 'rubygems'
require 'json'
require 'bundler'
require 'sinatra'
require 'net/http'
require 'uri'
Bundler.require(:default)

def open(url)
  Net::HTTP.get(URI.parse(url))
end

get "/crashes_per_session" do
  output = ""
  response_json = JSON.parse(open('http://api.flurry.com/appMetrics/Sessions?apiAccessCode=RC8KC64CVVV4GSYRBZKM&apiKey=DSDSKKGN4NC87YFPRKHJ&startDate=2013-11-01&endDate=2013-12-5&versionName=4.4.0&groupBy=MONTHS'))
  days_array = response_json["day"]

  total_sessions = 0
  days_array.each do |day_stats|
    total_sessions += day_stats["@value"].to_i
    output += "Day array"
  end
  #days_array.to_s
  ((2900.to_f/total_sessions.to_f)*100.to_f).round(2).to_s + "%"
end


get "/" do
  erb :index
end

get "/latest_version_any_track" do
  Version.where("enabled = true").last.to_json
end




