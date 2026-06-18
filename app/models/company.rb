class Company < ApplicationRecord
  has_many :job_postings, dependent: :destroy
  
  validates :name, presence: true
  validates :location, presence: true
end
