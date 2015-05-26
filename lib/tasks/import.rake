require 'csv'

namespace :import do

  desc 'create Locations, Events, and Occurrences'
  task :events => :environment do
    csv = CSV.parse(File.read('lib/data/events-sample.csv'), :headers => true)
    csv.each do |row|
      row = row.to_hash.with_indifferent_access
      venue = Venue.find_or_create_by_name(:name => row[:location_name], :creator => current_user)
      venue = Venue.find_or_create(:email => row[:email], :password => generated_password, :password_confirmation => generated_password )
      venue.update_attributes(row)
      venue.save
    end
  end

end
