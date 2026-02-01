class TableGenerator
  BREAKFAST_HOURS = [ 7, 8, 9, 10 ]
  LUNCH_HOURS = [ 11, 12, 13, 14 ]
  DINNER_HOURS = [ 18, 19, 20, 21 ]
  ALL_HOURS = BREAKFAST_HOURS + LUNCH_HOURS + DINNER_HOURS

  def self.generate_for_date(date)
    # Ensure all slots exist for this date
    ALL_HOURS.each do |hour|
      # Construct time in Manila zone, similar to seeds
      slot_time = Time.zone.local(date.year, date.month, date.day, hour, 0, 0)
      
      # Idempotent check: Do not duplicate if exists logic is handled by find_or_create logic or explicit check
      # Note: We query by start_time.
      next if Table.where(start_time: slot_time).exists?

      Table.create!(
        start_time: slot_time,
        capacity: 10,
        remaining_seats: 10
      )
    end
  end
end
