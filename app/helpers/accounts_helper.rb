module AccountsHelper
  
  # Returns the Gravatar for the given account.
  def gravatar_for(account, options = {})
    gravatar_id = Digest::MD5::hexdigest(account.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{options[:size]}"
    image_tag(gravatar_url, alt: account.first_name, class: "gravatar #{options[:class]}")
  end
  
  def is_unchanged(password)
    password ? "(unchanged)" : nil
  end
  
  def pagination_change
    
    doc = Nokogiri::HTML(will_paginate)
    
    wrapper = doc.at_css ".pagination"
    
    wrapper.name = "ul"
    
    wrapper[:class] = "valign pagination accent"
    
    # numbered_links = doc.css "a:not(:first-child):not(:last-child)"
    numbered_links = doc.css "a,span"
    
    numbered_links.wrap "<li class=\"waves-effect\"></li>"
    
    spans = doc.at_css "span"
    
    unless spans.nil?
      disabled_one = spans.parent
      
      disabled_one[:class] = "disabled"
    
    spans.name = "a"
    
    end
    
    first = doc.at_css "li:first-child"
    
    h_ref = doc.at_css("li:first-child a")[:href]
    
    first.children = "<a href=\"#{h_ref}\"><i class=\"material-icons\">chevron_left</i></a>"
    
    last = doc.at_css "li:last-child"
    
    h_ref = doc.at_css("li:last-child a")[:href]
    
    last.children = "<a href=\"#{h_ref}\"><i class=\"material-icons\">chevron_right</i></a>"
    
    current_page = doc.css "em"
    
    current_page.wrap("<li class=\"active\"></li>")
    
    current_page = doc.at_css "em"
    
    current_page.name = "a"
    
    doc.to_s.html_safe
    
  end
end
