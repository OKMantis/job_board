class JobPosting < ApplicationRecord
  belongs_to :company
  belongs_to :category

  STATUSES = %w[draft active expired closed].freeze

  validates :title, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :salary_min, numericality: { greater_than: 0 }, allow_nil: true
  validates :salary_max, numericality: { greater_than: 0 }, allow_nil: true

  # Basic status scopes
  scope :active, -> { where(status: "active") }
  scope :draft, -> { where(status: "draft") }
  scope :expired, -> { where(status: "expired") }

  # Feature scopes
  scope :featured, -> { where(featured: true) }
  scope :remote, -> { where(remote: true) }

  # Time-based scopes
  scope :recent, -> { order(posted_at: :desc) }
  scope :not_expired, -> { where("expires_at > ?", Time.current) }
  scope :posted_today, -> { where(posted_at: Date.today.beginning_of_day..) }

  # Scope with argument
  scope :by_category, ->(cat) { where(category: cat) }
  scope :salary_at_least, ->(min) { where("salary_min >= ?", min) }

  # Default scope
  default_scope { order(posted_at: :desc) }
end
