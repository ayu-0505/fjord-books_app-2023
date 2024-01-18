# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'name_or_email with user name' do
    user = users(:alice)
    assert_equal 'alice', user.name_or_email
  end

  test 'name_or_email without user name' do
    user = users(:alice)
    user.name = ''
    assert_equal 'alice@example.com', user.name_or_email
  end
end
