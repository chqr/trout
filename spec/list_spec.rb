# frozen_string_literal: true

RSpec.describe 'list', vcr: { cassette_name: 'default' } do
  it 'should list all subway routes' do
    expect(cmd.status).to eq(0)
    routes = cmd.output.from_yaml

    expect(routes.size).to be >= 7
    expect(routes).to include('Red Line')
    expect(routes).to include('Orange Line')
    expect(routes).to include('Green Line B')
    expect(routes).to include('Green Line C')
    expect(routes).to include('Green Line D')
    expect(routes).to include('Green Line E')
    expect(routes).to include('Blue Line')

    expect(routes).not_to include(match(/Silver/))    # Don't include bus route
    expect(routes).not_to include(match(/Fitchburg/)) # Or commuter rail
  end

  context 'invalid argument' do
    let(:args) { '--invalid' }

    it 'should fail' do
      expect(cmd.status).not_to eq(0)
    end
  end
end
