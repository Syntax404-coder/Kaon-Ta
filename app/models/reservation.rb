class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :table

  validates :guest_count, presence: true, numericality: { greater_than: 0 }
  validate :start_time_at_least_two_hours_away
  validate :enough_seats_available

  after_create :decrement_remaining_seats
  after_destroy :increment_remaining_seats

  private

  def start_time_at_least_two_hours_away
    if table && table.start_time <= 2.hours.from_now
      errors.add(:base, "Reservation must be at least 2 hours in advance")
    end
  end

  def enough_seats_available
    if table && guest_count && table.remaining_seats < guest_count
      errors.add(:base, "Not enough seats available")
    end
  end

  def decrement_remaining_seats
    table.update!(remaining_seats: table.remaining_seats - guest_count)
  end

  def increment_remaining_seats
    table.update!(remaining_seats: table.remaining_seats + guest_count)
  end
end
