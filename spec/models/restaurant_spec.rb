# require 'rails_helper'

# RSpec.describe Restaurant, type: :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end

require 'spec_helper'

describe Restaurant, type: :model do
  it { is_expected.to have_many :reviews }

  it 'is not valid with a name of less than three characters' do
    restaurant = Restaurant.new(name: 'Th')
    expect(restaurant).to have(1).error_on(:name)
    expect(restaurant).not_to be_valid
  end

end
