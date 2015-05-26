Time::DATE_FORMATS[:pretty] = lambda { |time| time.strftime("%a, %b %e at %l:%M") + time.strftime("%p").downcase }
Time::DATE_FORMATS[:simple] = lambda { |time| time.strftime("%a, %b %e") }
Time::DATE_FORMATS[:iso] = lambda { |time| time.strftime("%Y-%m-%d") }
Time::DATE_FORMATS[:ampm] = lambda { |time| time.strftime("%I:%M %p") }
Time::DATE_FORMATS[:long12] = lambda { |time| time.strftime("%B %d, %Y %I:%M %p") }
Time::DATE_FORMATS[:month_year] = lambda { |time| time.strftime("%B %d, %Y") }
Time::DATE_FORMATS[:us] = lambda { |time| time.strftime("%m/%d/%Y") }
Time::DATE_FORMATS[:admin] = lambda { |time| time.strftime("%m/%d %I:%M %p") }
