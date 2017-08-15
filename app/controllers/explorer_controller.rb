class ExplorerController < ApplicationController
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
        render js: "alert('- The file name already exists');"
      else
        begin
          File.open(path, "wb") do |f|
            f.write(file.read)
          end
          redirect_back fallback_location: "users/index"
        rescue
          render js: "alert('- The file name(or path) is invalid');"
        end
      end
    else
      render js: "alert('- Please select any file');"
    end
  end

  def newfolder
    if params[:dirname].empty?
      render js: "alert('- Please enter the folder name');"
    else
      begin
        Dir.mkdir "nas/#{params[:name]}/#{params[:path]}/#{params[:dirname]}"
        redirect_back fallback_location: "users/index"
      rescue
        messages = []
        messages << "- The folder name(or path) is invalid or already exists"
        messages << ""
        messages << "# The length of whole path must be in #{260 - File.join(Rails.root, 'nas', '').length} characters"
        messages << %(# The folder name cannot include \ / : * ? " < > |)
        render js: "alert('#{messages.join('\n')}');"
      end
    end
  end

  def delete
    if params[:selected]
      path = "nas/#{params[:name]}/#{params[:path]}"
      path << ".#{params[:format]}" if params[:format]
      params[:selected].each do |t|
        FileUtils.rm_rf File.join(path, t)
      end
      redirect_back fallback_location: "users/index"
    else
      redirect_back fallback_location: "users/index"
    end
  end

  def rename
    if params[:selected]
      path = "nas/#{params[:name]}/#{params[:path]}"
      path << ".#{params[:format]}" if params[:format]
      File.rename(path, File.join(path.split('/')[0..-2].join('/'), params[:newname]))
      redirect_back fallback_location: "users/index"
    else
      redirect_back fallback_location: "users/index"
    end
  rescue
    redirect_back fallback_location: "users/index"
  end
end
