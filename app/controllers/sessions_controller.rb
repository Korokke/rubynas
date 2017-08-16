class SessionsController < ApplicationController
  before_action :update_user_last_activity, only: :destroy
  after_action :update_user_last_activity, only: :create
  skip_before_action :verify_authenticity_token, only: :destroy, if: ->{ !signed_in? }
  before_action ->{ redirect_to current_user }, only: :create, if: ->{ signed_in? }

  def create
    user = User.authenticate params[:name], params[:password]
    if user != nil
      sign_in user
      redirect_back fallback_location: root_path
    else
      render js: "alert('- Invalid name or password combination');"
    end
  rescue
    render js: "alert('- Failed to signin');"
  end

  def destroy
    sign_out
  rescue
    flash[:alert] = "- Failed to signout"
  ensure
    redirect_back fallback_location: root_path
  end

  private

  def update_user_last_activity
    current_user.touch if current_user # Update Last Activity
  end
end
