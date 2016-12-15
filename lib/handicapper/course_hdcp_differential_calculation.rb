module Handicapper
  module CourseHdcpDifferentialCalculation
    def self.included(klass)
      klass.class_eval do
        attr :course_rating, :slope_rating
      end
    end

    STANDARD_DIFFICULTY_STANDARD = 113

    def handicap_differential(total_score)
      (total_score / course_rating) * (STANDARD_DIFFICULTY_STANDARD / slope_rating).round(half: :up)
    end
  end
end
