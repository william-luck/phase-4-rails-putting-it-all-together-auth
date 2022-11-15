class RecipesController < ApplicationController

rescue_from ActiveRecord::RecordNotFound, with: :no_user_error_message
rescue_from ActiveRecord::RecordInvalid, with: :invalid_error

    def index
        user = User.find(session[:user_id])
        if user
            recipes = Recipe.all
            render json: recipes, status: :created
        end
    end

    def create
        user = User.find(session[:user_id])
        if user
            new_recipe = Recipe.create!(recipe_params(user))
            render json: new_recipe, status: :created
        end


    end

    private

    def recipe_params(user)

        hash = params.permit(:title, :instructions, :minutes_to_complete)
        hash[:user_id] = user.id
        hash
    end


    def no_user_error_message
        render json: {errors: ['Not logged in']}, status: :unauthorized
    end

    def invalid_error
        render json: {errors: ["Not found"]}, status: :unprocessable_entity
    end


end
