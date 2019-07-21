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
    json = request.body.read
    payload = JSON.parse(json)

    logger.debug { "payload=#{payload}, json=#{json}" }

    case payload["type"]
    when "url_verification"
      challenge = payload["challenge"]
      { challenge: challenge }.to_json
    when "event_callback"
      event = payload["event"]
      case event["type"]
      when "emoji_changed"
        case event["subtype"]
        when "add"
          emoji_name = event["name"]
          App.post_slack("New emoji is add :#{emoji_name}: `:#{emoji_name}:`")
        end
      else
        raise "Unknown callback event: #{event["type"]}"
      end
      ""
    else
      raise "Unknown event: #{payload["type"]}"
    end
  end

  def self.post_slack(message)
    notifier = Slack::Notifier.new(ENV["SLACK_WEBHOOK_URL"])

    options = {
      attachments: [
        {
          fallback: message,
          text:     message,
          color:    "good",
        },
      ],
    }

    notifier.ping(nil, options)
  end
end
