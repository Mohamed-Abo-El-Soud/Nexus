require 'test_helper'

class RegexTestingTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @tag_with_class = "<label class=\"active\" for=\"account_email\">Email</label>"
    @tag_with_active_and_error_class = "<label class=\"error active\" for=\"account_email\">Email</label>"
    @tag_with_error_class = "<label class=\"error\" for=\"account_email\">Email</label>"
    @tag_without_class = "<label for=\"account_email\">Email</label>"
  end
  
  test "regex function should find and add appropriate class name to tag" do
    new_text = @tag_with_class.gsub(/class="/, "class=\"error")
    assert (new_text == @tag_with_active_and_error_class) || (new_text == @tag_with_active_and_error_class)
  end
  
  test "regex function should add the class, if there isn't one to begin with" do
    new_text = @tag_without_class.gsub(/class="/, "class=\"error")
    assert (new_text == @tag_with_active_and_error_class) || (new_text == @tag_with_active_and_error_class)
  end
end

