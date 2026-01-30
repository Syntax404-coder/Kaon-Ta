require "application_system_test_case"

class UiConsistencyTest < ApplicationSystemTestCase
  test "login page shows login and sign up buttons" do
    visit login_path

    assert_selector "input[type='submit'][value='Login']"
    assert_link "Sign Up"
  end

  test "customer navigation shows correct links after login" do
    # Create test customer
    user = User.create!(
      name: "Test Customer",
      email: "uitest@example.com",
      password: "password123",
      role: :customer
    )

    visit login_path
    fill_in "email", with: "uitest@example.com"
    fill_in "password", with: "password123"
    click_on "Login"

    assert_text "Logged in"

    # Verify customer navigation elements
    assert_link "Time Slots"
    assert_link "My Reservations"
    assert_selector "input[value='Check Availability']"

    # Click Check Availability and verify page loads
    click_on "Check Availability"
    assert_text "Available Time Slots"
  end
end
