# frozen_string_literal: true

class Mention < ApplicationRecord
  # mentionする側
  belongs_to :mentioning_report, # 使用したいアソシーエションメソッド名、言及しているreportモデル => mentioning_report
             class_name: 'Report', # 実際に関連づけるモデル
             foreign_key: :mentioning_id, # 外部キーの名前をデフォの`report_id`から`mentioning_id`に変更
             inverse_of: :mentioning_relations # 双方向関連付けとして、関連先の関連名`mentioning_relations`を書く

  # mentionされる側
  belongs_to :mentioned_report, # 使用したいアソシーエションメソッド名、言及されたreportモデル =>　mentioned_report
             class_name: 'Report', # 実際に関連づけるモデル
             foreign_key: :mentioned_id, # 外部キーの名前をデフォの`report_id`から`mentioned_id`に変更
             inverse_of: :mentioned_relations # # 双方向関連付けとして、関連先の関連名`mentioned_relations`を書く
end
