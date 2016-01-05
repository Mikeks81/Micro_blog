require "sinatra"
require "sinatra/activerecord"
require "./models"
require "sinatra/flash"

set :database, "sqlite3:micro_blogdb.sqlite3"

enable :sessions

get '/' do
	erb :signin	
end

post '/' do
	@user = User.where(username: params[:username]).first

	if @user && @user.password == params[:password]
		session[:user_id] = @user.id
		flash[:notice] = "Hello " + @user.username + " You have signed in."
	else
		redirect "/"
		flash[:notice] = "Please enter a valid username/password combo"
	end
end

get '/signup' do
	erb :signup
end

post '/signup' do
	User.create(name: params[:name],password: params[:password],
		username: params[:username],email: [:email], images: params[:images])
	redirect '/user'
end 

get '/user' do
	erb :user
	flash[:notice] = "Welcome " + @user.username + " !"
end

