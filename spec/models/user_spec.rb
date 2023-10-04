require 'rails_helper'

RSpec.describe User, type: :model do
  context 'When a user is created' do
    let(:user) { build :user }
    let(:user1) { build :user, name: user.name, email: user.email }

    it 'Should be a valid user with all attributes' do
      expect(user).to be_valid
    end

    it 'Error if a duplicate user is created' do
      user.save
      expect(user1.save).to eq(false)
      expect { user1.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    
    it 'associations' do
      expect(User.reflect_on_association(:comments).macro).to eq(:has_many)
      expect(User.reflect_on_association(:posts).macro).to eq(:has_many)
      expect(User.reflect_on_association(:likes).macro).to eq(:has_many)
    end
  end
end
