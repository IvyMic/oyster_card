require 'station'

describe Station do

  it {expect(subject).to respond_to(:name)}
  it {expect(subject).to respond_to(:zone)}
  let(:name){double("name")}
  let(:zone){double("zone")}
  subject{Station.new(:name, :zone)}
  it " initializes name with arguments given"do
    expect(subject.name).to eq(:name)
  end

  it "initializes zone with agruments given" do
    expect(subject.zone).to eq(:zone)
  end

end