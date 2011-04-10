class User
  include MongoMapper::Document

  key :name, :required => true
  
  many :events
end
