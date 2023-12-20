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

  def update_mentions(id_list)
    old_id_list = mentioning_relations.map(&:mentioned_id)
    list_to_create = id_list.difference(old_id_list)
    list_to_delete = old_id_list.difference(id_list)

    create_mentions(list_to_create) unless list_to_create.empty?
    delete_mentions(list_to_delete) unless list_to_delete.empty?
  end

  def mentioning_id_list
    paths = URI.extract(content, %w[http https])
    return [] if paths == []

    paths.select { |path| path.match?((('127.0.0.1:3000' || 'localhost:3000') && %r{reports/(\d+)})) }.map do |path|
      match = path.match(%r{reports/(\d+)})
      match[1].to_i
    end.uniq
  end

  def create_mentions(id_list)
    id_list.each do |id|
      mention = mentioning_relations.build(mentioned_id: id)
      mention.save unless id == self.id
    end
  end

  def delete_mentions(id_list)
    id_list.each do |id|
      mention = mentioning_relations.find_by(mentioned_id: id)
      mention.delete
    end
  end
end
