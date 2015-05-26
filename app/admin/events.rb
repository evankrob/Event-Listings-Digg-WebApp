require 'faster_csv'

ActiveAdmin.register Event do

  index do
    column :name do |event|
      link_to event.name, edit_admin_event_path(event)
    end
    column 'Category' do |event|
      event.category.try(:name)
    end
    column 'Venue' do |event|
      event.venue.try(:name)
    end
    column 'Address' do |event|
      event.venue.try(:address)
    end
    column :link do |event|
      link_to 'url', event.url
    end
    default_actions
  end

  show do
    attributes_table :name, :venue, :url, :category, :tag_list, :description, :approved, :created_at, :updated_at
  end

  form do |f|
    f.inputs do
      f.input :venue
      f.input :name
      f.input :category
      f.input :tag_list
      f.input :url
      f.input :description
    end
    f.buttons
  end

  member_action :approve, :method => :put do
    @event = Event.find(params[:id])

    if @event.update_attribute(:approved, true)
      redirect_to '/admin', :notice => "'#{@event.name}' has been approved"
    else
      flash[:error] = "'#{@event.name}' could not be approved"
      redirect_to '/admin'
    end
  end

  collection_action :template, :method => :get do
    csv_string = FasterCSV.generate do |csv|
      csv << Event::HEADERS
      csv << ['Sample', 'http://example.com/', 'A sample event', 'Concert', 'pizza, tofu', 'The Place', '101 Main St.', 'Raleigh', 'NC', '27601', '555 555-555', 'http://example.com/', '3/30/2012 18:30:00', '']
    end
    send_data(csv_string, :filename => 'Event Import Template.csv', :type => 'text/csv', :disposition => 'attachment')
  end

  action_item do
    link_to "Import", import_admin_events_path
  end

  collection_action :import, :method => :get

  collection_action :upload_import, :method => :post do
    import = CSVImport.new(Event, params[:import])
    import.run
    if import.errors.any?
      @errors = import.errors
    else
      flash[:notice] = "Events were imported successfully"
    end
    render :import
  end
end
