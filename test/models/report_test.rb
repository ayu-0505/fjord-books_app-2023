# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @user = users(:alice)
    @report = reports(:alice_report)
    @mentioned_report = reports(:bob_report)
  end

  test 'editable?は@userが日報作成者ならtrueを返す' do
    assert @report.editable?(@user)
  end

  test 'editable?は@userが日報作成者じゃないならfalseを返す' do
    incorrect_user = users(:bob)
    assert_not @report.editable?(incorrect_user)
  end

  test 'created_onはDateクラスかつ日報の作成された日付を返す' do
    @report.created_at = Time.zone.now
    assert_equal Date.today, @report.created_on # rubocop:disable Date cop
  end

  test '日報の保存時は既存の言及を全削除し、新規の言及を作成する' do
    assert_equal [@mentioned_report], @report.mentioning_reports
    new_mentioned_report = reports(:carol_report)
    @report.content =
      "http://localhost:3000/reports/#{new_mentioned_report.id}を見ました。"
    @report.save!
    assert_equal [new_mentioned_report], @report.reload.mentioning_reports
  end

  test '同じ言及先の言及は作成されない' do
    @report.content = "http://localhost:3000/reports/#{@mentioned_report.id}がおすすめ。
                      http://localhost:3000/reports/#{@mentioned_report.id}だよ。"
    @report.save!

    assert_equal 1, @report.active_mentions.size
    assert @report.active_mentions.find_by(mentioned_by_id: @mentioned_report.id)
  end

  test '自身への言及は作成されない' do
    @report.content = "http://localhost:3000/reports/#{@report.id}がこの日報のURLです。"
    @report.save!

    assert_empty @report.active_mentions
  end

  test '存在しない日報のID番号のURLを言及しても言及は作成されない' do
    @report.content = "http://localhost:3000/reports/#{- @report.id}は存在しない日報だ。"
    @report.save!

    assert_equal 0, @report.active_mentions.size
  end
end
