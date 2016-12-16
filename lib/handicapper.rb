require 'handicapper/version'
require 'handicapper/round_settings'

module Handicapper
  class << self
    def round_settings(course_rating, slope_rating, holes_par)
      RoundSettings.new(course_rating, slope_rating, holes_par)
    end

    def calculator(differentials = [])
      HandicapCalculator.new(differentials)
    end
  end
end
