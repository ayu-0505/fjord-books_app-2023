# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :mentioning_relations,
           class_name: 'Mention',
           foreign_key: :mentioning_id,
           inverse_of: :mentioning_report,
           dependent: :destroy
  has_many :mentioning_reports, through: :mentioning_relations, source: :mentioned_report

  has_many :mentioned_relations,
           class_name: 'Mention',
           foreign_key: :mentioned_id,
           inverse_of: :mentioned_report,
           dependent: :destroy
  has_many :mentioned_reports, through: :mentioned_relations, source: :mentioning_report

  validates :title, presence: true
  validates :content, presence: true

  after_save :update_mentions
  after_update :update_mentions
  after_destroy :update_mentions

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  private

  def update_mentions
    old_mentioned_ids = mentioning_relations.map(&:mentioned_id)
    mentioned_ids_to_create = mentioned_ids_list.difference(old_mentioned_ids)
    mentioned_ids_to_delete = old_mentioned_ids.difference(mentioned_ids_list)

    create_mentions(mentioned_ids_to_create) unless mentioned_ids_to_create.empty?
    delete_mentions(mentioned_ids_to_delete) unless mentioned_ids_to_delete.empty?
  end

  def mentioned_ids_list
    paths = URI.extract(content, %w[http https])
    return [] if paths.blank?

    report_paths = paths.select do |path|
      parsed_path = URI.parse(path)
      ['127.0.0.1', 'localhost'].include?(parsed_path.host) && path.match?(%r{reports/(\d+)})
    end

    report_paths.map do |path|
      match = path.match(%r{reports/(\d+)})
      match[1].to_i
    end.uniq
  end

  def create_mentions(mentioned_ids)
    mentioned_ids.each do |mentioned_id|
      next if mentioned_id == id
      next unless Report.exists?(id: mentioned_id)

      mention = mentioning_relations.new(mentioned_id:)
      mention.save!
    end
  end

  def delete_mentions(mentioned_ids)
    mentioned_ids.each do |mentioned_id|
      mention = mentioning_relations.find_by(mentioned_id:)
      next if mention.nil?

      mention.destroy!
    end
  end
end
