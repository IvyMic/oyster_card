require 'oystercard'

describe Oystercard do
  let(:station) {double("station_new")}
  let(:exit_station){double("Station")}
  it "defaults the balance to 0" do
    expect(subject.balance).to eq 0
  end

  it {expect(subject).to respond_to(:journeys)}


  it "checks journeys is empty by default" do
    expect(subject.journeys).to be_empty
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

    it "raises error when credit is less then £1 minimum fare" do
      subject.top_up(0.9)
      expect{subject.touch_in(:station)}.to raise_error('Insufficient funds')
    end

    it "pushes a hash of the entry stations to journeys array" do
      subject.top_up(10)
      subject.touch_in(:station)
      expect(subject.journeys).to eq([{entry_station: :station}])
    end

  end

  describe "#touch_out" do
    it "touches out oystercard" do
      subject.top_up(10)
      subject.touch_in(:station)
      subject.touch_out(:exit_station)
      expect(subject.in_journey?).to eq(false)
    end

    it "deducts minimum fair from balance when touched out" do
      subject.top_up(10)
      subject.touch_in(:station)
      expect{subject.touch_out(:exit_station)}.to change{subject.balance}.by (-described_class::MIN_FAIR)
    end

    it "adding exit_station key value pair to journeys" do
      subject.top_up(10)
      subject.touch_in(:station)
      subject.touch_out(:exit_station)
      expect(subject.journeys).to eq([{entry_station: :station,
        exit_station: :exit_station}])
    end

  end

  describe "#in_journey?" do
    it "it returns true when touched in" do
      subject.top_up(10)
      subject.touch_in(:station)
      expect(subject.in_journey?).to eq(true)
    end
  end

end