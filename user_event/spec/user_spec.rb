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
    
    @fred = Factory(:user, :name => "Fred")
    @fred.should_not be_nil
    @harry = Factory(:user, :name => "Harry")
    @sally = Factory(:user, :name => "Sally")
    @jared = Factory(:user, :name => "Jared")
    @martha = Factory(:user, :name => "Martha")

    @event = Factory(:event, :title => "Code Retreat Timbuktoo", :user => @fred)
    @event_2 = Factory(:event, :title => "Financial Regulation Made Easy")
    
    Factory(:event, :title => "Code Retreat Cleveland", 
                 :date => dummy_date, :user => @harry)
    Factory(:event, :title => "Code Retreat The Boat", 
                 :date => dummy_date, :user => @sally)

    Event.count.should == 4
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
    puts "\n\nEVENTS"
    events = Event.all(:order => 'title').each {|e| puts e}
    puts "\n\nUSERS"
    User.all(:order => 'name').each {|u| puts "#{u}"}
  end
  
end

