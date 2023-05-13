class TweetsController < ApplicationController
    def create
        session = Session.find_by(token: cookies.signed[:twitter_session_token])
        user = session&.user
      
        if user
          @tweet = user.tweets.build(tweet_params)
      
          if @tweet.save
            render json: {
              tweet: {
                username: user.username,
                message: @tweet.message,
              }
            }, status: :created
          else
            render json: @tweet.errors, status: :unprocessable_entity
          end
        else
          render json: { error: "User not authenticated" }, status: :unauthorized
        end
      end
    
      def destroy
        session = Session.find_by(token: cookies.signed[:twitter_session_token])
        user = session&.user
    
        if user
          tweet = user.tweets.find_by(id: params[:id])
          if tweet
            tweet.destroy
            render json: { success: true }
          else
            render json: { error: "Tweet not found" }, status: :not_found
          end
        else
          render json: { "success":false }, status: :unauthorized
        end
      end

      def index
        @tweets = Tweet.order(created_at: :desc).all
        render 'index.jbuilder', status: :ok
      end
    
      def index_by_user
        @user = User.find_by(username: params[:username])
        if @user
          @tweets = @user.tweets.order(created_at: :desc).all
          render 'index.jbuilder', status: :ok
        else
          render json: { error: "User not found" }, status: :not_found
        end
      end

    private
  
    def tweet_params
      params.require(:tweet).permit(:message)
    end
  end
  
  
  
