class SessionsController < ApplicationController

rescue_from ActiveRecord::RecordNotFound, with: :error_message

    def create
        user = User.find_by(username: params[:username])
        if user&.authenticate(params[:password])
            session[:user_id] = user.id
            render json: user
        else
            render json: {errors: ["Invalid username or password"]}, status: :unauthorized
        end
    end

    def destroy
        user = User.find(session[:user_id])
        if user
            session.clear
            head :no_content
        end
    end

    private

    def error_message
        render json: {errors: ["Invalid username or password"]}, status: :unauthorized
    end

end
