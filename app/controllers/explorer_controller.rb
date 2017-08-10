class ExplorerController < ApplicationController
  def show
    @render_flag = false
    @dirpath = "nas/#{params[:name]}/"
  end

  def dir
    @render_flag = true
    path = "nas/#{params[:name]}/#{params[:dirs]}/"
    if Dir.exist?(Rails.root + path)
      @dirpath = path
      render "show"
    else
      raise ActionController::RoutingError.new("Not Found")
    end
  end
end
