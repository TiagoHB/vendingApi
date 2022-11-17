require 'rails_helper'

RSpec.describe Product, type: :model do
  
  subject { FactoryBot.build(:product) }

  before { subject.save }

  it 'productName should be present' do
    subject.productName = nil
    expect(subject).to_not be_valid
  end

  it 'cost should be present' do
    subject.cost = nil
    expect(subject).to_not be_valid
  end

  it 'amountAvailable should be present' do
    subject.amountAvailable = nil
    expect(subject).to_not be_valid
  end

  it 'seller should be present' do
    subject.seller = nil
    expect(subject).to_not be_valid
  end

  it 'cost should be integer' do
    expect(subject.cost).to be_a(Integer)
    subject.cost = 12.7
    expect(subject).to_not be_valid
  end

  it 'amountAvailable should be integer' do
    expect(subject.amountAvailable).to be_a(Integer)
    subject.amountAvailable = 12.4
    expect(subject).to_not be_valid
  end

  it 'cost should be multiple of 5' do
    subject.cost = 12
    expect(subject).to_not be_valid
  end
end
