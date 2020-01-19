RSpec.describe 'most-stops',  vcr: { cassette_name: 'default' } do
  it 'should list the route with the most stops' do
    expect(cmd.status).to eq(0)
    expect(cmd.output.from_yaml).to eq({ 'Green Line B' => 24 })
  end
end
