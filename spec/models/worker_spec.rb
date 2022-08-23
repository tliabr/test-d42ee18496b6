# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Worker, type: :model do
  it { is_expected.to have_many(:shifts) }

  describe '#full_name' do
    subject(:full_name) { worker.full_name }

    let(:worker) { build_stubbed(:worker, first_name: 'Jane', last_name: 'Doe') }

    it { is_expected.to eq 'Jane Doe' }
  end
end
