class Category < ApplicationRecord
  has_many :job_postings

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
end
