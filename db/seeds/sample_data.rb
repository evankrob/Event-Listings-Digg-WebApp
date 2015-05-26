['events', 'venues', 'occurrences'].each do |table|
   ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
   ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence where name='#{table}'")
 end
ActiveRecord::Base.connection.execute("VACUUM")

Venue.create( :id => 1, :name => "Goodnight's Comedy Club", :street => "861 West Morgan St", :city => "Raleigh", :state => "NC", :zip => "27603", :url => "http://www.goodnightscomedy.com/", :phone => '919.828.LAFF (5233)')
Venue.create( :id => 2, :name => "Pour House", :street => "224 S Blount St", :city => "Raleigh", :state => "NC", :zip => "27601", :url => "http://www.the-pour-house.com/", :phone => '919-821-1120')
Venue.create( :id => 3, :name => "PNC Arena", :street => "1400 Edwards Mill Rd", :city => "Raleigh", :state => "NC", :zip => "27607", :url => "http://www.thepncarena.com/", :phone => '(919) 861 - 2300')
Venue.create( :id => 4, :name => "Progress Energy Center for the Performing Arts", :street => "2 East South St", :city => "Raleigh", :state => "NC", :zip => "27601", :url => "http://www.progressenergycenter.com/", :phone => '919-996-8700')
Venue.create( :id => 5, :name => "Middle Creek High School", :street => "123 Middle Creek Park Avenue", :city => "Apex", :state => "NC", :zip => "27539", :url => "http://middlecreekhs.wcpss.net/", :phone => '919-773-3838')
Venue.create( :id => 6, :name => "Koka Booth Amphitheatre", :street => "8003 Regency Parkway", :city => "Cary", :state => "NC", :zip => "27518", :url => "http://boothamphitheatre.com/", :phone => '919.462.2052')

Category.create( :id => 1, :name => "Festival" )

Event.create( :id => 1, :name => "Michael Mack", :venue_id => 1, :category_id => 1, :approved => true, :url => "http://www.goodnightscomedy.com/", :description => "Michael Mack has appeared on America's Funniest People numerous times and is also a regular on XM Satellite Radio and on the Bob and Tom Radio Show.
He brilliantly uses music, light, impressions, and parodies to produce a show starting in fun and ending with the crowd coming out of their seats in amazement.")
Occurrence.create( :event_id => 1, :starts_at => "2012-04-03 19:00:00", :ends_at => "2012-04-03 23:00:00")
Occurrence.create( :event_id => 1, :starts_at => "2012-04-04 19:00:00", :ends_at => "2012-04-04 23:00:00")

Event.create( :id => 2, :name => "Bryan Callen", :venue_id => 1, :category_id => 1, :approved => true, :url => "http://www.goodnightscomedy.com/", :description => "Bryan Callen made his TV debut as a series regular on MADtv.
Since then, Callen has appeared on several television series including Sex and the City, 7th Heaven, Stacked, King of Queens, Las Vegas, Significant Others, West Wing, CSI, Law and Order: SVU, NYPD Blue, Suddenly Susan, Frasier, and News Radio, among others. In addition, Callen has appeared in such feature films as BAD SANTA and OLD SCHOOL, and he has performed stand up comedy on several TV shows including Late Night with David Letterman.")
Occurrence.create( :event_id => 2, :starts_at => "2012-04-12 19:00:00", :ends_at => "2012-04-12 23:00:00")
Occurrence.create( :event_id => 2, :starts_at => "2012-04-13 19:00:00", :ends_at => "2012-04-13 23:00:00")
Occurrence.create( :event_id => 2, :starts_at => "2012-04-14 19:00:00", :ends_at => "2012-04-14 23:00:00")

Event.create( :id => 3, :name => "The B-52s", :venue_id => 6, :category_id => 1, :approved => true, :url => "http://boothamphitheatre.com/events/band-together-nc-and-kba-present-the-b52s/", :description => "Band Together NC, in conjunction with and support of, Urban Ministries of Wake County has announced the complete lineup for its benefit concert to be held May 12 at Cary's Booth Amphitheatre. The \"World's Greatest Party Band\", The B-52s   will top the bill for this year's benefit concert and will be joined by regional favorites Southern Culture on the Skids of Chapel Hill and BIG Something  of Burlington.")
Occurrence.create( :event_id => 3, :starts_at => "2012-03-31 19:30:00")
Occurrence.create( :event_id => 3, :starts_at => "2012-05-12 19:00:00", :ends_at => "2012-04-12 23:00:00")

Event.create( :id => 4, :name => "Steel Magnolias", :venue_id => 4, :category_id => 1, :url => "http://www.progressenergycenter.com/event/steelmagnolias-754", :description => "Produced by North Carolina Theatre
The quintessential story of family and friendship in a unique Southern sisterhood, Steel Magnolias is a skillfully crafted portrayal of eccentricity, loyalty and love set in a small-town beauty parlor. The title suggests that although they appear delicate as magnolias, the main female characters are tough as steel. Set in the intimate venue of A.J. Fletcher Theater, this humorously revealing play will take you on an emotional journey filled with laughter and tears.")
Occurrence.create( :event_id => 4, :starts_at => "2012-03-26 18:30:00")
Occurrence.create( :event_id => 4, :starts_at => "2012-04-20 19:30:00")
Occurrence.create( :event_id => 4, :starts_at => "2012-04-21 14:00:00")
Occurrence.create( :event_id => 4, :starts_at => "2012-04-21 19:30:00")
Occurrence.create( :event_id => 4, :starts_at => "2012-04-22 14:00:00")
Occurrence.create( :event_id => 4, :starts_at => "2012-04-22 19:30:00")
Occurrence.create( :event_id => 4, :starts_at => "2012-04-24 19:30:00")
Occurrence.create( :event_id => 4, :starts_at => "2012-04-25 19:30:00")
Occurrence.create( :event_id => 4, :starts_at => "2012-04-26 19:30:00")
Occurrence.create( :event_id => 4, :starts_at => "2012-04-27 19:30:00")
Occurrence.create( :event_id => 4, :starts_at => "2012-04-28 14:00:00")
Occurrence.create( :event_id => 4, :starts_at => "2012-04-28 19:30:00")
Occurrence.create( :event_id => 4, :starts_at => "2012-04-29 14:00:00")
Occurrence.create( :event_id => 4, :starts_at => "2012-04-29 19:30:00")

Event.create( :id => 5, :name => "MOZART'S TWO PIANOS", :venue_id => 4, :category_id => 1, :url => "http://www.progressenergycenter.com/event/north-carolina-symphony-classical-735", :description => "Christina and Michelle Naughton, duo pianos
Andrew Grams, guest conductor
Twenty-something twin sisters Christina and Michelle Naughton offer you a very rare opportunity to hear a real treat in Mozart's Concerto for Two Pianos. Andrew Grams conducts two Romantic-era masterworks. Enjoy an evening of beloved classics and all-American talent.
Weber: Overture to Der Freischutz
Mozart: Piano Concerto No. 10 for Two Pianos
Brahms: Symphony No. 1
Please join us for a pre-concert talk starting at 7pm in the West Pavilion lobby on both Friday and Saturday night.
")
Occurrence.create( :event_id => 5, :starts_at => "2012-03-30 20:00:00")
Occurrence.create( :event_id => 5, :starts_at => "2012-03-31 20:00:00")
