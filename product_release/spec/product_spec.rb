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
        Release.new(:major=>"0", :minor=>"1", :released_at => 10.days.ago),
        Release.new(:major=>"0", :minor=>"2", :released_at =>  5.days.ago),
        Release.new(:major=>"0", :minor=>"3", :released_at =>  4.days.ago)
        ]
      )
    }.to change {Product.count}.by(1)
    expect {
      Product.create(:name => "Bopper", :releases =>[
        Release.new(:major=>"1", :minor=>"1", :released_at => 10.days.ago),
        Release.new(:major=>"1", :minor=>"2", :released_at =>  9.days.ago)
        ]
      )
    }.to change {Product.count}.by(1)
  end
  
  it "should allow querying by age" do
    list = Product.all(:conditions => {"releases.released_at" => {"$lt" => 5.days.ago}})
    list.size.should == 2
    list = Product.all(:conditions => {"releases.released_at" => {"$lt" => 25.days.ago}})
    list.count.should == 0
    list = Product.where( :"releases.released_at".lt => 6.days.ago ).map(&:releases).flatten.select { |release| release.released_at < 6.days.ago }
    list.size.should == 3
  end
  
  after :all do
    products = Product.sort(:name)
    products.each {|p| puts p}
    # products.each {|p| puts p.to_json}
  end
  
end

