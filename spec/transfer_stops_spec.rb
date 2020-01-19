# frozen_string_literal: true

RSpec.describe 'transfer-stops', vcr: { cassette_name: 'default' } do
  it 'should list all transfer stops' do
    expect(cmd.status).to eq(0)

    transfers = cmd.output.from_yaml
    expect(transfers.size).to be >= 10
    expect(transfers).to include('Kenmore')

    expect(transfers).to include('State')
    expect(transfers['State']).to match_array([
                                                'Blue Line',
                                                'Orange Line'
                                              ])

    expect(transfers).to include('Park Street')
    expect(transfers['Park Street']).to match_array([
                                                      'Red Line',
                                                      'Green Line B',
                                                      'Green Line C',
                                                      'Green Line D',
                                                      'Green Line E'
                                                    ])

    expect(transfers).to include('Kenmore')
    expect(transfers['Kenmore']).to match_array([
                                                  'Green Line B',
                                                  'Green Line C',
                                                  'Green Line D'
                                                ])

    expect(transfers).not_to include(match(/Alewife/))  # Not a transfer stop
    expect(transfers).not_to include(match(/Aquarium/)) # Not a transfer stop
  end
end
