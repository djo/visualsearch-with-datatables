require 'sinatra'
require "sinatra/json"

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
    ['Ada', 'strong', 'partially-dynamic'],
    ['Basic', 'varies-by-dialect', 'n/a'],
    ['C', 'weak', 'static'],
    ['C++', 'strong', 'static'],
    ['Clojure', 'strong', 'dynamic'],
    ['Erlang', 'strong', 'dynamic'],
    ['Go', 'strong', 'static'],
    ['Haskell', 'strong', 'static'],
    ['Java', 'strong', 'static'],
    ['JavaScript', 'weak', 'dynamic'],
    ['Python', 'strong', 'dynamic'],
    ['Ruby', 'strong', 'dynamic'],
    ['Scala', 'strong', 'static']
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
