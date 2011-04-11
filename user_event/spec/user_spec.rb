$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../app/model")
require 'rubygems'
require 'mongo_mapper'
require 'event'
require 'user'

cnx = MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017)
MongoMapper.database = 'mongo_demos'

describe User do
  before :all do
    Event.destroy_all
    User.destroy_all
    Event.count.should == 0
    User.count.should == 0
    
    @fred = User.create(:name => "Fred")
    @fred.should_not be_nil
    @harry = User.create(:name => "Harry")
    @sally = User.create(:name => "Sally")
    @jared = User.create(:name => "Jared")
    @martha = User.create(:name => "Martha")

    @event = Event.create(:title => "Code Retreat in Timbuktoo", :user => @fred)
    @event_2 = Event.create(:title => "Financial Regulation Made Easy", :user => @sally)

    Event.count.should == 2
    User.count.should == 5
  end

  it "should list the events I have authored" do
    @fred.events.size.should > 0
    @sally.events.size.should > 0
  end
  
  it "should list the events I am attending" do
    [@fred, @harry].each {|u| @event.attending(u)}
    @fred.attending.count.should > 0
  end
  
  it "should list the events I am interested in" do
    @event.interested_in(@jared)
    @event.interested_in(@sally)
    @jared.interested_in.count.should > 0
    @sally.interested_in.count.should > 0
  end
  
  it "should list the events that I like" do
    @event.likes << @martha
    @event.likes.size.should > 0
  end

  it "should allow me to add an event I like" do
    @fred.likes_event(@event_2)
    @event_2.likes.size.should > 0
    @fred.likes.count.should > 0
  end

  after :all do
    puts "EVENTS"
    events = Event.all
    events.each {|e| puts e}
    puts "USERS"
    users = User.all(:order => 'name')
    users.each {|u| puts "#{u.id} #{u}"}
  end
  
end

