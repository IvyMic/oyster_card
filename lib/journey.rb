require_relative "oystercard.rb"
class Journey
  attr_reader :journey_hash
  def initialize
    @journey_hash = {}
  end

  def start_journey(entry_station)
    @journey_hash[:entry_station] = entry_station
  end

  def finish_journey(exit_station)
    @journey_hash[:exit_station] = exit_station
  end

  def reset_journey
    @journey_hash = {}
  end

  def journey_complete?
    !(no_touch_in || no_touch_out)
  end

  def fare 
    return Oystercard::PENALTY if !journey_complete?
    Oystercard::MIN_FAIR
  end

  private
    def no_touch_out
      !@journey_hash.has_key?(:exit_station)
    end
    def no_touch_in
      !@journey_hash.has_key?(:entry_station)
    end
end