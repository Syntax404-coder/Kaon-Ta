require "test_helper"

class ReservationCancellationTest < ActionDispatch::IntegrationTest
  test "should destroy reservation and return turbo stream" do
    # Create user and table
    user = User.create!(name: "Test User", email: "test@example.com", password: "password", role: :customer)
    table = Table.create!(capacity: 4, remaining_seats: 4, start_time: 2.hours.from_now + 1.minute) # Must be > 2 hours away

    # Create reservation
    reservation = Reservation.create!(user: user, table: table, guest_count: 2)

    # Log in
    post login_path, params: { email: user.email, password: "password" }

    # Send delete request with Turbo Stream format
    assert_difference("Reservation.count", -1) do
      delete reservation_path(reservation), as: :turbo_stream
    end

    assert_response :success
    assert_match /turbo-stream action="remove"/, response.body
  end
end
