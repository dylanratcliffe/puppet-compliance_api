require 'json'
require 'puppet'
require 'net/http'
require 'uri'

Puppet::Reports.register_report(:compliance_api) do
  desc "Sends reports to compliance_api"

  configfile   = File.join([File.dirname(Puppet.settings[:config]), "compliance_api.yaml"])
  raise(Puppet::ParseError, "compliance_api report config file #{configfile} not readable") unless File.exist?(configfile)
  config       = YAML.load_file(configfile)
  queue        = config['queue'] || 'reports'
  uri          = URI("#{config['uri']}/q/#{queue}")
  HTTP         = Net::HTTP.new(uri.host, uri.port)
  REQUEST      = Net::HTTP::Post.new(uri.request_uri)

  def process
    # TODO: Use certificate auth

    REQUEST.body = self.to_json
    HTTP.request(REQUEST)

  end
end
