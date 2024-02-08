# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = reports(:alice_report)
    @user = users(:alice)

    visit root_url
    fill_in 'Eメール', with: @user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    assert_text 'ログインしました。'
  end

  test '日報インデックスへアクセス' do
    visit reports_url
    assert_selector 'h1', exact_text: '日報の一覧'
  end

  test '日報の作成' do
    visit reports_url
    assert_selector 'h1', exact_text: '日報の一覧'
    click_on '日報の新規作成'
    assert_selector 'h1', exact_text: '日報の新規作成'

    fill_in 'タイトル', with: '頑張ります！'
    fill_in '内容', with: 'はじめまして、今日から入会しました。よろしくお願いします。'
    click_on '登録する'

    assert_text '日報が作成されました。'
    assert_text '頑張ります！'
    assert_text 'はじめまして、今日から入会しました。よろしくお願いします。'
  end

  test '日報の編集と更新' do
    visit report_url(@report)
    click_on 'この日報を編集', match: :first
    assert_selector 'h1', exact_text: '日報の編集'

    fill_in 'タイトル', with: 'Rubyの勉強'
    fill_in  '内容', with: '今日も大変でした。難しいですね。'
    click_on '更新する'

    assert_text '日報が更新されました。'
    assert_text 'Rubyの勉強'
    assert_text '今日も大変でした。難しいですね。'
  end

  test '日報の削除' do
    visit reports_url
    assert_text 'アリスです。'
    assert_text 'こんにちは！はじめて日報を書きます。'

    visit report_url(@report)
    assert_selector 'h1', exact_text: '日報の詳細'
    assert_difference 'Report.count', -1 do
      click_on 'この日報を削除', match: :first
      assert_text '日報が削除されました。'
    end

    assert_no_text 'アリスです。'
    assert_no_text 'こんにちは！はじめて日報を書きます。'
  end
end
