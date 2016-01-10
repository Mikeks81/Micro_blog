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

post '/signup' do
	@user = User.create(name: params[:name],password: params[:password],
		username: params[:username],email: params[:email], images: params[:images])
	session[:user_id] = @user.id
	flash[:notice] = "Thanks for signing up!!"
	redirect '/user'
end 

get '/user' do 
	@user = current_user
	@all_user = User.all
	@posts = @user.posts.reverse.first(10)
	@all_posts = Post.all.reverse.first(10)
	erb :user
end

post '/user' do 
	@user = current_user
	Post.create(title: params[:title],body: params[:body],user_id: @user.id)
	redirect '/user'
end

get '/edit_acct' do
	@user = current_user
	erb :edit_acct
end

post '/edit_acct' do
	@user = current_user
	@user.update_attributes(name: params[:name],username: params[:username],email: params[:email],password: params[:password])
	redirect '/'
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

get '/delete_post/:id' do 
	@user = current_user
	@post = @user.posts.find(params[:id])
	@post.delete
	redirect '/user'
end

get '/profile/:id' do
	@user_page = User.find_by(id: params[:id])
	@posts = @user_page.posts
	erb :profile
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


