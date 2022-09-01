# frozen_string_literal: true

module Compliance
  class ShiftsChecker
    attr_reader :shifts, :workers

    def initialize(shifts:, workers:)
      @shifts = shifts
      @workers = workers
    end

    def run
      failing_shifts = []

      #To group every worker's shifts
      workers_shifts = []

      #Checking if wach individual shift is longer than 13 hours
      shifts.each do |shift|
        failing_shifts << shift if shift.ends_at - shift.starts_at > 13.hours
      end

      #grouping worker's shifts
      workers.each do |worker|
        workers_shifts << Shift.where(worker: worker)
      #I now have to group by the day to check the starts_at and ends_at of each day of every worker
      end

      { max_hours: { fail: failing_shifts.any?, shifts: failing_shifts } }
    end
  end
end
