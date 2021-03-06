ENV["RACK_ENV"] ||= "development"
require 'sinatra/base'
require './models/link'
require_relative 'data_mapper_setup'
require 'sinatra/flash'

class Bookmarks < Sinatra::Base

  register Sinatra::Flash

  enable :sessions
  set :session_secret, 'super secret'

  get '/' do
    redirect '/links'
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  get '/links/new' do
    erb :'links/new_link'
  end


  post '/links' do
    link = Link.create(url: params[:url], title: params[:title]) #create a link
    params[:tags].split.each do |tag| #split the tags
    # tag = Tag.first_or_create(name: params[:tags]) #create tag for that link
    link.tags << Tag.create(name: tag)
    end   #add the multiple tag to the collection of tags (that you already have)
    link.save #save the link
    redirect '/links'
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  get '/users/new' do
    @user = User.new
    erb :'users/new'
  end

  post '/users' do
    @user = User.create(email: params[:email],
                password: params[:password],
                 password_confirmation: params[:password_confirmation])

    if @user.save # #save returns true/false depending on whether the model is successfully saved to the database.
    session[:user_id] = @user.id
    redirect to('/links')
     else
    flash.now[:errors] = @user.errors.full_messages
    erb :'users/new'
  end
end

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
    end
  end

  run! if app_file == $0
end
