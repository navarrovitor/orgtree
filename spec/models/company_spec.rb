require 'rails_helper'

RSpec.describe Company, type: :model do
  it 'is valid with a name' do
    expect(Company.new(name: 'ABCorp')).to be_valid
  end

  it 'is invalid without a name' do
    expect(Company.new).not_to be_valid
  end
end
