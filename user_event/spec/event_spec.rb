$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../app/model")
require 'rubygems'
require 'mongo_mapper'
require 'event'
require 'user'
require 'factories/events.rb'
require 'factories/users.rb'

cnx = MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017)
MongoMapper.database = 'mongo_demos'

def dummy_date
  secs_in_day = 24*60*60
  Time.now + (rand(60)*secs_in_day - 30)
end

describe Event do
  context "basic object creation" do

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
      evt.attendees.should include(@fred.id, @harry.id)
    end
  
    it "should track interested" do
      expect {
        @event.interested_in(@jared)
        @event.interested_in(@sally)
      }.to change {@event.interested.size}.by(2)    
    end

    it "should not add an interested user more than once" do
      expect {
        @event.interested_in(@jared)
        @event.interested_in(@sally)
      }.to change {@event.interested.size}.by(0)    
    end
  
    it "should allow 'likes'" do
      expect {
        @event_2.likes << @martha
      }.to change {@event_2.likes.size}.by(1)
    end
  
    after :all do
      puts "\n\nEVENTS"
      events = Event.all(:order => 'title').each {|e| puts e}
      puts "\n\nUSERS"
      User.all(:order => 'name').each {|u| puts "#{u}"}
    end
  end
  
  describe "#list_all" do
    it "should show each event, ordered by date" do
      response = Event.list_all
      response.should_not be_empty
      response.class.should == Array
      response.size.should == Event.count + 2 #for title and column header
      last = Date.parse(response[2][0..10])
      response[3..response.size].each do |r|
        date = Date.parse(r[0..10])
        date.should <= last
        last = date
      end
      # Yes, you should not output stuff as part of your tests, but this *is* our UI :-)
      puts response
    end
    it "should show each event for a given user" do
      a_user = User.find_by_name_or_create("Fred")
      response = Event.list_all(a_user)
      response.should_not be_empty
      response.class.should == Array
      response.size.should == Event.count(:user => a_user) + 2
      # Yes, you should not output stuff as part of your tests, but this *is* our UI :-)
      puts response
    end
  end
  
end
