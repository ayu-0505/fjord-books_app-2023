# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comment, as: :commentable, dependent: :destroy
end
