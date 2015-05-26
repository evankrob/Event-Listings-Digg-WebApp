module HackDatetime
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def hack_datetime(*attributes)
      options = attributes.last.is_a?(Hash) ? attributes.pop : {}
      options[:format] ||= '%m/%d/%Y %H:%M%P'

      class_eval do
        define_method :combine_datetime do |date_str, time_str|
          return nil if date_str.blank? or time_str.blank?
          DateTime.strptime("#{date_str} #{time_str} #{Time.now.zone}", "#{options[:format]} %Z") #rescue nil
        end

        attributes.each do |attribute|
          attr_reader :"#{attribute}_date", :"#{attribute}_time"

          define_method :"#{attribute}_date=" do |date_str|
            instance_variable_set("@#{attribute}_date", date_str)
            send(:"combine_#{attribute}")
            date_str
          end

          define_method :"#{attribute}_time=" do |time_str|
            instance_variable_set("@#{attribute}_time", time_str)
            send(:"combine_#{attribute}")
            time_str
          end

          define_method :"combine_#{attribute}" do
            date_str = send(:"#{attribute}_date")
            time_str = send(:"#{attribute}_time")

            send(:"#{attribute}=", combine_datetime(date_str, time_str))
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, HackDatetime
