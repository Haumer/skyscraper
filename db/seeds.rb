# Uncomment lines 3-9 if you want to reset everything

# User.all.each { |e| e.destroy }
# Admin.all.each { |e| e.destroy }
# Website.all.each { |e| e.destroy }
# Search.all.each { |e| e.destroy }
# Firm.all.each { |e| e.destroy }
# Job.all.each { |e| e.destroy }
# SearchHistory.all.each { |e| e.destroy }

u = User.create!(
  email: "admin@admin.admin",
  password: "admin1",
  admin: true
)
puts "Created User with id #{u.id}"

a = Admin.create!(
  pages: 3
)
puts "Created Admin with id #{a.id}"

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
  w = Website.create!(website_name: website)
  puts "Created Website with id #{w.id}"
end

s = Search.create!(
  title: "dummy search",
  user_id: u.id
)
puts "Created Search with id #{s.id} and user_id #{s.user_id}"

f = Firm.create!(
  firm_name: "dummy firm"
)
puts "Created Firm with id #{f.id}"

j = Job.create!(
  title: "dummy job",
  search_id: s.id,
  website_id: Website.first.id,
  firm_id: f.id,
  company: "dummy company"
)
puts "Created Job with id #{j.id}, search_id #{j.search_id}, website_id #{j.website_id} and firm_id #{j.firm_id}"

sh = SearchHistory.create!(
  user_id: u.id,
  search_id: s.id
)
puts "Created SearchHistory with id #{sh.id}, user_id #{sh.user_id} and search_id #{sh.search_id}"
