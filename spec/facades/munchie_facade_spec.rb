require 'rails_helper'

RSpec.describe MunchiesFacade do
  it 'creates a Munchie object' do
    params = {
      start: 'denver,co',
      destination: 'pueblo,co',
      food: 'hamburger'
    }

    munchie = MunchiesFacade.munchie(params)

    expect(munchie).to be_a(Munchie)
  end
end
