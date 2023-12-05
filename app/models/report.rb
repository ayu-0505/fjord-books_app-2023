# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  # mentionする側 (中間テーブルに対しての関係)
  has_many :mentioning_relations, # 使用したいアソシエーションメソッド名
           class_name: 'Mention',
           foreign_key: :mentioning_id, # 本来`report_id`となってしまう部分を`mentioning_id`に変更
           inverse_of: :mentioning_report, # 双方向関連付けとして、関連先の関連名`mentioning_report`を記載
           dependent: :destroy

  # その日報が言及している日報たち（言及先）
  # has_many ：中間テーブルを挟んだその先のモデル(関連名), through: :中間テーブル名, sources: :取得したい関連先
  # mentioning_reportのidによって言及された側を複数取得してくる。名前変わってるけど取得しているのはMentionの親モデルmentioned_report。
  # 例 mentioning_id:1 が言及しているmentioned_id(2,3)を取得することで、1が言及している日報等を取得する
  has_many :mentioning_reports, through: :mentions, source: :mentioned_report

  # mentionされる側 (中間テーブルに対しての関係)
  has_many :mentioned_relations, # 使用したいアソシエーションメソッド名
           class_name: 'Mention',
           foreign_key: :mentioned_id, # 本来`report_id`となってしまう部分を`mentioned_id`に変更
           inverse_of: :mentioned_report, # 双方向関連付けとして、関連先の関連名`mentioned_report`を記載
           dependent: :destroy
  # その日報が言及している日報たち（言及先）
  # has_many ：中間テーブルを挟んだその先のモデル(関連名), through: :中間テーブル名, sources: :取得したい関連先
  # mentioned_reportのidによって言及された側を複数取得してくる。名前変わってるけど取得しているのはMentionの親モデルmentioning_report。
  has_many :mentioned_reports, through: :mentions, source: :mentioning_report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end
end
