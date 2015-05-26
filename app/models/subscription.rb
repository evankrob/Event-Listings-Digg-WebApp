class Subscription < ActiveRecord::Base
  WINDOW = 14
  FREQUENCIES = %w(weekly daily)
  serialize :search_params, JSON

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/, :allow_blank => true
  validates_presence_of :email, :search_params, :token, :frequency
  validates_inclusion_of :frequency, :in => FREQUENCIES, :allow_blank => true

  scope :daily, where(:frequency => 'daily')
  scope :weekly, where(:frequency => 'weekly')

  before_validation :set_token
  before_validation :clean_up_params

  def events
    @events ||= EventSearch.new(params).run.results
  end

  def params
    {:search => frequency_params}
  end

  def each_search_param
    search_params.each do |key, val|
      next if val.blank?
      val = case key
        when 'categories' then Category.find(val)
        else val
      end
      yield key, val if block_given?
    end
  end

  def search_criteria
    search_params.map { |k,v| "#{k}: #{v}" }.join(', ')
  end

  private

  def frequency_params
    start_date = Date.today
    end_date = start_date + WINDOW

    fp = case frequency
      when 'weekly'
        {:start_date => start_date.strftime('%m/%d/%Y'), :end_date => end_date.strftime('%m/%d/%Y')}
      when 'daily'
        {:created_since => Date.today-1, :start_date => start_date.strftime('%m/%d/%Y'), :end_date => end_date.strftime('%m/%d/%Y')}
      else {}
    end

    search_params.merge(fp)
  end

  def set_token
    self.token ||= SecureRandom.hex(32)
  end

  def clean_up_params
    search_params.each { |k,v| search_params.delete(k) if v.blank? }
  end
end
