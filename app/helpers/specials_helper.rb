module SpecialsHelper
  def each_specials_day(&blk)
    days = case params[:action_name]
      when 'today' then [Date.today.strftime('%A').downcase]
      when 'weekend' then %w(friday saturday sunday)
      else %w(monday tuesday wednesday thursday friday saturday sunday)
    end

    days.each(&blk)
  end
end
