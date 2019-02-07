require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'pg'
require 'active_record'
require_relative 'db_config'
require_relative 'models/user'
require_relative 'models/buyer'
require_relative 'models/pitch'
require_relative 'models/genre'

enable :sessions

helpers do
  def current_user
    session[:user_type] == "user" && User.find_by(id: session[:user_id])
  end

  def current_buyer
    session[:user_type] == "buyer" && Buyer.find_by(id: session[:user_id])
  end

  def logged_in?
    if current_user
      return true
    else
      return false
    end
  end

  def buyer_logged_in?
    if current_buyer
      return true
    else
      return false
    end
  end
end

get '/' do
  erb :index
end

get '/about' do
  erb :about
end

get '/about/2' do
  erb :about2
end

get '/pitches' do
  @pitches = Pitch.all
  @users = User.all
  @genres = Genre.all
  erb :pitches
end

post '/pitches' do
  redirect '/login' unless logged_in?
  pitch = Pitch.new
  pitch.title = params[:title]
  pitch.synopsis = params[:synopsis]
  pitch.genre_id = params[:id].to_i
  pitch.structural_element = params[:structural_element]
  pitch.film_comparison = params[:film_comparison]
  pitch.user_id = current_user.id
  pitch.save
  redirect '/pitches'
end

get '/pitches/new' do
  @genres = Genre.all
  erb :new_pitch
end

get '/pitches/:id' do
  @pitch = Pitch.find(params[:id])
  @users = User.all
  @genres = Genre.all
  erb :pitch_details
end

delete '/pitches/:id' do
  @pitch = Pitch.find(params[:id])
  @pitch.destroy
  redirect '/pitches'
end

get '/pitches/:id/edit' do
  @pitch = Pitch.find(params[:id])
  @genres = Genre.all
  erb :edit_pitch
end

put '/pitches/:id' do
  pitch = Pitch.find(params[:id])
  pitch.title = params[:title]
  pitch.synopsis = params[:synopsis]
  pitch.genre_id = params[:genre_id].to_i
  pitch.structural_element = params[:structural_element]
  pitch.film_comparison = params[:film_comparison]
  pitch.save
  redirect "/pitches/#{params[:id]}"
end

get '/type_of' do
  erb :type_of
end

get '/sign_up' do
  erb :sign_up
end

post '/sign_up' do
  user = User.new
  user.name = params[:name]
  user.email = params[:email]
  user.password = params[:password]
  user.bio = params[:bio]
  user.country = params[:country]
  user.employment_status = params[:employment_status]
  user.save
  redirect '/'
end

get '/sign_up_buyer' do
  erb :sign_up_buyer
end

post '/sign_up_buyer' do
  buyer = Buyer.new
  buyer.name = params[:name]
  buyer.email = params[:email]
  buyer.password = params[:password]
  buyer.country = params[:country]
  buyer.save
  redirect '/'
end

get '/type_of_log_in' do
  erb :type_of_sign_in
end

get '/login' do
  erb :login
end

get '/login_buyer' do
  erb :login_buyer
end

post '/session' do
  if params[:user_type] == "buyer"
    buyer = Buyer.find_by(email: params[:email])
    if buyer && buyer.authenticate(params[:password])
      session[:user_id] = buyer.id
      session[:user_type] = "buyer"
      session[:name] = buyer.name
      redirect '/pitches'
    end
  elsif params[:user_type] == "user"
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:user_type] = "user"
      session[:name] = user.name
      redirect '/pitches'
    end
  else
    erb :login
  end
end

delete '/session' do
  session[:user_id] = nil
  redirect '/'
end

get '/profiles' do
  @users = User.all
  erb :profiles
end

get '/profiles/:id' do
  @user = User.find(params[:id])
  @pitches = Pitch.where(params[:user_id])
  @count = 0
  erb :profile_details
end

get '/my_profile/:id' do
  @user = User.find_by(id: current_user.id)
  @buyer = Buyer.find_by(id: current_buyer.id)
  erb :my_profile
end

get '/my_profile/:id/edit' do
  @user = User.find(params[:id])
  erb :my_profile_edit
end

put '/my_profile/:id' do
  user = User.find_by(id: current_user.id)
  user.name = params[:name]
  user.bio = params[:bio]
  user.country = params[:country]
  user.employment_status = params[:employment_status]
  user.save
  redirect "/my_profile/#{params[:id]}"
end

get '/settings/:id/edit' do
  @user = User.find(params[:id])
  erb :settings
end

put '/settings/:id' do
  user = User.find_by(id: current_user.id)
  user.email = params[:email]
  user.password = params[:password]
  user.save
  redirect "/my_profile/#{params[:id]}"
end

get '/my_pitches' do
  redirect '/login' unless logged_in?
  @pitches = Pitch.where(user_id: current_user.id)
  erb :my_pitches
end

get '/watch_list' do
  erb :watch_list
end

get '/new_offer' do
  erb :new_offer
end