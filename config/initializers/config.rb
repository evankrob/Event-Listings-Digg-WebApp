require 'hack_datetime'
require 'taggable_with_proxy'
require 'csv_import'

WUR = YAML::load_file(File.join(Rails.root, 'config', 'config.yml'))

ActionMailer::Base.default :from => WUR['email']['from'], :to => WUR['email']['to']
unless Rails.env.test?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = WUR['email']['smtp_settings']
end

#ActionMailer::Base.perform_deliveries = false
