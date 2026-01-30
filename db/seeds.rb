# Only seed if tables are empty (idempotent for production)
if User.count == 0
  # Create admin user
  User.create!(
    name: "Admin User",
    email: "admin@kaonta.com",
    password: "password123",
    role: :admin
  )

  # Create customer user
  User.create!(
    name: "Test Customer",
    email: "customer@example.com",
    password: "password123",
    role: :customer
  )

  puts "Seeded: 2 users"
end

if Table.count == 0
  # Create time slots for the next 7 days
  (1..7).each do |day|
    [12, 18, 20].each do |hour|
      Table.create!(
        start_time: day.days.from_now.change(hour: hour, min: 0),
        capacity: 10,
        remaining_seats: 10
      )
    end
  end

  puts "Seeded: #{Table.count} time slots"
end
