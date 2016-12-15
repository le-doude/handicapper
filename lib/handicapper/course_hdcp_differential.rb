module Handicapper
  module CourseHdcpDifferential
    def self.included(klass)
      klass.class_eval do
        attr :course_rating, :slope_rating
      end
    end

    STANDARD_DIFFICULTY_STANDARD = 113.0

    def handicap_differential(total_score)
      fail ArgumentError, 'Need a valid score for calculating differential' unless total_score.is_a?(Numeric)
      result = total_score.to_f / course_rating
      result *= STANDARD_DIFFICULTY_STANDARD / slope_rating
      result.round(1)
    end
  end
end
