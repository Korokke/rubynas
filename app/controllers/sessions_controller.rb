class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :destroy, if: ->{ !signed_in? }
  before_action ->{ redirect_to current_user }, only: :create, if: ->{ signed_in? }

  def new
  end

  def create
    user = User.authenticate params[:name], params[:password]
    if user != nil
      sign_in user
      redirect_to user
    else
      render json: {status: "failure", message: "Invalid name or password combination"}
      # format.html { redirect_back "users/index", status: :unauthorized, notice: "Invalid name or password combination" }
      # format.json { render json: user.errors, status: :unprocessable_entity }
    end
  end

  def destroy
    reset_session
    sign_out
    redirect_to root_path
  end

end
