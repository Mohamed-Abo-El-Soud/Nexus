module AccountsHelper
  
  # Returns the Gravatar for the given account.
  def gravatar_for(account, options = "")
    gravatar_id = Digest::MD5::hexdigest(account.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=300"
    image_tag(gravatar_url, alt: account.first_name, class: "gravatar #{options}")
  end
  
  def is_unchanged(password)
    password ? "(unchanged)" : nil
  end
end
