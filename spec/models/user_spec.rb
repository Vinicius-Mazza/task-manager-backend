require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it { is_expected.to have_many(:tasks).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:email) }
  # it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to allow_value('emailaleatorio@email.com').for(:email) }
  it { is_expected.to validate_uniqueness_of(:auth_token) }

  describe '#info' do
    it 'returns email and created_at' do
      user.save!
      allow(Devise).to receive(:friendly_token).and_return('abc123xzzTOKEN')

      expect(user.info).to eq("#{user.email} - #{user.created_at} - Token: abc123xzzTOKEN")
    end
  end

  describe '#generate_athentication_token!' do
    it 'generates a unique auth token' do
      allow(Devise).to receive(:friendly_token).and_return('abc123xzzTOKEN')
      user.generate_athentication_token!

      expect(user.auth_token).to eq('abc123xzzTOKEN')
    end

    it 'generates another auth token when the current auth token already has been taken' do
      allow(Devise).to receive(:friendly_token).and_return('abc321zzxtoken', 'abc321zzxtoken', 'abcXYZ987654321')
      existing_user = create(:user, auth_token: 'abc321zzxtoken')
      user.generate_athentication_token!
      
      expect(user.auth_token).not_to eq(existing_user.auth_token)
    end
  end
end
