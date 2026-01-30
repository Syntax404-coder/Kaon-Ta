# Seed script for Kaon Ta! reservation system

# Create default users if none exist
if User.count == 0
  User.create!(
    name: "Admin User",
    email: "admin@kaonta.com",
    password: "password123",
    role: :admin
  )

  User.create!(
    name: "Test Customer",
    email: "customer@example.com",
    password: "password123",
    role: :customer
  )

  puts "Seeded: Default users created"
end

# Wipe all existing slots
Table.destroy_all

# Operating Hours (Manila Time)
# Breakfast: 7, 8, 9, 10
# Lunch: 11, 12, 13, 14 (2 PM)
# Dinner: 18 (6 PM), 19, 20, 21 (9 PM)
OPEN_HOURS = [7, 8, 9, 10, 11, 12, 13, 14, 18, 19, 20, 21]

manila_zone = ActiveSupport::TimeZone["Asia/Manila"]

(0..7).each do |day_offset|
  current_date = manila_zone.now.to_date + day_offset.days

  OPEN_HOURS.each do |hour|
    start_time = manila_zone.local(current_date.year, current_date.month, current_date.day, hour, 0, 0)

    Table.create!(
      start_time: start_time,
      capacity: 10,
      remaining_seats: 10
    )
  end
end

puts "Seeded: #{Table.count} time slots created"
