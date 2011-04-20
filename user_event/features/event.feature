Feature: Events are date-specific activities that are owned by a User.
  Users can also register to attend events, or note their interest and like
  of events.

Scenario: Create an Event
  Given A User "Fred"
  When "Fred" creates "CodeRetreat Philly" on "06/01/2011"
  Then We should see the "CodeRetreat Philly" event
  And it should be owned by "Fred"
  And it should be on "06/01/2011"
