class AppConfig
  def self.production?
    !ENV.include? PRODUCTION_VARIABLE
  end

  private
  PRODUCTION_VARIABLE = 'TEST'.freeze
end
