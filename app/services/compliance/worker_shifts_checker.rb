# frozen_string_literal: true

module Compliance
  class WorkerShiftsChecker
    attr_reader :worker

    def initialize(worker:)
      @worker = worker
    end

    def run
      breaches = {}

      checker_result = Compliance::ShiftsChecker.new(shifts: worker.shifts).run
      checker_result.each do |rule, rule_result|
        next unless rule_result[:fail]

        breaches[rule] = rule_result[:shifts]
      end

      { breaches: breaches }
    end
  end
end
