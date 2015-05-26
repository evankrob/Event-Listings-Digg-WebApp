module OccurrencesHelper
  def pretty_start(occurrence, nbsp=true)
    fmt = '%a, %b %e'
    fmt << ', %Y' unless occurrence.starts_at.year == Time.now.year
    fmt << ' at %l:%M%P'
    fmt.gsub!(' ', '&nbsp;') if nbsp
    occurrence.starts_at.strftime(fmt).html_safe
  end
end
