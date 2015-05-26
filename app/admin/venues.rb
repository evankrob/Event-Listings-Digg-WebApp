ActiveAdmin.register Venue do
  actions :all, :except => [:show]

  index do
    column :name do |venue|
      link_to venue.name, edit_admin_venue_path(venue)
    end
    column 'Address', :address
    column :link do |venue|
      link_to venue.url
    end

    default_actions
  end

  controller do
    def destroy
      venue = Venue.find(params[:id])

      if !venue.destroy
        flash[:error] = venue.errors.full_messages.join(' / ')
      end
      redirect_to admin_venues_path
    end
  end
end
