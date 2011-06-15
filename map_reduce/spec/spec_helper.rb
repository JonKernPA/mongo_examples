require 'rubygems'
require 'mongo_mapper'
cnx = MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017)
MongoMapper.database = 'mongo_demos'
