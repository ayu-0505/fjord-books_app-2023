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

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def save_with_mentions
    old_mentioned_ids = mentioning_relations.map(&:mentioned_id)
    mentioned_ids_to_create = mentioned_ids_in_content - old_mentioned_ids
    mentioned_ids_to_delete = old_mentioned_ids - mentioned_ids_in_content

    success = true
    Report.transaction do
      success &= save
      success &= create_mentions(mentioned_ids_to_create) if mentioned_ids_to_create.present?
      success &= delete_mentions(mentioned_ids_to_delete) if mentioned_ids_to_delete.present?

      raise ActiveRecord::Rollback unless success
    end
    success
  end

  private

  def mentioned_ids_in_content
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
    existing_mentioned_ids = Report.where(id: mentioned_ids).pluck(:id)
    existing_mentioned_ids.all? do |mentioned_id|
      mentioning_relations.create(mentioned_id:)
    end
  end

  def delete_mentions(mentioned_ids)
    mentioned_ids.all? do |mentioned_id|
      mentioning_relations.destroy_by(mentioned_id:)
    end
  end
end
