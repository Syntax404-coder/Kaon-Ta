require "application_system_test_case"

class BookingFlowTest < ApplicationSystemTestCase
  test "complete booking and cancellation flow" do
    # Step 1: Visit homepage
    visit root_path
    assert_text "Login"

    # Step 2: Sign up as new user
    click_on "Sign Up"
    fill_in "Name", with: "Test User"
    fill_in "Email", with: "testuser@example.com"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    click_on "Sign Up"

    assert_text "Logged in"

    # Step 3: Select a date (default is today)
    click_on "Check Availability"
    assert_text "Available Time Slots"

    # Step 4: Find a slot and book it
    # Get a table that has availability and is at least 2 hours away
    table = Table.where("remaining_seats > 0 AND start_time > ?", 2.hours.from_now).first
    skip "No available slots for testing" if table.nil?

    initial_seats = table.remaining_seats

    # Click Book Now for the first available slot
    within("table tbody tr", match: :first) do
      click_on "Book Now"
    end

    # Step 5: Complete booking with 2 guests
    fill_in "guest_count", with: "2"
    click_on "Confirm Booking"

    assert_text "Reservation confirmed"

    # Verify seats decremented
    table.reload
    assert_equal initial_seats - 2, table.remaining_seats

    # Step 6: Visit My Reservations
    click_on "My Reservations"
    assert_text "My Reservations"
    assert_selector "table tbody tr", minimum: 1

    # Step 7: Cancel the reservation
    seats_before_cancel = table.remaining_seats
    click_on "Cancel"

    assert_text "cancelled"

    # Verify seats restored
    table.reload
    assert_equal seats_before_cancel + 2, table.remaining_seats
  end
end
