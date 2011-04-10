$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../app/model")
require 'rubygems'
require 'mongo_mapper'
require 'event'
require 'user'

cnx = MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017)
MongoMapper.database = 'mongo_demos'

describe Event do
  
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

    @event = Event.create(:title => "Code Retreat Timbuktoo", :user => @fred)
    @event_2 = Event.create(:title => "Financial Regulation Made Easy")

    Event.count.should == 2
    User.count.should == 5
  end
  

  it "should be owned by a user" do
    @event.should_not be_nil
    @event.user.should == @fred
  end
  
  it "should allow an author to be assigned later" do
    @fred.events << @event_2
    @fred.save!
    @event_2.user.should == @fred
  end
  
  it "should track attendees" do
    expect {
      [@fred, @harry].each {|u| @event.attending(u)}
    }.to change {@event.attendees.size}.by(2)
    @event_2.attending(@fred)

    # Another way to check
    evt = Event.find_by_title("Code Retreat Timbuktoo")
    evt.should_not be_nil
    puts evt.inspect
    evt.attendees.should include(@fred.id, @harry.id)
  end
  
  it "should track interested" do
    expect {
      @event.interested_in(@jared)
      @event.interested_in(@sally)
    }.to change {@event.interested.size}.by(2)    
  end

  it "should not add interested user more than once" do
    expect {
      @event.interested_in(@jared)
      @event.interested_in(@sally)
    }.to change {@event.interested.size}.by(0)    
  end
  
  after :all do
    events = Event.all
    events.each {|e| puts e}
  end
  
end
