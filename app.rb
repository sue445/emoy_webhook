ENV["RACK_ENV"] ||= "development"
Bundler.require(:default, ENV["RACK_ENV"])

require "rollbar/middleware/sinatra"
require "sinatra/custom_logger"
require "logger"

class App < Sinatra::Base
  use Rollbar::Middleware::Sinatra

  helpers Sinatra::CustomLogger

  configure do
    debug_logging = ENV["DEBUG_LOGGING"] == "true"
    logger = Logger.new(STDOUT)
    logger.level = debug_logging ? Logger::DEBUG : Logger::INFO

    set :logger, logger
  end

  get "/" do
    "It works"
  end

  post "/" do
    params = JSON.parse(request.body.read)

    case params["type"]
    when "url_verification"
      challenge = params["challenge"]
      { challenge: challenge }.to_json
    else
      raise "Unknown event"
    end
  end
end
