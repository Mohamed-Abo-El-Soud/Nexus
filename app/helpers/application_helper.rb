module ApplicationHelper
  
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "Nexus"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
  
  def pagination_change(collection)
    
    paginated_collection = will_paginate collection
    
    if paginated_collection.nil?
      return
    end
    
    doc = Nokogiri::HTML(paginated_collection)
    
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
