require "application_system_test_case"

class BookingFlowTest < ApplicationSystemTestCase
  test "complete booking and cancellation flow" do
    # Step 1: Visit homepage (redirects to login)
    visit root_path
    assert_text "Login"

    # Step 2: Sign up as new user - click the link in the form, not navbar
    click_link "Sign Up", match: :first
    fill_in "Name", with: "Test User"
    fill_in "Email", with: "testuser@example.com"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    click_button "Sign Up"

    assert_text "Logged in"

    # Step 3: Select a date (default is today)
    click_button "Check Availability"
    assert_text "Available Time Slots"

    first(:link, "Book Now").click
    
    # Wait for the next page to load
    assert_selector "input[name='guest_count']"
    
    # Capture the actual table we are booking by reading the URL
    uri = URI.parse(current_url)
    table_id = CGI.parse(uri.query)["table_id"].first
    table = Table.find(table_id)
    initial_seats = table.remaining_seats


    # Step 5: Complete booking with 2 guests
    fill_in "guest_count", with: "2"
    click_button "Confirm Booking"

    assert_text "Reservation confirmed"

    # Verify seats decremented
    table.reload
    assert_equal initial_seats - 2, table.remaining_seats

    # Step 6: Visit My Reservations
    click_link "My Reservations", match: :first
    assert_text "My Reservations"
    assert_selector "table tbody tr", minimum: 1

    # Step 7: Cancel the reservation
    seats_before_cancel = table.remaining_seats
    click_button "Cancel"

    assert_no_button "Cancel"

    # Verify seats restored
    table.reload
    assert_equal seats_before_cancel + 2, table.remaining_seats
  end
end
