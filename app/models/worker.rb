# frozen_string_literal: true

class Worker < ApplicationRecord
  has_many :shifts, dependent: :destroy

  def full_name
    "#{first_name} #{last_name}"
  end
end
