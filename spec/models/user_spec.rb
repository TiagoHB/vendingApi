require 'rails_helper'

RSpec.describe User, type: :model do
  
  subject { FactoryBot.build(:user) }

  before { subject.save }

  it 'email should be present' do
    subject.email = nil
    expect(subject).to_not be_valid
  end

  it 'password should be present' do
    subject.password = ""
    expect(subject).to_not be_valid
  end

  it 'password should have min length of 6' do
    subject.password = "12345"
    expect(subject).to_not be_valid
  end
end
