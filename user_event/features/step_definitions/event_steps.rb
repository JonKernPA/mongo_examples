Given /^a clean database$/ do
  User.destroy_all
  Event.destroy_all
end
Given /^A User "([^"]*)"$/ do |user_name|
  user = User.create(:name => user_name)
end

When /^"([^"]*)" creates "([^"]*)" on "([^"]*)"$/ do |user_name, title, date|
  author = User.find_by_name(user_name)
  event = Event.create(:user => author, :title => title, :date => date)
end

Then /^We should see the "([^"]*)" event$/ do |title|
  @event = Event.where(:title => title).first
  @event.should_not be_nil
end

Then /^it should be owned by "([^"]*)"$/ do |user_name|
  author = User.find_by_name(user_name)
  @event.user.should == author
end

Then /^it should be on "([^"]*)"$/ do |date|
  @event.date.strftime("%m/%d/%Y").should == date
end

def dummy_word(len=6)
  ('a'..'z').to_a.shuffle[0..len].join.capitalize
end

Given /^A set of events$/ do
  secs_in_day = 24*60*60
  fred = User.find_or_create_by_name("fred")
  (1..10).each do 
    Event.create(:title=>"#{dummy_word} #{dummy_word 3} #{dummy_word 10}", :date => Time.now + rand(60)*secs_in_day, :user => fred)
  end
  harry = User.find_or_create_by_name("harry")
  (1..10).each do 
    Event.create(:title=>"#{dummy_word} #{dummy_word 3} #{dummy_word 10}", :date => Time.now + rand(60)*secs_in_day, :user => harry)
  end
  Event.count.should == 20
end

When /^I display the events$/ do
  @response = Event.list_all
  puts @response
end

Then /^I should see them sorted by latest date first$/ do
  first = Date.parse(@response.third[0..10])
  last = Date.parse(@response.last[0..10])
  first.should > last  
end