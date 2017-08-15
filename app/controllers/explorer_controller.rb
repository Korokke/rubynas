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
  rescue
    flash[:alert] = "- Failed to open path : #{path}"
    redirect_to root_path
  end

  def upload
    if !params[:files]
      render js: "alert('- Please select any file');"
    else
      file = params[:files][:file]
      path = File.join(Rails.root, "nas/#{params[:name]}/#{params[:path]}", file.original_filename)
      if File.exist? path
        render js: "alert('- The file name already exists');"
      else
        File.open(path, "wb") do |f|
          f.write(file.read)
        end
        redirect_back fallback_location: root_path, alert: "- Succeeded to save file : #{file.original_filename}"
      end
    end
  rescue
    render js: "alert('- The file name(or path) is invalid');"
  end

  def newfolder
    if params[:dirname].empty?
      render js: "alert('- Please enter the folder name');"
    else
      Dir.mkdir "nas/#{params[:name]}/#{params[:path]}/#{params[:dirname]}"
      redirect_back fallback_location: root_path, alert: "- Succeeded to make folder : #{params[:dirname]}"
    end
  rescue SystemCallError
    messages = []
    messages << "- The folder name(or path) is invalid or already exists"
    messages << ""
    messages << "# The length of whole path must be in #{260 - File.join(Rails.root, 'nas', '').length} characters"
    messages << %(# The folder name cannot include \ / : * ? " < > |)
    render js: "alert('#{messages.join('\n')}');"
  rescue
    render js: "alert('- Failed to make folder');"
  end

  def delete
    if !params[:selected]
      render js: "alert('- Please select any file or folder');"
    else
      path = "nas/#{params[:name]}/#{params[:path]}"
      path << ".#{params[:format]}" if params[:format]
      # Check validate
      params[:selected].each do |t|
        unless File.exist? File.join(path, t)
          unless Dir.exist? File.join(path, t)
            render js: "alert(\"- Invalid folder : #{t}\");"
            return
          end
          render js: "alert(\"- Invalid file : #{t}\");"
          return
        end
      end
      messages = []
      messages << "- Succeeded to delete objects :"
      count = 0
      params[:selected].each do |t|
        FileUtils.rm_rf File.join(path, t)
        count += 1
        if count < 10
          messages << t
        end
      end
      messages << "\\n... #{count - 10} files or folders more" if count > 10
      redirect_back fallback_location: root_path, alert: messages.join('\n')
    end
  rescue
    render js: "alert('- Failed to delete');"
  end

  def rename
    path = "nas/#{params[:name]}/#{params[:path]}"
    path << ".#{params[:format]}" if params[:format]
    if !params[:selected]
      render js: "alert('- Please select a file or folder');"
    elsif params[:newname].empty?
      render js: "alert('- Please enter the new name');"
    elsif !File.exist?(path)
      unless Dir.exist?(path)
        render js: "alert(\"- Invalid folder : #{path.split('/')[-1]}\");"
      else
        render js: "alert(\"- Invalid file : #{path.split('/')[-1]}\");"
      end
    else
      File.rename(path, File.join(path.split('/')[0..-2].join('/'), params[:newname]))
      redirect_back fallback_location: root_path,
        alert: "- Succeeded to rename folder : \\nold : #{path.split('/')[-1]}\\nnow : #{params[:newname]}"
    end
  rescue
    render js: "alert('- Failed to rename');"
  end
end
