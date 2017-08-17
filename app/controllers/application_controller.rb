class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  prepend_around_action :log_request

  include SessionsHelper
  include ApplicationHelper

  # started time | request method | url | ip | user | elapsed time | response code
  def log_request
    started = Time.now
    log = "#{started} | #{request.method} | #{request.fullpath} | #{request.remote_ip} | #{current_user ? current_user.name : '-'} | "
    begin
      yield
    ensure
      log << "#{Time.now - started} | #{response.status}"
      loghelper.info log
    end
  end
end
