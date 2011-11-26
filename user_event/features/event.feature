Feature: Events are date-specific activities that are owned by a User.
  Users can also register to attend events, or note their interest and like
  of events.

Background: clean User & Event database
	Given a clean database
	
Scenario: Create an Event
  Given A User "Fred"
  When "Fred" creates "CodeRetreat Philly" on "06/01/2011"
  And tags the current event with "CodeRetreat"
  Then We should see the "CodeRetreat Philly" event
  And it should be owned by "Fred"
  And it should be on "06/01/2011"

Scenario: Sort Events by Date
  Given A set of events
  When I display the events
  Then I should see them sorted by latest date first

Scenario: Sort Events by Date per User
  Given A set of events
  When I display the events for "Fred"
  Then I should see them sorted by latest date first

