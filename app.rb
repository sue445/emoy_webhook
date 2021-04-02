ENV["RACK_ENV"] ||= "development"
Bundler.require(:default, ENV["RACK_ENV"])

require "rollbar/middleware/sinatra"
require "sinatra/custom_logger"
require "logger"
require_relative "./lib/cache"

class App < Sinatra::Base
  use Rollbar::Middleware::Sinatra

  helpers Sinatra::CustomLogger

  configure do
    debug_logging = ENV["DEBUG_LOGGING"] == "true"
    logger = Logger.new(STDOUT)
    logger.level = debug_logging ? Logger::DEBUG : Logger::INFO

    set :logger, logger
  end

  before do
    Redis.current = Redis.new(url: ENV["HEROKU_REDIS_TEAL_URL"] || ENV["REDIS_URL"])
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
          message = "A new emoji is added :#{emoji_name}: `:#{emoji_name}:`"

          if event["value"].start_with?("alias:")
            origin_emoji = event["value"].gsub(/^alias:/, "")
            message << " (alias of `:#{origin_emoji}:`)"
          end

          cache = Cache.new(message)
          unless cache.exists?
            App.post_slack(message)
            cache.set("1")
          end
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
