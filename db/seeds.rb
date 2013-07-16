# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) are set in the file config/application.yml.
# See http://railsapps.github.com/rails-environment-variables.html

# puts 'ROLES'
# YAML.load(ENV['ROLES']).each do |role|
#   Role.find_or_create_by_name({ :name => role }, :without_protection => true)
#   puts 'role: ' << role
# end
# puts 'DEFAULT USERS'
# user = User.find_or_create_by_email :name => ENV['ADMIN_NAME'].dup, :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
# puts 'user: ' << user.name
# user.add_role :admin

[
  "Rap/Hip Hop",
  "Chicano Rap/Hip Hop",
  "Rock/Pop",
  "Metal",
  "Country",
  "Soul/R&B",
  "Latin (Corridos Prohibidos)",
  "Instrumentals/Beats",
  "Radio Show (Interviews)"
].each do |category_name|
  new_category = Category.find_or_create_by_name(category_name)
  puts new_category.name if new_category.new_record?
end

require 'csv'
csv_text = File.read('./db/seed_data/audioprint_album_import.csv')
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  values = row.to_hash
  values['catalog_id'] = values['catalog_id'].gsub('AP', '').to_i

  begin
    album = Album.find_or_initialize_by_catalog_id(values)
    values = values.except(:quantity) if !album.new_record?

    ap album

    album.assign_attributes(values)
    album.save
  rescue Exception => e
    Rails.logger.info "#{album.id} failed to import ERROR #{e}"
  end
end

# [
#   "Artist",
#   "DJ (Mixtapes)",
#   "Comedian",
#   "Author",
#   "Producer"
# ].each do |p_type|
#   new_type = ProfileType.find_or_create_by_name(p_type)
#   puts new_type.name if new_type.new_record?
# end


