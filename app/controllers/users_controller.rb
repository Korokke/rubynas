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
      redirect_back fallback_location: "index"
    else
      messages = @user.errors.full_messages.map{ |line| '- ' + line }
      messages << ""
      messages << "# Username must be the combination of alphabets and numbers"
      messages << "# The length of the Username must be in 20 characters"
      messages << "# The length of the Password must be in 6~20 characters"
      render js: "alert(\"#{messages.join('\n')}\");"
    end
  end

  def update
    if User.authenticate @user.name, params[:old_password]
      if User.authenticate @user.name, params[:password]
        render js: "alert('- Please use the password different from the previous one');"
      else
        if @user.update_attributes({ password: params[:password], password_confirmation: params[:password_confirmation]})
          redirect_back fallback_location: "index"# , js: "alert('- Succeeded to updateg user');"
        else
          messages = @user.errors.full_messages.map{ |line| '- ' + line }
          messages << ""
          messages << "# The length of the Password must be in 6~20 characters"
          render js: "alert(\"#{messages.join('\n')}\");"
        end
      end
    else
      render js: "alert('- Wrong password');"
    end
  end

  def destroy
    if User.authenticate @user.name, params[:password]
      @user.destroy
      if @user.destroyed?
        FileUtils.rm_rf "nas/#{@user.name}"
        render js: "window.location = '#{root_path}'; alert('- Succeeded to destroy the user');"
      else
        render js: "alert('- Failed to destroy the user');"
      end
    else
      render js: "alert('- Wrong password');"
    end
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
