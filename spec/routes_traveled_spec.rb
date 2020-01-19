# frozen_string_literal: true

RSpec.describe 'routes-traveled', vcr: { cassette_name: 'default' } do
  context 'valid args' do
    before (:each) do
      expect(cmd.status).to eq(0)
    end

    describe 'routes-traveled Davis Harvard' do
      it do
        expect(cmd.output.from_yaml).to eq(['Red Line'])
      end
    end

    describe 'routes-traveled "Park Street" Davis' do
      it do
        expect(cmd.output.from_yaml).to eq(['Red Line'])
      end
    end

    describe 'routes-traveled park ashmont' do
      it 'should fuzzy match stop names' do
        expect(cmd.output.from_yaml).to eq(['Red Line'])
      end
    end

    describe 'routes-traveled "Park St" "Downtown Crossing"' do
      it do
        expect(cmd.output.from_yaml).to eq(['Red Line'])
      end
    end

    describe 'routes-traveled State Haymarket' do
      it do
        expect(cmd.output.from_yaml).to eq(['Orange Line'])
      end
    end

    describe 'routes-traveled Chinatown Airport' do
      it do
        expect(cmd.output.from_yaml).to eq(['Orange Line', 'Blue Line'])
      end
    end

    describe 'routes-traveled Airport Chinatown' do
      it do
        expect(cmd.output.from_yaml).to eq(['Blue Line', 'Orange Line'])
      end
    end

    describe 'routes-traveled "Boston College" Arlington' do
      it do
        expect(cmd.output.from_yaml).to eq(['Green Line B'])
      end
    end

    describe 'routes-traveled Fenway "Boston College"' do
      it do
        expect(cmd.output.from_yaml).to eq(['Green Line D', 'Green Line B'])
      end
    end

    describe 'routes-traveled Symphony Kenmore' do
      it do
        expect(cmd.output.from_yaml).to match(['Green Line E', /^Green Line [BCD]$/])
      end
    end

    describe 'routes-traveled State Park' do
      it do
        expect(cmd.output.from_yaml).to match(['Orange Line', 'Red Line']).or \
          match(['Blue Line', /^Green Line [CDE]$/])
      end
    end

    describe 'routes-traveled Maverick Central' do
      it do
        match_route1 = match(['Blue Line', 'Orange Line', 'Red Line'])
        match_route2 = match(['Blue Line', /^Green Line [CDE]$/, 'Red Line'])

        expect(cmd.output.from_yaml).to match_route1.or match_route2
      end
    end
  end

  context 'invalid args' do
    before(:each) do
      expect(cmd.status).to eq(1)
    end

    describe 'routes-traveled "Invalid" Braintree' do
      it do
        expect(cmd.stderr).to match(/Unknown stop: Invalid/)
      end
    end
  end
end
