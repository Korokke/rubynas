require 'active_support'

module ApplicationHelper
  def loghelper
    date = Time.now.strftime("%Y%m%d")
    @@logger ||= Logger.new("#{Rails.root}/log/requests/#{date}.log")
    unless ActiveSupport::Logger.logger_outputs_to?(@@logger, date)
      @@logger = Logger.new("#{Rails.root}/log/requests/#{date}.log")
    end
  end
end
