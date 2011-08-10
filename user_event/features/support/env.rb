$LOAD_PATH << File.expand_path('../../../app/model' , __FILE__)
require 'user_profile'
require 'user'
require 'event'
require 'spec/factories/events.rb'
require 'spec/factories/users.rb'
# require 'spec/factories/profile.rb'
load 'config/mongo_db.rb'
