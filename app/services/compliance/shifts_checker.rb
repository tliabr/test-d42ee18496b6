# frozen_string_literal: true

module Compliance
  class ShiftsChecker
    attr_reader :shifts

    def initialize(shifts:)
      @shifts = shifts
    end

    def run
      failing_shifts = []
      shifts.each do |shift|
        failing_shifts << shift if shift.ends_at - shift.starts_at > 13.hours
      end

      { max_hours: { fail: failing_shifts.any?, shifts: failing_shifts } }
    end
  end
end
