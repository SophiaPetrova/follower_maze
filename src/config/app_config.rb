class AppConfig
  def self.is_production?
    !ENV.include? PRODUCTION_VARIABLE
  end

  private
  PRODUCTION_VARIABLE = 'TEST'.freeze
end
