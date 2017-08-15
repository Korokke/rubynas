class UsersController < ApplicationController
  before_action :require_existing_user, only: [:update, :destroy]
  before_action :filter_password_params, only: :update

  def index
  end

  def show
  end

  def create
    @user = User.new(permitted_params_user)
    if @user.save
      path = "nas/" + @user.name
      Dir.mkdir path
      Dir.mkdir File.join(path, "public")
      Dir.mkdir File.join(path, "private")
      sign_in @user
      redirect_back fallback_location: root_path, alert: "Welcome to rubynas #{@user.name} !"
    else
      messages = @user.errors.full_messages.map{ |line| '- ' + line }
      messages << ""
      messages << "# Username must be the combination of alphabets and numbers"
      messages << "# The length of the Username must be in 20 characters"
      messages << "# The length of the Password must be in 6~20 characters"
      render js: "alert(\"#{messages.join('\n')}\");"
    end
  rescue
    render js: "alert('- Failed to signup');"
  end

  def update
    if !User.authenticate(@user.name, params[:old_password])
      render js: "alert('- Wrong password');"
    elsif User.authenticate(@user.name, params[:password])
      render js: "alert('- Please use the password different from the previous one');"
    elsif @user.update_attributes({ password: params[:password], password_confirmation: params[:password_confirmation]})
      redirect_back fallback_location: root_path, alert: "- Succeeded to change password"
    else
      messages = @user.errors.full_messages.map{ |line| '- ' + line }
      messages << ""
      messages << "# The length of the Password must be in 6~20 characters"
      render js: "alert(\"#{messages.join('\n')}\");"
    end
  rescue
    render js: "alert('- Failed to change password');"
  end

  def destroy
    if !User.authenticate(@user.name, params[:password])
      render js: "alert('- Wrong password');"
    else
      @user.destroy
      if @user.destroyed?
        FileUtils.rm_rf "nas/#{@user.name}"
        redirect_back fallback_location: root_path, alert: "- Succeeded to unregister"
      else
        render js: "alert('- Failed to unregister');"
      end
    end
  rescue
    render js: "alert('- Failed to unregister');"
  end

  private

  def permitted_params_user
    return params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def require_existing_user
    unless current_user
      render js: "alert('- Please signin to destroy the user');"
    else
      if current_user.admin? && params[:name] != current_user.name.to_s
        @user = User.find_by_name params[:name]
      else
        @user = current_user
      end
    end
  rescue ActiveRecord::RecordNotFound
    render js: "alert('- Failed to find the user');"
  end

  def filter_password_params
    params.except(:old_password, :password, :password_confirmation)
  end
end
