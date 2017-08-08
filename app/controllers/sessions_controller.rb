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
      render "users/index", locals: { login_error: 'Invalid name or password combination' }
    end
  end

  def destroy
    reset_session
    sign_out
    redirect_to root_path
  end

end
