# frozen_string_literal: true

class Shift < ApplicationRecord
  self.inheritance_column = :_type_disabled

  enum type: { early: 0, mid: 1, late: 2, night: 3, non_resident_on_call: 4, long_day: 5 }

  belongs_to :worker

  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :type, presence: true

  validate :duration_cannot_be_more_than_24_hours
  validate :ends_at_after_starts_at

  def duration_cannot_be_more_than_24_hours
    return if starts_at.blank? || ends_at.blank?

    errors.add(:ends_at, 'cannot be more than 24 hours after starts_at') if ends_at - starts_at > 24.hours
  end

  def ends_at_after_starts_at
    return if starts_at.blank? || ends_at.blank?

    errors.add(:ends_at, 'must be greater than starts_at') if ends_at <= starts_at
  end
end
