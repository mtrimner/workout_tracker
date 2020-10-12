class UsersController < ApplicationController

    get '/signup' do
        if logged_in?
            redirect to "/workouts"
        else
        erb :"users/new"
        end
    end

    post '/signup' do
        @user = User.new(params)
        if @user && @user.save
            session[:user_id] = @user.id
            redirect to "/workouts/new"
        else
            erb :"users/new"
        end

    end
    
    get '/login' do
        if logged_in?
            redirect to "/workouts"
        else
        erb :"users/login"
        end
    end

    post '/login' do
        @user = User.find_by(email: params[:email])
        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            redirect to "/workouts"
        else
            flash[:errors] = "Incorrect Email or Password"
            redirect to "/login"
        end
    end

    get '/logout' do
        if logged_in?
            session.destroy
            redirect to "/login"
        else
            redirect to "/"
        end
    end

end