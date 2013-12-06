require 'rubygems'
require 'json'
require 'bundler'
require 'sinatra'
require 'net/http'
require 'uri'
require 'active_record'
require 'sinatra/activerecord'
require 'sinatra/base'
require './models/user'
require './models/card'
Bundler.require(:default)

post "/card" do
  params  = JSON.parse(request.env["rack.input"].read)
  num       = params["number"]
  candidate = params["candidate"]
  card_type = params["card_type"]

  if num && candidate

    if num.length < 10
      status 400
      return "Card number is too short"
    end
    card = Card.new
    card.save
    id = card.id

    card = Card.find(id)
    card.last_four = num[-4,4]
    card.candidate = candidate
    card.card_type = card_type
    card.save

  elsif candidate.nil?
    status 401
    return "All requests must include a candidate value"
  end

  return card.to_json
end


get "/card" do
  candidate = params["candidate"]
  if candidate.nil?
    status 401 
    return "All requests must include a \"candidate\" parameter"
  end

  cards = Card.where(candidate: candidate)

  outputstring = "{\"cards\":["
  cards.each do |card|
    outputstring += card.to_json
    outputstring += ", "
  end

  outputstring += "]}"
end

get "/card/:card_id" do
  candidate = params["candidate"]
  if candidate.nil?
    status 401
    return "All requests must include a \"candidate\" parameter"
  end

  cards = Card.where("candidate = ? AND id = ?", candidate, params[:card_id])
  if cards.count > 0
    cards.first.to_json
  else
    status 404
    ""
  end
end

get "/" do
  erb :index
end

