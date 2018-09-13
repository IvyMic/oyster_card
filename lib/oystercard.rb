class Oystercard

  attr_reader :balance, :journeys
  MAXIMUM = 90
  MIN_FAIR = 1

  def initialize
    @balance = 0
    @journeys = []
  end

  def top_up(money)
    fail 'Unable to top up,maximum #{Oystercard::MAXIMUM} reached'if balance + money > MAXIMUM
      @balance += money
  end

  def touch_in(station)
    fail 'Insufficient funds' if balance < MIN_FAIR
    @in_journey = true
    @journeys << {entry_station: station}
  end

  def touch_out(exit_station)
    @journeys[-1][:exit_station] = exit_station
    #@exit_station = exit_station
    deduct(MIN_FAIR)
  end

  def in_journey?
    !(@journeys[-1].has_key? :exit_station)
  end

  private

  def deduct(money)
    @balance -= money
  end

end