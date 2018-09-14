require 'oystercard'

describe Oystercard do
  let(:station) {double(:station)}
  let(:exit_station){double(:exit_station)}
  let(:journey){double(:journey)}
  it{is_expected.to respond_to(:journey)}
  it "defaults the balance to 0" do
    expect(subject.balance).to eq 0
  end

  it {expect(subject).to respond_to(:journeys_history)}


  it "checks journeys_history is empty by default" do
    expect(subject.journeys_history).to be_empty
  end

  describe '#top_up' do
    it "adds amount to balance" do
      subject.top_up(10)
      expect(subject.balance).to eq 10
    end
    it "raises error when topping up beyond maximum allowed balance" do
      allow(subject).to receive(:balance) {described_class::MAXIMUM}
      expect{subject.top_up(1)}.to raise_error ('Unable to top up,maximum #{Oystercard::MAXIMUM} reached')
    end
  
  end

  describe "#touch_in" do

    it "raises error when credit is less then minimum fare" do
      subject.top_up(0.9)
      expect{subject.touch_in(station)}.to raise_error('Insufficient funds')
    end

    it "creates a hash of the entry stations to journey's journey_hash" do
      card = Oystercard.new(journey)
      allow(journey).to receive(:start_journey).with(station).and_return({entry_station: station})
      card.top_up(10)
      card.touch_in(station)
      expect(card.journey.start_journey(station)).to eq({entry_station: station})
    end

  end

  describe "#touch_out" do

    it "deducts minimum fair from balance when touched out" do
      subject.top_up(10)
      subject.touch_in(station)
      expect{subject.touch_out(exit_station)}.to change{subject.balance}.by (-described_class::MIN_FAIR)
    end

    it "adding exit_station key value pair to journeys_history" do
      subject.top_up(10)
      subject.touch_in(station)
      subject.touch_out(exit_station)
      expect(subject.journeys_history).to eq([{entry_station: station,
        exit_station: exit_station}])
    end

  end

end