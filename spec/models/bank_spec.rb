require 'rails_helper'

RSpec.describe Bank, type: :model do
  describe 'validation fields' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(50) }
  end

  describe 'validation fields with data' do
    context 'when lenght is correct' do
      let!(:bank) { create(:bank) }

      it { should validate_length_of(:bank) }
    end
  end
end
