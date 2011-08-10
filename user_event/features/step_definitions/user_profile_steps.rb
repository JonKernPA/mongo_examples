Given /^a Profile "([^"]*)" with color "([^"]*)"$/ do |name, color|
  profile = UserProfile.create(:name => name, :favorite_color => color)
end

When /^he assigns Profile "([^"]*)"$/ do |profile_name|
  profile = UserProfile.find_by_name(profile_name)
  @user.profile = profile
end

Then /^he should have a Profile "([^"]*)"$/ do |profile_name|
  profile = UserProfile.find_by_name(profile_name)
  profile.should_not be_nil
  @user.profile.name.should == profile.name
end
