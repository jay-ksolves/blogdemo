require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  context 'When a user is created' do
    let(:user) { build :user }
    let(:user1) { build :user, name: user.name, email: user.email }

    it 'Should be a valid user with all attributes' do
      # expect(user.valid?).to eq(true)
      expect(user).to be_valid
      # expect(user.valid?).to  eq(false) #done if user is valid this test case will fails
    end

    it 'Error if a dublicate user is created' do
      user.save
      # debugger
      expect(user1.save).to eq(false)
      expect { user1.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
