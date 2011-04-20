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

