require 'sinatra'
require "sinatra/json"
require 'sinatra/reloader' if development?

get '/' do
  erb :index
end

get '/list.json' do
  options = {
    search: params[:search],
    column: params[:iSortCol_0],
    direction: params[:sSortDir_0]
  }

  data = Languages.new(options).filter

  json({
    aaData: data,
    sEcho: params[:sEcho],
    iTotalRecords: Languages::DATA.length,
    iTotalDisplayRecords: data.length
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

  def initialize(options)
    @search    = options[:search] || {}
    @column    = options[:column].to_i
    @direction = options[:direction] == 'asc' ? 1 : -1
  end

  def filter
    filtered = DATA.select { |l| match?(l) }
    filtered.sort { |l1, l2| compare(l1, l2) }
  end

  private

  def match?(language)
    @search.each do |name, options|
      value = language[COLUMNS[name]]
      return false unless options.include?(value)
    end

    true
  end

  def compare(language1, language2)
    column1 = language1[@column]
    column2 = language2[@column]

    (column1 <=> column2) * @direction
  end
end
