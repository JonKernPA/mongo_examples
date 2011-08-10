$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../app/model")
require 'rubygems'
require 'mongo_mapper'
require 'event'
require 'user'
require 'factories/events.rb'
require 'factories/users.rb'

cnx = MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017)
MongoMapper.database = 'mongo_demos'

describe User do
  before :all do
    User.destroy_all
    User.count.should == 0
    
    @fred = Factory(:user, :name => "Fred")
    @fred.should_not be_nil

    User.count.should == 1
  end

  it "should allow setting a profile" do
    profile = Profile.create( :favorite_color => "Red")
    @fred.profile = profile
    @fred.save!
    
    fred = User.find_by_name("Fred")
    fred.should_not be_nil
    fred.profile.should == "Red"
  end

  after :all do
  end
    
end

