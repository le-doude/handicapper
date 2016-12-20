module Handicapper
  module CourseHdcpDifferential
    def self.included(klass)
      klass.class_eval do
        attr :course_rating, :slope_rating
      end
    end

    STANDARD_DIFFICULTY_STANDARD = 113.0

    def handicap_differential(adjusted_gross_score)
      fail ArgumentError, 'Need a valid score for calculating differential' unless adjusted_gross_score.is_a?(Numeric)
      result = adjusted_gross_score.to_f - course_rating.to_f
      result *= STANDARD_DIFFICULTY_STANDARD
      result /= slope_rating.to_f
      result.round(1)
    end
  end
end
