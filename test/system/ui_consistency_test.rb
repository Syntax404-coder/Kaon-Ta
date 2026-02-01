require "application_system_test_case"

class UiConsistencyTest < ApplicationSystemTestCase
  test "login page shows login and sign up buttons" do
    visit login_path

    assert_selector "input[type='submit'][value='Login']"
    assert_selector "a", text: "Sign Up"
  end

  test "customer navigation shows correct links after login" do
    # Create test customer with unique email
    email = "uitest_#{Time.now.to_i}@example.com"
    user = User.create!(
      name: "Test Customer",
      email: email,
      password: "password123",
      role: :customer
    )

    visit login_path
    fill_in "email", with: email
    fill_in "password", with: "password123"

    # Click the submit button explicitly
    find("input[type='submit']").click

    # Wait for Turbo navigation to complete by checking we left the login page
    assert_no_selector "h1", text: "Login"
    assert_text "Logged in"

    # Verify customer navigation elements
    assert_selector "a", text: "Time Slots"
    assert_selector "a", text: "My Reservations"
    assert_selector "input[value='Check Availability']"

    # Click Check Availability and verify page loads
    click_button "Check Availability"
    assert_text "Available Time Slots"
  end
end
