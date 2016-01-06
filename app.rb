require "sinatra"
require "sinatra/activerecord"
require "./models"
require "sinatra/flash"

set :database, "sqlite3:micro_blogdb.sqlite3"

enable :sessions

get '/' do
	if current_user
		redirect '/user'
	end
	erb :signin	
end

post '/' do
	@user = User.where(username: params[:username]).first

	if @user && @user.password == params[:password]
		flash[:notice] = "Thanks for logging in!"
		session[:user_id] = @user.id
		redirect '/user'
	else
		flash[:notice] = "Please enter a valid username/password combo"
		redirect "/"
		
	end
end

get '/signup' do
	erb :signup
end

post '/signup' do
	User.create(name: params[:name],password: params[:password],
		username: params[:username],email: params[:email], images: params[:images])
	redirect '/user'
end 

get '/user' do 
	puts session.inspect
	@user = current_user
	@post = @user.posts
	erb :user
end

post '/user' do 
	@user = current_user
	Post.create(title: params[:title],body: params[:body],user_id: @user.id)
	redirect '/user'
end

get '/logout' do
	session.clear
	redirect '/'
end

def current_user
	if session[:user_id]
		@current_user = User.find(session[:user_id])
	end
end


