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
    # puts "\n\nEVENTS"
    # events = Event.all(:order => 'title').each {|e| puts e}
    # puts "\n\nUSERS"
    # User.all(:order => 'name').each {|u| puts "#{u}"}
  end
  
  context "dealing with mongodb time epoch error" do
    before :all do
      # puts "*"*50
      User.destroy_all
      expect {
        [1,10,20,30,40,50,100].each do |age|
          dob = Date.today - age.years
          #Factory(:user, :name => "#{age} years old", :dob => dob)
          User.create(:name => "#{age} years old", :dob => dob)
        end
      }.to change {User.count}
      
      # Lets create some kid's ages in terms of months
      expect {
        [1,10,20,30,40].each do |age|
          dob = Date.today - age.months
          #Factory(:user, :name => "#{age} years old", :dob => dob)
          User.create(:name => "#{age} months old", :dob => dob)
        end
      }.to change {User.count}
      
    end

    # These all fail due to MongoDB bug
    # it "should show users by age" do
    #   User.count(:dob.gte => 11.years.ago).should == 5
    #   User.count(:dob.gte => 21.years.ago).should == 4
    #   User.count(:dob.gte => 31.years.ago).should == 3
    #   User.count(:dob.gte => 41.years.ago).should == 2
    #   User.count(:dob.gte => 51.years.ago).should == 1
    # end
    
    it "should allow querying against dob_days" do
    end

    it "should show users younger than given ages" do
      # User.all.each {|u| puts "#{u.name} #{u.dob_ms}"}
      User.count(:dob_ms.gte => 11.years.ago.strftime("%s").to_i).should == 2+5
      User.count(:dob_ms.gte => 21.years.ago.strftime("%s").to_i).should == 3+5
      User.count(:dob_ms.gte => 31.years.ago.strftime("%s").to_i).should == 4+5
      User.count(:dob_ms.gte => 41.years.ago.strftime("%s").to_i).should == 5+5
      User.count(:dob_ms.gte => 51.years.ago.strftime("%s").to_i).should == 6+5
    end
    
    it "should show users older than given ages" do
      # User.all.each {|u| puts "#{u.name} #{u.dob_ms}"}
      User.count(:dob_ms.lte =>  9.years.ago.strftime("%s").to_i).should == 6
      User.count(:dob_ms.lte => 19.years.ago.strftime("%s").to_i).should == 5
      User.count(:dob_ms.lte => 29.years.ago.strftime("%s").to_i).should == 4
      User.count(:dob_ms.lte => 39.years.ago.strftime("%s").to_i).should == 3
      User.count(:dob_ms.lte => 49.years.ago.strftime("%s").to_i).should == 2
    end
    
    it "should show users between ages" do
      User.count(:dob_ms.lte =>  0.years.ago.strftime("%s").to_i,
                 :dob_ms.gte =>  3.years.ago.strftime("%s").to_i).should == 5
      User.count(:dob_ms.lte =>  0.years.ago.strftime("%s").to_i,
                 :dob_ms.gte => 11.years.ago.strftime("%s").to_i).should == 7
      User.count(:dob_ms.lte => 19.years.ago.strftime("%s").to_i,
                 :dob_ms.gte => 31.years.ago.strftime("%s").to_i).should == 2
      User.count(:dob_ms.lte => 19.years.ago.strftime("%s").to_i,
                 :dob_ms.gte =>101.years.ago.strftime("%s").to_i).should == 5
    end

    it "should show users younger than ages" do
      User.younger_than(  1).count.should == 3
      User.younger_than(  2).count.should == 4
      User.younger_than(  3).count.should == 5
      User.younger_than( 20).count.should == 3+5
      User.younger_than( 30).count.should == 4+5
      User.younger_than( 40).count.should == 5+5
      User.younger_than( 50).count.should == 6+5
      User.younger_than(100).count.should == 7+5
    end
    
    after :all do
    end
    
  end
  
end

