# frozen_string_literal: true

class Mention < ApplicationRecord
  belongs_to :mentioning_report,
             class_name: 'Report',
             foreign_key: :mentioning_id,
             inverse_of: :mentioning_relations

  belongs_to :mentioned_report,
             class_name: 'Report',
             foreign_key: :mentioned_id,
             inverse_of: :mentioned_relations

  validates :mentioning_id, presence: true
  validates :mentioned_id, presence: true,
                           uniqueness: { scope: :mentioning_id }
end
