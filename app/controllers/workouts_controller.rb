class WorkoutsController < ApplicationController

    get '/workouts' do
        if logged_in?
            @user = User.find_by_id(session[:user_id])
            erb :"users/show"
        else  
            redirect to "/login"
        end
    end

    get '/workouts/new' do
        if logged_in?
            erb :"workouts/new"
        else  
            redirect to "/login"
        end
    end

    post '/workouts' do
        if logged_in?
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

        else 
            redirect to "/login"
        end
    end
     
    
    get '/workouts/:id' do
        
        if logged_in?
            @workout = Workout.find(params[:id])
            if @workout.user_id == current_user.id
            erb :"workouts/show"
            else  
                flash[:errors] = "That workout doesn't belong to you! Select one of your own workouts below."
                redirect to '/workouts'
            end
        else
            redirect to "/login"
        end
    end

    get '/workouts/:id/edit' do
        if logged_in?
            @workout = Workout.find_by_id(params[:id])
            if @workout && @workout.user == current_user
                @exercise = @workout.exercises
                erb :"workouts/edit"
            else 
                redirect to "/workouts"
            end
        else
            redirect to "/login"
        end

    end

    patch '/workouts/:id' do
        if logged_in?
            
            if params[:name] == ""
                redirect to "/workouts/#{params[:id]}/edit"
            else
                @workout = Workout.find_by_id(params[:id])
                @workout.update(name: params[:name])
            end
           
            params[:exercise][:exercise_name].each_with_index do |en, i|
                    @exercise = Exercise.find_by_id(params[:exercise][:id][i])
                    @exercise.update(exercise_name: en, notes: params[:exercise][:notes][i]) 
                
            end
            redirect to "/workouts/#{params[:id]}"
        else  
            redirect to "/login"
        end
    end

    delete '/workouts/:id/delete' do
        if logged_in?
            @workout = Workout.find_by_id(params[:id])
            if @workout && @workout.user.id = current_user.id
                @workout.destroy
            else
                redirect to "/workouts"
            end
        else
            redirect to "/login"
        end

    end

end