module Handicapper
  class HandicapCalculator
    USGA_OFFICIAL_HDCP_ADJUSTER = 0.96

    # @param [Array] differentials array of float representing the previously calculater hdcp differentials for this player
    def initialize(differentials = [])
      @differentials = differentials
    end


    # @param [RoundSettings] setting to use for the played round
    # @param [Array] scores array of ints representing the scores for this round
    # @return [Float] the handicap after accounting for this new round
    def calculate(setting, scores)
      total_score = if scores.is_a?(Enumerable)
                      setting.adjust_gross_scores(scores)
                    elsif scores.is_a?(Fixnum)
                      scores
                    else
                      return
                    end
      @differentials << settings.handicap_differential(total_score)
      current_handicap
    end

    def current_handicap
      d_count = differencials_to_consider
      return unless d_count > 0
      ((@differentials.min(d_count).inject(&:+) / d_count.to_f) * USGA_OFFICIAL_HDCP_ADJUSTER).round(1)
    end

    private

    def differencials_to_consider
      size = @differentials.size
      case size
        when 5..16
          ((size - 4) +1)/ 2
        when 17..20
          size - 10
        else
          if size > 20
            10
          else
            0
          end
      end
    end
  end
end
