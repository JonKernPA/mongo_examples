require 'rubygems'
require 'mongo_mapper'

class Event
  include MongoMapper::Document

  key :title, :required => true
  key :date, Time, :default => Time.now

  key :user_id
  belongs_to :user
  
  # One way to do one-to-many association...
  key :attendees, Set
  key :interested, Set
  
  # A way to do many-to-many associations...
  key :like_ids, Array
  many :likes, :class_name => 'User', :in => :like_ids
  
  # Events can be tagged
  key :tag_ids, Array
  many :tags, :in => :tag_ids

  def attending(a_user)
    # self.push_uniq(:attendees => a_user.id)
    attendees << a_user.id
    save
  end

  def interested_in(a_user)
    interested << a_user.id
    save
  end
  
  def to_summary
    text = "%s %s (%s) #: %d, Int: %d Likes: %d" % [date.strftime("%d %b %Y"), title, user.name, attendees.size, interested.size, likes.size]
  end
  
  def to_s
    text = "\n"
    text += "-"* 50
    text += "\n#{title} -- by #{user.name}"
    text += "\n%12s %12s %8s" % ["Attendees", "Interested", "Likes"]
    text += "\n%8d %12d %10d" % [attendees.size, interested.size, likes.size]
    if attendees.size > 0
      text += "\n  ATTENDEES:"
      attendees.each {|id| text += "\n  -#{User.find(id).name}"}
    else
      text += "\n  NO ATTENDEES YET -- get out and market this event!"
    end

    if interested.size > 0
      text += "\n  INTERESTED:"
      interested.each {|id| text += "\n  -#{User.find(id).name}"}
    else
      text += "\n  NO FOLKS INTERESTED YET -- change the event or get out and market this event!"
    end
    text
  end
  
  def self.list_all(a_user=nil)
    response = []
    response << "%s %s %s" % ["*"*10, "LIST OF EVENTS", "*"*10] 
    response << "%6s %15s               %s" % ["Date", "TITLE", "Attendees/Interested/Likes"] 
    events = nil
    if a_user.nil?
      events = Event.all(:order => 'date desc')
    else
      events = Event.where(:user => a_user).all.sort(:date.desc)
    end
    events.each {|e| response << e.to_summary}
    response
  end
end
