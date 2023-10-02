# frozen_string_literal: true

require "uri"
require "base64"

class RedirectProxy
  def call(env)
    request = Rack::Request.new(env)

    # abort unless request.params["state"] is passed
    return [400, {}, ["Bad Request: Missing state parameter"]] unless request.params["state"]

    # Eg. https://your-puma-dev-app.test or https://your-staging-environment.com etc
    origin_uri = URI.parse(Base64.strict_decode64(request.params["state"]))

    # We redirect with the path / query string from the incoming request but replace the
    # host, scheme, and port with the origin_uri from the state parameter.
    redirect_uri = URI.parse(request.url)
    redirect_uri.scheme = origin_uri.scheme
    redirect_uri.host = origin_uri.host
    redirect_uri.port = origin_uri.port

    [301, { "Location" => redirect_uri.to_s }, []]
  rescue ArgumentError => e
    if e.message == "invalid base64"
      [400, {}, ["Bad Request: State parameter must be a valid Base64 encoded string"]]
    else
      raise
    end
  rescue URI::InvalidURIError
    [400, {}, ["Bad Request: State parameter must be a valid Base64 encoded URI"]]
  end
end
