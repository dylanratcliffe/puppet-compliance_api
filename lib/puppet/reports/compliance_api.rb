require 'json'
require 'puppet'
require 'net/http'

Puppet::Reports.register_report(:compliance_api) do
  desc "Sends reports to compliance_api"

  configfile = File.join([File.dirname(Puppet.settings[:config]), "compliance_api.yaml"])
  raise(Puppet::ParseError, "compliance_api report config file #{configfile} not readable") unless File.exist?(configfile)
  config       = YAML.load_file(configfile)
  queue        = config['queue'] || 'reports'
  REPORT_QUEUE = URI("#{config['uri']}/q/#{queue}")

  def process
    # TODO: Use certificate auth

    Net::HTTP.post(REPORT_QUEUE, "value=#{self.to_json}")

  end
end
