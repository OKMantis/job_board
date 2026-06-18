class JobPosting < ApplicationRecord
  belongs_to :company
  belongs_to :category

  STATUSES = %w[draft active expired closed].freeze

  validates :title, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :salary_min, numericality: { greater_than: 0 }, allow_nil: true
  validates :salary_max, numericality: { greater_than: 0 }, allow_nil: true
end
