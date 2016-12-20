require 'float_refinements'

module Handicapper
  class HandicapCalculator
    using FloatRefinements

    attr_reader :differentials

    USGA_OFFICIAL_HDCP_ADJUSTER = 0.96

    # @param [Array] differentials array of float representing the previously calculater hdcp differentials for this player
    def initialize(differentials = [])
      @differentials = differentials
      @last_handicap_calculated = nil
    end


    # @param [RoundSettings] setting to use for the played round
    # @param [Array] scores array of ints representing the scores for this round
    # @return [Float] the handicap after accounting for this new round
    def calculate(setting, scores)
      total_score = total_score(setting, scores)
      @differentials << setting.handicap_differential(total_score)
      @last_handicap_calculated = calculate_from_differentials
    end

    def current_handicap
      if @last_handicap_calculated.nil? && @differentials.size >= 5
        @last_handicap_calculated = calculate_from_differentials
      end
      @last_handicap_calculated
    end

    private

    def total_score(setting, scores)
      if scores.is_a?(Enumerable)
        setting.adjust_gross_scores(current_handicap, scores)
      elsif scores.is_a?(Fixnum)
        scores
      end
    end

    def calculate_from_differentials
      d_count = number_to_consider
      return unless d_count > 0
      result = (@differentials.min(d_count).inject(&:+) / d_count.to_f) * USGA_OFFICIAL_HDCP_ADJUSTER
      result.chop
    end

    def number_to_consider
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
