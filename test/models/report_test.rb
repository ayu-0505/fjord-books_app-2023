# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @user = users(:alice)
    @report = reports(:alice_report)
  end
  test 'editable? returns true with correct user' do
    assert @report.editable?(@user)
  end

  test 'editable? returns false with incorrect user' do
    incorrect_user = users(:bob)
    assert_not @report.editable?(incorrect_user)
  end

  test 'created_on returns Date class' do
    @report.created_at = Time.zone.now
    assert_instance_of Date, @report.created_on
  end

  test 'create new mentions' do
    existing_report1 = reports(:bob_report)
    existing_report2 = reports(:carol_report)
    report = @user.reports.new(
      title: 'おすすめ日報',
      content: "http://localhost:3000/reports/#{existing_report1.id}と
                http://localhost:3000/reports/#{existing_report2.id}がおすすめです。"
    )
    report.save

    assert_equal 2, report.active_mentions.size
    assert report.active_mentions.find_by(mentioned_by_id: existing_report1.id)
    assert report.active_mentions.find_by(mentioned_by_id: existing_report2.id)
  end

  test 'delete exsinting mentions and create new mentions when content updates' do
    mentioned_report = reports(:bob_report)

    # Fixtureの確認(既存Mentionがある状態)
    assert_equal 1, @report.active_mentions.size
    assert @report.active_mentions.find_by(mentioned_by_id: mentioned_report)

    new_mentioned_report = reports(:carol_report)
    @report.content =
      "http://localhost:3000/reports/#{new_mentioned_report.id}を見ました。"
    @report.save

    assert_equal 1, @report.active_mentions.size
    assert @report.active_mentions.find_by(mentioned_by_id: new_mentioned_report.id)
    assert_not @report.active_mentions.find_by(mentioned_by_id: mentioned_report.id)
  end

  test 'report_mentions should be uniq' do
    mentioned_report = reports(:bob_report)
    @report.content = "http://localhost:3000/reports/#{mentioned_report.id}がおすすめ。
                      http://localhost:3000/reports/#{mentioned_report.id}だよ。"
    @report.save

    assert_equal 1, @report.active_mentions.size
  end

  test 'report shold have no mention for self' do
    @report.content = "http://localhost:3000/reports/#{@report.id}がこの日報のURLです。"
    @report.save

    assert_equal 0, @report.active_mentions.size
  end
end
