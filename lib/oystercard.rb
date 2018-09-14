require "journey.rb"
class Oystercard

  attr_reader :balance, :journeys_history, :journey
  MAXIMUM = 90
  MIN_FAIR = 1
  PENALTY = 6
  #plan: touchin sets the entry station, touch out sets
  #exit station. on touch out call fare to charge customer
  #and also set entry/exit to nil 
  def initialize(journey = Journey.new)
    @balance = 0
    @journey = journey
    @journeys_history = []
  end

  def top_up(money)
    fail 'Unable to top up,maximum #{Oystercard::MAXIMUM} reached'if balance + money > MAXIMUM
    @balance += money
  end

  def touch_in(station)
    fail 'Insufficient funds' if balance < MIN_FAIR
    @journey.start_journey(station)
  end

  def touch_out(exit_station)
    @journey.finish_journey(exit_station)
    @journeys_history << @journey.journey_hash
    deduct(journey.fare)
  end

  private

  def deduct(money)
    @balance -= money
  end

end