# frozen_string_literal: true

RSpec.describe 'fewest-stops', vcr: { cassette_name: 'default' } do
  it 'should list the route with the fewest stops' do
    expect(cmd.status).to eq(0)
    expect(cmd.output.from_yaml).to eq('Mattapan Trolley' => 8)
  end
end
