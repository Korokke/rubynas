class UsersController < ApplicationController
  before_action :require_existing_user, :only => [:edit, :update, :destroy]

  def index
  end

  def new
  end

  def create
    @user = User.new(permitted_params_user)
    if @user.save
      path = "nas/" + @user.name
      Dir.mkdir path
      Dir.mkdir path + "public"
      Dir.mkdir path + "private"
      sign_in @user
      redirect_back fallback_location: "index"
    else
      messages = @user.errors.full_messages.map{ |line| '- ' + line }.join('\n')
      render js: "alert('#{messages}');"
    end
  end

  # Note: @user is set in require_existing_user
  def edit
  end

  # Note: @user is set in require_existing_user
  def update
    # if @user.update_attributes(permitted_params.user.merge({ :password_required => false }))
    #   redirect_to edit_user_url(@user), :notice => t(:your_changes_were_saved)
    # else
    #   render :action => 'edit'
    # end
  end

  # Note: @user is set in require_existing_user
  def destroy
    @user.destroy
    redirect_back fallback_location: "index"
  end


  private

  def permitted_params_user
    return params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def require_existing_user
    if current_user.admin? && params[:name] != current_user.name.to_s
      @user = User.find_by_name params[:name]
    else
      @user = current_user
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to users_url #, :alert => t(:user_already_deleted)
  end
end
