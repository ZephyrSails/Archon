# This file is used by Rack-based servers to start the application.
ENV['server_mode'] = '1'

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application
