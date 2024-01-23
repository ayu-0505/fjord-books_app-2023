# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:alice)
  end

  test 'name_or_email returns user name with user name' do
    assert_equal 'アリス', @user.name_or_email
  end

  test 'name_or_email returns email without user name' do
    @user.name = ''
    assert_equal 'alice@example.com', @user.name_or_email
  end
end
