class WorkoutsController < ApplicationController

    get '/workouts' do
        redirect_if_not_logged_in
        # if logged_in?
        @user = User.find_by_id(session[:user_id])
        erb :"users/show"
        # else  
        #     redirect to "/login"
        # end
    end

    get '/workouts/new' do
        redirect_if_not_logged_in
        # if logged_in?
        erb :"workouts/new"
        # else  
        #     redirect to "/login"
        # end
    end

    post '/workouts' do
        @workout = Workout.new(name: params[:name], user_id: session[:user_id])
        if @workout[:name] == ""
            redirect to "/workouts/new"
        else
        @workout.save
        end

        if params[:exercise][:exercise_name].all? { |name| name == "" }
        redirect to "/workouts/new"
        else   
        params[:exercise][:exercise_name].each_with_index do |en, i|   
                if en != ""
            @workout.exercises.build(exercise_name: en, notes: params[:exercise][:notes][i])
          
            @workout.save
                end
            end
        redirect to "/workouts/#{@workout.id}"
        end
    end
     
    
    get '/workouts/:id' do
        redirect_if_not_logged_in
        # if logged_in?
        @workout = Workout.find(params[:id])
        if @workout.user_id == current_user.id
        erb :"workouts/show"
        else  
            flash[:errors] = "That workout doesn't belong to you! Select oneof your own workouts below."
            redirect to '/workouts'
        end
        # else
        #     redirect to "/login"
        # end
    end

    get '/workouts/:id/edit' do
        redirect_if_not_logged_in
        # if logged_in?
        @workout = Workout.find_by_id(params[:id])
        if @workout && @workout.user == current_user
            @exercise = @workout.exercises
            erb :"workouts/edit"
        else 
            redirect to "/workouts"
        end
        # else
        #     redirect to "/login"
        # end

    end

    patch '/workouts/:id' do
        if params[:name] == "" || params[:exercise][:exercise_name] == "" ||params  [:exercise][:notes] == ""
            flash[:errors] = "Can't have blank workout name!"
            redirect to "/workouts/#{params[:id]}/edit"
        else
             @workout = Workout.find_by_id(params[:id])
             @workout.update(name: params[:name])
        end
            
        params[:exercise][:exercise_name].each_with_index do |en, i|
            if en == ""
                flash[:errors] = "Can't have blanke exercise name!"
                redirect to "/workouts/#{params[:id]}/edit"
            else
                @exercise = Exercise.find_by_id(params[:exercise][:id][i])
                @exercise.update(exercise_name: en, notes: params[:exercise[:notes][i]) 
            end
        end
        redirect to "/workouts/#{params[:id]}"
    end

    delete '/workouts/:id/delete' do
        redirect_if_not_logged_in
            @workout = Workout.find_by_id(params[:id])
            if @workout && @workout.user.id = current_user.id
                @workout.destroy
                redirect to "/workouts"
            else
                flash[:errors] = "Oops. This workout doesn't belong to you."
                redirect to "/workouts/#{params[:id]}"
            end

    end

end