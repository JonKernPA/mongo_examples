require 'factory_girl'
def dummy_word(len=6)
  ('a'..'z').to_a.shuffle[0..len].join.capitalize
end

def dummy_date
  secs_in_day = 24*60*60
  Time.now + (rand(60)*secs_in_day - 30)
end
Factory.define :event do |e|
  e.title "#{dummy_word} #{dummy_word 3} #{dummy_word 10}"
  e.date  dummy_date
end
