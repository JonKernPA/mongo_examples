require 'rubygems'
require 'mongo'
require 'mongo_mapper'

MongoMapper.connection = Mongo::Connection.new('localhost', 27017, :pool_size => 5)
MongoMapper.database = "mongo_demos"

class User
  include MongoMapper::Document
  
  key :name, String, :required => true
  
  def to_s
    name
  end
end

User.destroy_all
u1 = User.create(:name => "Fred")
puts "Initial user #{u1} should be valid: #{u1.valid?}"
#=>Initial user Fred should be valid: true

u2 = User.create(:name => "Fred")
puts "Dupe user #{u2} should NOT be valid: #{u2.valid?}"
# !!! FAILS !!!
#=>Dupe user Fred should NOT be valid: true

User.destroy_all
puts "Add unique index on name and try again!"
#=>Add unique index on name and try again!

User.ensure_index([[:name,1]], :unique => true)
u1 = User.create(:name => "Fred")
puts "Initial user #{u1} should be valid: #{u1.valid?}"
#=>Initial user Fred should be valid: true

u2 = User.create(:name => "Fred")
puts "Dupe user #{u2} should NOT be valid: #{u2.valid?}"
# !!! FAILS !!!
#=>Dupe user Fred should NOT be valid: true

puts "Adding email to User class, demanding uniqueness via the key"
#=>Adding email to User class, demanding uniqueness via the key

class User
  include MongoMapper::Document
  
  key :email, String, :required => true, :unique => true
  
  def to_s
    "#{name}: #{email}"
  end
end

u1 = User.create(:name => "Harry", :email => "harry@example.com")
puts "Initial user #{u1} should be valid: #{u1.valid?}"
#=>Initial user Harry: harry@example.com should be valid: true

u2 = User.create(:name => "Sally", :email => "harry@example.com")
puts "Dupe user #{u2} should NOT be valid: #{u2.valid?}"
# --- SUCCESS ---
#=>Dupe user Sally: harry@example.com should NOT be valid: false

