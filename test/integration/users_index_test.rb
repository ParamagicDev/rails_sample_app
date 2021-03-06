# frozen_string_literal: true

require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
    @not_activated = users(:not_activated)
  end

  test 'index as admin & including pagination & delete links' do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2

    first_page_of_users = assigns(:users)
    first_page_of_users.each do |user|
      assert user.activated?
      assert_select 'a[href=?]', user_path(user), text: user.name

      # checks that the person deleting links cannot delete themself
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end

    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test 'index as non-admin' do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
    # tests for 0 'a'nchor links
  end

  test 'going to an unactivated user url will result in redirect to root url' do
    get user_path(@not_activated)
    follow_redirect!
    assert_template 'static_pages/home'
  end
end
