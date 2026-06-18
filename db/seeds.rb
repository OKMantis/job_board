puts "Clearing data..."
JobPosting.destroy_all
Category.destroy_all
Company.destroy_all

# Categories
categories = Category.create!([
  { name: "Engineering",  slug: "engineering"  },
  { name: "Design",       slug: "design"       },
  { name: "Marketing",    slug: "marketing"    },
  { name: "Sales",        slug: "sales"        },
  { name: "Operations",   slug: "operations"   }
])

# Companies
companies = Company.create!([
  { name: "Acme Corp",      website: "https://acme.io",     location: "New York"     },
  { name: "Startup Labs",   website: "https://stlabs.io",   location: "San Francisco" },
  { name: "Global Tech",    website: "https://globaltech.com", location: "Austin"        },
  { name: "Remote First",   website: "https://rf.co",       location: "Remote"        },
  { name: "Enterprise Inc", website: "https://einc.com",    location: "Chicago"       }
])

# Job postings across statuses, salaries, and expiry dates
jobs_data = [
  # Active, featured, remote — shows up in most filters
  { title: "Senior Rails Engineer", status: "active", featured: true,  remote: true,
    salary_min: 120_000, salary_max: 160_000, company: companies[1],
    category: categories[0], posted_at: 2.days.ago, expires_at: 30.days.from_now },

  { title: "Product Designer", status: "active", featured: true, remote: false,
    salary_min: 90_000, salary_max: 120_000, company: companies[0],
    category: categories[1], posted_at: 1.day.ago, expires_at: 25.days.from_now },

  { title: "Growth Marketing Manager", status: "active", featured: false, remote: true,
    salary_min: 70_000, salary_max: 95_000, company: companies[2],
    category: categories[2], posted_at: 3.days.ago, expires_at: 5.days.from_now },

  { title: "Account Executive", status: "active", featured: false, remote: false,
    salary_min: 60_000, salary_max: 80_000, company: companies[4],
    category: categories[3], posted_at: 5.days.ago, expires_at: 20.days.from_now },

  { title: "Remote DevOps Engineer", status: "active", featured: true, remote: true,
    salary_min: 130_000, salary_max: 170_000, company: companies[3],
    category: categories[0], posted_at: 1.day.ago, expires_at: 6.days.from_now },

  { title: "Junior Rails Developer", status: "active", featured: false, remote: false,
    salary_min: 55_000, salary_max: 75_000, company: companies[0],
    category: categories[0], posted_at: 4.days.ago, expires_at: 15.days.from_now },

  { title: "UX Researcher", status: "active", featured: false, remote: true,
    salary_min: 80_000, salary_max: 100_000, company: companies[1],
    category: categories[1], posted_at: 6.days.ago, expires_at: 10.days.from_now },

  { title: "Operations Manager", status: "active", featured: false, remote: false,
    salary_min: nil, salary_max: nil, company: companies[4],
    category: categories[4], posted_at: 7.days.ago, expires_at: 14.days.from_now },

  # Draft — should NOT appear in index (filtered out by .active scope)
  { title: "Unpublished Role", status: "draft", featured: false, remote: false,
    salary_min: 50_000, salary_max: 70_000, company: companies[2],
    category: categories[3], posted_at: 1.day.ago, expires_at: 30.days.from_now },

  # Expired — should NOT appear (filtered by .not_expired scope)
  { title: "Already Expired Job", status: "active", featured: false, remote: false,
    salary_min: 60_000, salary_max: 90_000, company: companies[0],
    category: categories[2], posted_at: 30.days.ago, expires_at: 2.days.ago }
]

jobs_data.each { |attrs| JobPosting.create!(attrs) }

puts "Seeded: #{Category.count} categories, #{Company.count} companies, #{JobPosting.count} job postings"