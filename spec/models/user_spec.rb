require 'rails_helper'

RSpec.describe User, type: :model do
  
  subject { FactoryBot.build(:user) }

  before { subject.save }

  it 'username should be present' do
    subject.username = nil
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

  it 'coin5 should be integer' do
    expect(subject.coin5).to be_a(Integer)
    subject.coin5 = 12.7
    expect(subject).to_not be_valid
  end

  it 'coin10 should be integer' do
    expect(subject.coin10).to be_a(Integer)
    subject.coin10 = 12.7
    expect(subject).to_not be_valid
  end

  it 'coin20 should be integer' do
    expect(subject.coin20).to be_a(Integer)
    subject.coin20 = 12.7
    expect(subject).to_not be_valid
  end

  it 'coin50 should be integer' do
    expect(subject.coin50).to be_a(Integer)
    subject.coin50 = 12.7
    expect(subject).to_not be_valid
  end

  it 'coin100 should be integer' do
    expect(subject.coin100).to be_a(Integer)
    subject.coin100 = 12.7
    expect(subject).to_not be_valid
  end

  it 'role should be present' do
    subject.role = nil
    expect(subject).to_not be_valid
    subject.role = "buyer"
    expect(subject).to be_valid
  end

end
