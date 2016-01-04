require "sinatra"
require "sinatra/activerecord"
# require "./models"
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
		flash[:notice] = "Hello " + :username + " You have signed in."
	end
end