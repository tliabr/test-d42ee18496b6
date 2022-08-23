# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shift, type: :model do
  it { is_expected.to belong_to(:worker) }

  it { is_expected.to define_enum_for(:type).with_values(%i[early mid late night non_resident_on_call long_day]) }

  it { is_expected.to validate_presence_of(:starts_at) }
  it { is_expected.to validate_presence_of(:ends_at) }
  it { is_expected.to validate_presence_of(:type) }

  it 'validates that ends_at is no more than 24 hours after starts_at', :aggregate_failures do
    freeze_time
    shift = build_stubbed(:shift, starts_at: Time.zone.now, ends_at: 25.hours.from_now)

    expect(shift).not_to be_valid
    expect(shift.errors[:ends_at]).to contain_exactly('cannot be more than 24 hours after starts_at')
  end

  it 'validates that ends_at is after starts_at', :aggregate_failures do
    freeze_time
    shift = build_stubbed(:shift, starts_at: Time.zone.now, ends_at: 1.minute.ago)

    expect(shift).not_to be_valid
    expect(shift.errors[:ends_at]).to contain_exactly('must be greater than starts_at')
  end
end
