require 'journey.rb'

describe Journey do
  let(:entry_station) { double(:entry_station) }
  let(:exit_station) { double(:exit_station) }

  it 'is initialized with an empty writeable journeys hash instance variable' do
    expect(subject.journey_hash).to eq({})
  end

  describe '#start_journey' do
    it 'enters the entry_station to the journey hash' do
      subject.start_journey(entry_station)
      expect(subject.journey_hash).to eq({entry_station: entry_station})
    end
  end

  describe '#finish_journey' do
    it 'enters the exit_station to the journey hash' do
      subject.start_journey(entry_station)
      subject.finish_journey(exit_station)
      expect(subject.journey_hash).to eq({
        entry_station: entry_station,
        exit_station: exit_station                
      })
    end
  end

  describe '#reset_journey' do
    it 'resets the journey hash to empty' do
      subject.start_journey(entry_station)
      subject.finish_journey(exit_station)
      subject.reset_journey
      expect(subject.journey_hash).to eq({})
    end       
  end

  describe '#journey_complete?' do
    it 'returns false when journey is not complete because of no finish' do
      subject.start_journey(entry_station)
      expect(subject).not_to be_journey_complete
    end
    it 'returns false when journey is not complete because of no beginning' do
      subject.finish_journey(exit_station)
      expect(subject).not_to be_journey_complete
    end
    it 'returns true when journey is complete' do
      subject.start_journey(entry_station)
      subject.finish_journey(exit_station)
      expect(subject).to be_journey_complete
    end
  end

  describe '#fare' do
    it 'returns the minimum fare when no charges occur' do
      subject.start_journey(entry_station)
      subject.finish_journey(exit_station)
      expect(subject.fare).to eq(Oystercard::MIN_FAIR)
    end
    it 'returns penalty fare when there is no entry station' do
      subject.start_journey(entry_station)
      expect(subject.fare).to eq(Oystercard::PENALTY)
    end
    it 'returns penalty fare when there is no exit station' do
      subject.finish_journey(exit_station)
      expect(subject.fare).to eq(Oystercard::PENALTY)
    end
  end
end