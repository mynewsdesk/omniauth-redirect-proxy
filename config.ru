# frozen_string_literal: true

require "bundler/setup"

require_relative "lib/redirect_proxy"

run RedirectProxy.new
