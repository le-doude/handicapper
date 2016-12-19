require 'handicapper/round_settings'

module Faking
  class << self

    def scores(holes = 18, min =1, max=20)
      holes.times.map { (min..max).to_a.sample }
    end

    def total_score(holes = 18)
      scores(holes= holes).inject(:+)
    end

    def round_settings(holes = 18)
      Handicapper::RoundSettings.new(
        (100.0..155.0).step(0.1).to_a.sample,
        (60.0..85.0).step(0.1).to_a.sample,
        holes.times.map { [3, 4, 5].sample }
      )
    end

    def differentials(n = 1)
      n.times.map { (-5.0..45.0).step(0.1).to_a.sample.round(5) }
    end

  end
end
