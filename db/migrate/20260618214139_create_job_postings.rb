class CreateJobPostings < ActiveRecord::Migration[8.1]
  def change
    create_table :job_postings do |t|
      t.string :title
      t.text :description
      t.integer :salary_min
      t.integer :salary_max
      t.string :status
      t.boolean :remote
      t.boolean :featured
      t.datetime :posted_at
      t.datetime :expires_at
      t.references :company, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
