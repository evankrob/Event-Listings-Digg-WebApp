module ApplicationHelper
  def glyph(icon, args={})
    (args[:class] ||= '') << " icon-#{icon}"
    args[:class] << ' tip' if args[:title]
    attrs = args.map { |attr, val| %Q|#{attr}="#{val}"| }
    %Q|<i #{attrs.join(' ')}></i>|.html_safe
  end

  def white_glyph(icon, args={})
    glyph("#{icon} icon-white", args)
  end

  def flash_notice(*notices)
    notices.map { |msg| alert(msg, 'alert-success') }.join.html_safe
  end

  def flash_welcome(*notices)
    notices.map { |msg| alert(msg, 'alert-welcome alert-warning') }.join.html_safe
  end

  def flash_error(*notices)
    notices.map { |msg| alert(msg, 'alert-error') }.join.html_safe
  end

  def alert(msg, type=nil)
    %Q|<div class="alert #{type}"><button type="button" class="close" data-dismiss="alert">x</button>#{msg}</div>|.html_safe
  end

  def error_messages(object)
    if object.errors.any?
      msg = <<-HTML
      <div class="alert alert-error">
        <p><strong>Sorry, there were some problems with your submission:</strong></p>
        #{object.errors.full_messages.map { |e| "<p>#{e}.</p>" }.join.html_safe}
      </div>
      HTML
      msg.html_safe
    end
  end

  def auto_link(text)
    text.gsub(%r{https?://[^\s<]+}) do |url|
      link_text = url.sub(%r{^https?://}, '')
      %Q|<a href="#{url}" target="_blank">#{link_text}</a>|
    end.html_safe
  end
end
