require 'sinatra'
require "sinatra/json"
require 'sinatra/reloader' if development?

get '/' do
  erb :index
end

get '/list.json' do
  data = Languages.new(params[:search]).filter

  json({
    aaData: data,
    sEcho: params[:sEcho],
    iTotalRecords: Languages::DATA.length,
    iTotalDisplayRecords: data.size
  })
end

class Languages
  DATA = [
    ['Erlang', 'strong', 'dynamic'],
    ['Java', 'strong', 'static'],
    ['JavaScript', 'weak', 'dynamic'],
    ['Ruby', 'strong', 'dynamic']
  ]

  COLUMNS = { 'strength' => 1, 'checking' => 2 }

  def initialize(conditions)
    @conditions = conditions || {}
  end

  def filter
    return DATA if @conditions.length == 0
    DATA.select { |language| match?(language) }
  end

  private

  def match?(language)
    @conditions.each do |name, options|
      value = language[COLUMNS[name]]
      return false unless options.include?(value)
    end

    true
  end
end
