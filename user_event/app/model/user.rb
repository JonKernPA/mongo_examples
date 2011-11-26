require 'rubygems'
require 'mongo_mapper'

class User
  include MongoMapper::Document

  key :name, String, :required => true
  key :dob, Time
  key :dob_ms, Integer
  key :dob_days, Integer
  
  key :profile, UserProfile
  
  many :events
  belongs_to :group
  
  # callbacks
  after_create :store_dob_in_ms
  # before_save :show_me_bs
  
  scope :younger_than, lambda {|age|
    born_after_date = (age.to_i).years.ago - 2.days
    born_after = Date.parse(born_after_date.to_s) - User.epoch
    puts "Born After? #{born_after_date.strftime("%b %d %Y")} / #{born_after} days"
    where(:dob_days.gte => born_after.to_i)
  }
  
  def self.epoch
    Date.parse("01/01/1900")
  end

  def age
    now = Time.now.utc.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end
  
  def likes
    Event.where(:like_ids => id).all
  end
  
  def attending
    Event.where(:attendees => id).all
  end

  def interested_in
    Event.where(:interested => id).all
  end  
  
  def likes_event(event)
    event.likes << self
    event.save!
  end
  
  def to_s
    text = "\n" + "- "*25
    text += "\n#{name.upcase}"
    text += " (Age: #{age})" unless dob.nil?
    if events.size > 0
      text += "\n  YOUR EVENTS:"
      events.each {|e| text += "\n    #{e.to_summary}"}
    else
      text += "\n    You have no events. Click *here* to get started!"
    end
    text += "\n  You like #{likes.count} events" if likes.count > 0
    text += "\n  You are attending #{attending.count} events" if attending.count > 0
    text += "\n  You are interested in #{interested_in.count} events" if interested_in.count > 0
    text
  end
  
  # private
  def show_me_bc
    show_me("before_create")
  end
  def show_me_bs
    show_me("before_save")
  end
  def show_me_ac
    show_me("after_create")
  end
  
  def show_me(callback)
    puts "#{callback}: name #{name}, dob #{dob}, dob_ms #{dob_ms}"
  end
  def store_dob_in_ms
    if dob
      self.dob_days = (Date.parse(dob.to_s) - User.epoch).to_i
      ms = dob.strftime("%s").to_i
      # puts "dob = '#{dob.strftime("%b %d, %Y")}' or #{ms}"
      self.dob_ms = ms
      save!
    end
  end
end
