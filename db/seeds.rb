require 'csv'

# before running "rake db:seed", do the following:
# - put the "rails-engine-development.pgdump" file in db/data/
# - put the "items.csv" file in db/data/

cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $(whoami) -d rails-engine_development db/data/rails-engine-development.pgdump"
puts "Loading PostgreSQL Data dump into local database with command:"
puts cmd
system(cmd)

csv_text = File.read(Rails.root.join("db", "data", "items.csv"))
csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
csv.each do |item|
  i = Item.new
  i.id = item["id"]
  i.name = item["name"]
  i.description = item["description"]
  i.unit_price = item["unit_price"]
  i.merchant_id = item["merchant_id"]
  i.created_at = item["created_at"]
  i.updated_at = item["updated_at"]
  i.save
end

#this sets all the id for all tables to be the max values in the table. So that when you generate a new record, it will do so after the last record id. (rather than start 0)
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end





# TODO
# - Import the CSV data into the Items table
# - Add code to reset the primary key sequences on all 6 tables (merchants, items, customers, invoices, invoice_items, transactions)