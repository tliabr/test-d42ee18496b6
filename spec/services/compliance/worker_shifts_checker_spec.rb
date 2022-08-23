# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Compliance::WorkerShiftsChecker do
  describe '#run' do
    context 'when running against a specific worker' do
      let(:worker) { create(:worker) }
      let(:worker2) { create(:worker) }

      before { create(:shift, worker: worker2) }

      it 'calls the ShiftsChecker with shifts for that worker' do
        shift1 = create(:shift, worker: worker)
        shift2 = create(:shift, worker: worker)

        mock_checker = instance_double(Compliance::ShiftsChecker, run: {})
        allow(Compliance::ShiftsChecker).to receive(:new).and_return(mock_checker)

        described_class.new(worker: worker).run

        expect(Compliance::ShiftsChecker).to have_received(:new).with(shifts: [shift1, shift2])
      end
    end

    context 'when the shifts checker returns with no failures' do
      it 'returns no breaches' do
        worker = build_stubbed(:worker, shifts: [])

        mock_checker = instance_double(Compliance::ShiftsChecker, run: { max_hours: { fail: false, shifts: [] } })
        allow(Compliance::ShiftsChecker).to receive(:new).and_return(mock_checker)

        result = described_class.new(worker: worker).run
        expect(result).to eq({ breaches: {} })
      end
    end

    it 'checks if the workers shifts are compliant' do
      worker = create(:worker)
      create(:shift, starts_at: Time.zone.parse('1st August 2022 08:00'),
                     ends_at: Time.zone.parse('1st August 2022 16:00'),
                     worker: worker, type: :long_day)
      very_long_shift = create(:shift, starts_at: Time.zone.parse('2nd August 2022 08:00'),
                                       ends_at: Time.zone.parse('2nd August 2022 22:00'),
                                       worker: worker, type: :long_day)

      result = described_class.new(worker: worker).run
      expect(result).to eq({ breaches: { max_hours: [very_long_shift] } })
    end
  end
end
