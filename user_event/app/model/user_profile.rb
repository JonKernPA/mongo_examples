require 'rubygems'
require 'mongo_mapper'

class UserProfile
  include MongoMapper::Document
  
  key :name, String
  key :favorite_color, String

end
