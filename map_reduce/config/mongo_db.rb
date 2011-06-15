##### MONGODB SETTINGS #####
MongoMapper.connection = Mongo::Connection.new('localhost', 27017, :pool_size => 5)
MongoMapper.database = "product_release-development"
