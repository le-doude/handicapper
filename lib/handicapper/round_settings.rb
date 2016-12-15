module Handicapper

  class RoundSettings
    include EquitableStrokeControl
    include CourseHdcpDifferential

    def new(course_rating, slope_rating, par_scores)
      @course_rating = course_rating
      @slope_rating = slope_rating
      @par_scores = par_scores
    end

  end

end
