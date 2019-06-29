# frozen_string_literal: true

# Alfonso X module
module AlfonsoX
  ROOT_PATH = "#{__dir__}/../.."
  CONFIG_PATH = "#{AlfonsoX::ROOT_PATH}/config"
  LIB_PATH = "#{AlfonsoX::ROOT_PATH}/lib"
  RESOURCES_PATH = "#{AlfonsoX::ROOT_PATH}/resources"
  DICTIONARIES_PATH = "#{AlfonsoX::RESOURCES_PATH}/dictionaries"
  DEFAULT_CONFIGURATION_PATH = "#{AlfonsoX::CONFIG_PATH}/config/default.yml"

  # Configuration file name in repositories that use this tool
  CONFIG_FILE_NAME = '.alfonsox.yml'

  # Alfonso X repository URL
  REPOSITORY_URL = 'https://github.com/diegojromerolopez/alfonsox'
end
