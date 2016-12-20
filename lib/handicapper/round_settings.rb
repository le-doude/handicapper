module Handicapper
  class RoundSettings
    attr :par_scores, :course_rating, :slope_rating

    STANDARD_DIFFICULTY = 113.0

    def initialize(course_rating, slope_rating, par_scores)
      @course_rating = course_rating.to_f
      @slope_rating = slope_rating.to_f
      @par_scores = par_scores
    end

    # @param [Fixnum] course_handicap
    # @param [Array] scores is an array of ints representing the gross scores per hole from the round being scored
    # @return [Fixnum] return a int representing the adjusted score for the round using the ESC rules from USGA
    def adjust_gross_scores(course_handicap, scores)
      fail ArgumentError, 'Need as many scores ase there is holes' unless scores && scores.size == par_scores.size
      @par_scores.zip(scores).map(&make_adjuster(course_handicap)).inject(&:+)
    end


    def handicap_differential(adjusted_gross_score)
      fail ArgumentError, 'Need a valid score for calculating differential' unless adjusted_gross_score.is_a?(Numeric)
      result = adjusted_gross_score.to_f - course_rating.to_f
      result *= STANDARD_DIFFICULTY
      result /= slope_rating.to_f
      result.round(1)
    end

    def course_handicap(handicap_index)
      fail ArgumentError, 'Need handicap index to get course handicap' unless handicap_index.is_a?(Float)
      handicap_index * slope_rating / STANDARD_DIFFICULTY
    end

    private

    def make_adjuster(course_handicap)
      return max_score_at(10) unless course_handicap
      case course_handicap
        when 10...20
          max_score_at(7)
        when 20...30
          max_score_at(8)
        when 30...40
          max_score_at(9)
        else
          if course_handicap < 10
            -> (par, score) { [par + 2, score].min }
          else
            max_score_at(10)
          end
      end
    end

    def max_score_at(m)
      -> (_, score) { [m, score].min }
    end

  end
end
