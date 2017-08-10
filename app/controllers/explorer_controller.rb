class ExplorerController < ApplicationController
  def show
    @dirpath = "nas/#{params[:name]}/"
  end
  
  def dir
    path = "nas/#{params[:name]}/#{params[:dirs]}/"
    if Dir.exist?(Rails.root + path)
      @dirpath = path
      render "show"
    else
      raise ActionController::RoutingError.new("Not Found")
    end
  end
end
