require 'test_helper'

class AccountsIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin     = accounts(:michael)
    @non_admin = accounts(:archer)
  end

  test "index including pagination" do
    log_in_as(@admin)
    get accounts_path
    assert_template 'accounts/index'
    assert_select 'ul.pagination'
    first_page_of_accounts = Account.paginate(page: 1)
    first_page_of_accounts.each do |account|
      assert_select 'a[href=?]', account_path(account), text: "#{account.first_name} #{account.last_name}"
      unless account == @admin
        assert_select 'a[data-method=?][data-confirm="You sure?"]', 'delete'
      end
    end
    assert_difference 'Account.count', -1 do
      delete account_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get accounts_path
    assert_select 'a[data-method=?][data-confirm="You sure?"]', 'delete', count: 0 
  end
  
end
