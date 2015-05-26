class CSVImport
  ThereWereErrors = Class.new(StandardError)

  attr_reader :klass, :csv_string, :errors

  def initialize(klass, file)
    @klass = klass
    @csv_string = file.read
    @errors = []
  end

  def run
    begin
      klass.transaction do
        line = -1
        FasterCSV.parse(csv_string, :headers => true, :return_headers => true) do |row|
          line += 1
          next if line == 0
          obj = klass.create_from_csv(row)
          obj.errors.full_messages.each do |msg|
            errors << "Line #{line}: #{obj.class.name} #{msg}"
          end
        end
        raise ThereWereErrors if errors.any?
      end
    rescue ThereWereErrors
    rescue FasterCSV::MalformedCSVError
      errors << 'The uploaded file is not a valid CSV'
    end
  end

  def self.normalize_date(date_str)
    date_str.insert(0, '0') unless date_str =~ /^\d{2}/ # Month
    date_str.insert(3, '0') unless date_str =~ /^\d{2}\/\d{2}/ # Day
    date_str.insert(11, '0') unless date_str =~ /^\d{2}\/\d{2}\/\d{4} \d{2}/ # Hour
    "#{date_str} EDT"
  end
end
