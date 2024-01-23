# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:alice)
  end

  test 'name_or_emailは@userの名前項目に値があると名前を返す' do
    assert_equal 'アリス', @user.name_or_email
  end

  test 'name_or_emailは@userの名前項目に値がないとemailを返す' do
    @user.name = ''
    assert_equal 'alice@example.com', @user.name_or_email
  end
end
