$LOAD_PATH << File.expand_path('../../../app/model' , __FILE__)
require 'user'
require 'event'
require 'spec/factories/events.rb'
require 'spec/factories/users.rb'
load 'config/mongo_db.rb'
