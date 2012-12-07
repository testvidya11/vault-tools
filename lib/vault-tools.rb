require "vault-tools/version"

module Vault
  def self.require
    Kernel.require 'bundler'
    STDERR.puts "Loading #{ENV['RACK_ENV']} environment..."
    Bundler.require :default, ENV['RACK_ENV'].to_sym
  end
end

require 'sinatra/base'

require 'vault-tools/sinatra_helpers/html_serializer'
require 'vault-tools/log'
require 'vault-tools/web'
