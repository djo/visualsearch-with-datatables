require 'sinatra'
require "sinatra/json"
require 'sinatra/reloader' if development?

get '/' do
  erb :index
end

get '/list.json' do
  json({
    aaData: LANGUAGES,
    sEcho: params[:sEcho],
    iTotalRecords: LANGUAGES.size,
    iTotalDisplayRecords: LANGUAGES.size
  })
end

LANGUAGES = [
  ['Erlang', 'strong', 'dynamic'],
  ['Java', 'strong', 'static'],
  ['JavaScript', 'weak', 'dynamic'],
  ['Ruby', 'strong', 'dynamic']
]
