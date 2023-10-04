require 'rails_helper'

RSpec.describe Post, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  context 'when post is created' do
    it 'is created' do
      post = FactoryBot.create(:post)
      expect(post).to be_valid
    end
  end
end
