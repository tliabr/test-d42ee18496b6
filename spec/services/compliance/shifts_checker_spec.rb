# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Compliance::ShiftsChecker do
  before { freeze_time }

  describe '#run' do
    let(:worker) { create(:worker) }

    context 'when a shift length is greater than 13 hours' do
      it 'returns the offending shift with the max_hours rule' do
        shift1 = create(:shift, starts_at: Time.zone.parse('1st August 2022 08:00'),
                                ends_at: Time.zone.parse('1st August 2022 16:00'),
                                worker: worker, type: :long_day)
        shift2 = create(:shift, starts_at: Time.zone.parse('2nd August 2022 08:00'),
                                ends_at: Time.zone.parse('2nd August 2022 22:00'),
                                worker: worker, type: :long_day)

        result = described_class.new(shifts: [shift1, shift2]).run

        expect(result).to include(
          {
            max_hours: {
              fail: true,
              shifts: [shift2]
            }
          }
        )
      end
    end

    context 'when there are no shifts longer then 13 hours' do
      it 'returns the compliance rule without any failing shifts' do
        shift = create(:shift, starts_at: Time.zone.parse('1st August 2022 08:00'),
                               ends_at: Time.zone.parse('1st August 2022 16:00'),
                               worker: worker, type: :long_day)

        result = described_class.new(shifts: [shift]).run

        expect(result).to include(
          {
            max_hours: {
              fail: false,
              shifts: []
            }
          }
        )
      end
    end
  end
end
