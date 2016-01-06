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
	@user = User.create(name: params[:name],password: params[:password],
		username: params[:username],email: params[:email], images: params[:images])
	session[:user_id] = @user.id
	redirect '/user'
end 

get '/user' do 
	@user = current_user
	@posts = @user.posts
	erb :user
end

post '/user' do 
	@user = current_user
	Post.create(title: params[:title],body: params[:body],user_id: @user.id)
	redirect '/user'
end

get '/delete_acct' do
	@user = current_user
	@user.delete
	session.clear
	redirect '/'
end

get '/remove_lpost' do
	@user = current_user
	@last_post = Post.where(@user.id).last
	@last_post.delete
	redirect '/'
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


