require 'json'
require 'puppet'
require 'net/http'
require 'uri'

Puppet::Reports.register_report(:kriterion) do
  desc "Sends reports to kriterion"

  configfile   = File.join([File.dirname(Puppet.settings[:config]), "kriterion.yaml"])
  raise(Puppet::ParseError, "kriterion report config file #{configfile} not readable") unless File.exist?(configfile)
  config       = YAML.load_file(configfile)
  queue        = config['queue'] || 'reports'
  uri          = URI("#{config['uri']}/q/#{queue}")
  HTTP         = Net::HTTP.new(uri.host, uri.port)
  REQUEST      = Net::HTTP::Post.new(uri.request_uri)

  def process
    # TODO: Use certificate auth

    REQUEST.body = URI.escape("value=#{self.to_json}").gsub(';','%3B')
    HTTP.request(REQUEST)

  end
end
