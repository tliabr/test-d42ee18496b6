# frozen_string_literal: true

FactoryBot.define do
  factory :shift do
    worker
    starts_at { '2022-08-10 11:00:00' }
    ends_at { '2022-08-10 15:00:00' }
    type { :mid }
  end
end
