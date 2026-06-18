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

  # Class method: complex logic that would be ugly in a scope block
  def self.salary_between(min, max)
    return all if min.blank? && max.blank?

    result = all
    result = result.where("salary_min >= ?", min) if min.present?
    result = result.where("salary_max <= ?", max) if max.present?
    result
  end

  # Class method: needs local variables
  def self.expiring_soon(days = 7)
    cutoff = days.days.from_now
    where("expires_at BETWEEN ? AND ?", Time.current, cutoff)
  end

  # Class method: search across multiple columns
  def self.search(query)
    return all if query.blank?

    term = "%#{sanitize_sql_like(query)}%"
    where("title LIKE ? OR description LIKE ?", term, term)
  end

  # IMPORTANT: always return "all" not nil for chainability
  def self.for_location(location)
    return all if location.blank? # < critical: return all not nil
    joins(:company).where(companies: { location: location })
  end
end
