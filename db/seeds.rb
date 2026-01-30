# Seed script for Kaon Ta! reservation system
# Schedule: Breakfast (07-09), Lunch (11-13), Dinner (18-20)

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

# Clear existing slots before re-seeding
Table.destroy_all

manila_zone = ActiveSupport::TimeZone["Asia/Manila"]

# Fixed hour blocks (24-hour format)
allowed_hours = [7, 8, 9, 11, 12, 13, 18, 19, 20]

# Generate slots for the next 7 days
(0..6).each do |day_offset|
  current_date = manila_zone.now.to_date + day_offset.days

  allowed_hours.each do |hour|
    start_time = manila_zone.local(current_date.year, current_date.month, current_date.day, hour, 0, 0)

    Table.create!(
      start_time: start_time,
      capacity: 10,
      remaining_seats: 10
    )
  end
end

puts "Seeded: #{Table.count} time slots generated"
