class User
  include MongoMapper::Document

  key :name
  many :events
end
