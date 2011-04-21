Factory.define :user do |u|
  u.name ('a'..'z').to_a.shuffle[0..7].join.capitalize
end
