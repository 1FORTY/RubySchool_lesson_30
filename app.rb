#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, {adapter: "sqlite3", database: "barbershop.db"}

class Client < ActiveRecord::Base
  # Делаем валидацию через ActiveRecord для visit.erb
  # presence - присутствие. Отвечает как не странно за то, что присутствует ли там что-то
  validates :name, presence: true, length: { minimum: 3, maximum: 10 }
  validates :phone, presence: true
  validates :datestamp, presence: true
  validates :color, presence: true
end

class Barber < ActiveRecord::Base

end

get '/' do
  @barbers = Barber.all # Просто сохраняем список в переменную
  @barbers_2 = Barber.order 'created_at DESC' # Сохраняем и добавляем сортировку по created_at и делаем мы это в обратном порядке из-за DESC

  erb :index
end

get '/visit' do
  @c = Client.new
  @barbers = Barber.all

  erb :visit
end

post '/visit' do

  @c = Client.new params[:client]
  if @c.save
    erb "<h2>Спасибо, вы записаны.</h2>"
  else
    @error = @c.errors.full_messages.first
    erb :visit
  end
end

get '/barber/:id' do
  id = params[:id]
  erb :barber
end
