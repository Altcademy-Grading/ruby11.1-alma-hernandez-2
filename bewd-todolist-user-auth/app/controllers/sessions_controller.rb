class SessionsController < ApplicationController
  def create
      @user = User.find_by(username: params[:user][:username])

      if @user and @user.password == params[:user][:password]
        session = @user.sessions.create
        cookies.permanent.signed[:todolist_session_token] = {
          value: session.token,
          httponly: true
        }

        render json: {
          success: true
        }

      else
        render json: {
          success: false
        }
  end



  def authenticated
      token = cookies.permanent.signed[:todolist_session_token]
      session = Session.find_by[token: token]

      if session
        user = session.user

        render json: {
          authenticated: true
        }
      else
        render json: {
          authenticated: false
        }
  end

  def destroy
      token = cookies.permanent.signed[:todolist_session_token]
      session = Session.find_by[token: token]

      if session and session.destroy
        render json: {
          success: true
        }
      end
  end
end
