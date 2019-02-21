u = User.create!(
  email: "admin@admin.admin",
  password: "admin",
  admin: true
)

a = Admin.create!(
  pages: 3
)

websites = [
  "www.cv-library.co.uk",
  "www.jobsite.com",
  "www.escapethecity.org",
  "www.jobstoday.co.uk",
  "www.indeed.co.uk",
  "www.totaljobs.com",
  "www.reed.co.uk",
  "www.ziprecruiter.co.uk",
  "www.cwjobs.co.uk"
]

websites.each do |website|
  Website.create!(website_name: website)
end

s = Search.create!(
  title: "dummy search"
  user_id: u.id
)

f = Firm.create!(
  firm_name: "dummy firm"
)

Job.create!(
  title: "dummy job",
  search_id: s.id,
  website_id: Website.first,
  firm_id: f.id
)

sh = SearchHistory.create!(
  user_id: u.id,
  search_id: s.id
)
