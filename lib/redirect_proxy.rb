# frozen_string_literal: true

require "uri"
require "base64"

class RedirectProxy
  def call(env)
    request = Rack::Request.new(env)

    # Eg. https://your-puma-dev-app.test or https://your-staging-environment.com etc
    origin_uri = URI.parse(Base64.decode64(request.params["state"]))

    # We redirect with the path / query string from the incoming request but replace the
    # host, scheme, and port with the origin_uri from the state parameter.
    redirect_uri = URI.parse(request.url)
    redirect_uri.scheme = origin_uri.scheme
    redirect_uri.host = origin_uri.host
    redirect_uri.port = origin_uri.port

    [301, { "Location" => redirect_uri.to_s }, []]
  end
end
