$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../app/model")
require 'rubygems'
require 'mongo_mapper'
require 'product'
require 'release'
cnx = MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017)
MongoMapper.database = 'mongo_demos'

describe Product do
  before :all do
    Product.destroy_all
  end
  
  it "should create product releases" do
    expect {
      Product.create(:name => "Zapper", :releases =>[
        Release.new(:major=>"0", :minor=>"1")]
      )
    }.to change {Product.count}.by(1)
  end
  
  after :all do
    products = Product.sort(:name)
    products.each {|p| puts p}
  end
  
end

