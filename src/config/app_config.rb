class AppConfig
  def self.production?
    !ENV.include? PRODUCTION_VARIABLE
  end

  def self.events_port
    ENV[EVENTS_PORT].nil? ? 9090 : ENV[EVENTS_PORT].to_i
  end

  def self.clients_port
    ENV[CLIENTS_PORT].nil? ? 9099 : ENV[CLIENTS_PORT].to_i
  end

  private
  PRODUCTION_VARIABLE = 'TEST'.freeze
  EVENTS_PORT = 'eventListenerPort'.freeze
  CLIENTS_PORT = 'clientListenerPort'.freeze
end
