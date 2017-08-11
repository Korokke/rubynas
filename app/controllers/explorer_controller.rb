class ExplorerController < ApplicationController
  # Show User Page
  def show
    @dirpath = "nas/#{params[:name]}"
  end

  # Open File or Directory
  def open
    path = "nas/#{params[:name]}/#{params[:path]}"
    path << ".#{params[:format]}" if params[:format]
    if File.file? path
      send_file path, type: Mime::Type.lookup_by_extension(params[:format]).to_s
    elsif File.directory? path
      @dirpath = path
      render "dir"
    else
      raise ActionController::RoutingError.new("Not Found")
    end
  end

  def upload
    if params[:files]
      file = params[:files][:file]
      path = File.join(Rails.root, "nas/#{params[:name]}/#{params[:path]}", file.original_filename)
      if File.exist? path
        render js: "alert('file already exist');"
      else
        File.open(path, "wb") do |f|
          f.write(file.read)
        end
        redirect_back fallback_location: "users/index"
      end
    else
      render js: "alert('select file');"
    end
  end

  def newfolder
    begin
      Dir.mkdir "nas/#{params[:name]}/#{params[:path]}/#{params[:dirname]}"
      redirect_back fallback_location: "users/index"
    rescue Exception => er
      render js: "alert('#{er.class} /// #{er.message}')"
    end
  end
end
