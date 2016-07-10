require 'yaml'

class Configuration
  def self.host
    config = Configuration.read_config
    return config["config"]["host"]
  end
  
  def self.read_config
  	return config = YAML.load_file("config.yaml")
  end
end
