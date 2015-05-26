ActiveAdmin.register DrinkSpecial do
  index do
    column :venue do |special|
      special.venue.name
    end
    column 'Mon' do |special|
      special.monday? ? 'Special' : '--'
    end
    column 'Tue' do |special|
      special.tuesday? ? 'Special' : '--'
    end
    column 'Wed' do |special|
      special.wednesday? ? 'Special' : '--'
    end
    column 'Thur' do |special|
      special.thursday? ? 'Special' : '--'
    end
    column 'Fri' do |special|
      special.friday? ? 'Special' : '--'
    end
    column 'Sat' do |special|
      special.saturday? ? 'Special' : '--'
    end
    column 'Sun' do |special|
      special.sunday? ? 'Special' : '--'
    end
    default_actions
  end

  show do
    attributes_table :venue, :tag_list, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday
  end

  form do |f|
    f.inputs do
      f.input :venue
      f.input :tag_list
      f.input :monday
      f.input :tuesday
      f.input :wednesday
      f.input :thursday
      f.input :friday
      f.input :saturday
      f.input :sunday
    end
    f.buttons
  end

  collection_action :template, :method => :get do
    csv_string = FasterCSV.generate do |csv|
      csv << Special::HEADERS
      csv << ['The Place', '101 Main St.', 'Raleigh', 'NC', '27601', '555 555-555', 'http://example.com/', 'Jim Jimmers', 'jim@example.com', 'pizza, tofu', 'Monday specials', 'Tuesday specials', 'Wednesday specials', 'Thursday specials', 'Friday specials', 'Saturday specials', 'Sunday specials']
    end
    send_data(csv_string, :filename => 'Drink Specials Import Template.csv', :type => 'text/csv', :disposition => 'attachment')
  end

  action_item do
    link_to "Import", import_admin_drink_specials_path
  end

  collection_action :import, :method => :get

  collection_action :upload_import, :method => :post do
    import = CSVImport.new(DrinkSpecial, params[:import])
    import.run
    if import.errors.any?
      @errors = import.errors
    else
      flash[:notice] = "Drink Specials were imported successfully"
    end
    render :import
  end
end
