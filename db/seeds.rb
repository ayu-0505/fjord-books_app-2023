# frozen_string_literal: true

print '開発環境のデータをすべて削除して初期データを投入します。よろしいですか？[Y/n]: ' # rubocop:disable Rails/Output
unless $stdin.gets.chomp.casecmp('Y').zero?
  puts '中止しました。' # rubocop:disable Rails/Output
  return
end

def picture_file(name)
  File.open(Rails.root.join("db/seeds/#{name}"))
end

Book.destroy_all

Book.create!(
  title: 'Ruby超入門',
  memo: 'Rubyの文法の基本をやさしくていねいに解説しています。',
  author: '五十嵐 邦明',
  picture: picture_file('cho-nyumon.jpg')
)

Book.create!(
  title: 'チェリー本',
  memo: 'プログラミング経験者のためのRuby入門書です。',
  author: '伊藤 淳一',
  picture: picture_file('cherry-book.jpg')
)

Book.create!(
  title: '楽々ERDレッスン',
  memo: '実在する帳票から本当に使えるテーブル設計を導く画期的な本！',
  author: '羽生 章洋',
  picture: picture_file('erd.jpg')
)

User.create!(
  name: 'ゆうき',
  email: 'foo@example.com',
  password: 'aaaaaaay'
)
User.create!(
  name: 'まい',
  email: 'bar@example.com',
  password: 'aaaaaaa'
)
User.create!(
  name: 'のん',
  email: 'baz@example.com',
  password: 'aaaaaab'
)
User.create!(
  name: 'あお',
  email: 'piyo@example.com',
  password: 'aaaaaac'
)
User.create!(
  name: 'るい',
  email: 'kuku@example.com',
  password: 'aaaaaaq'
)

puts '初期データの投入が完了しました。' # rubocop:disable Rails/Output
