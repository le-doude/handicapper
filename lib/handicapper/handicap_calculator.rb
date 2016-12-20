require 'float_refinements'
require 'basic_object_refinements'
require 'handicapper/round_settings'

module Handicapper
  class HandicapCalculator
    using FloatRefinements
    using BasicObjectRefinements

    MEN_MAX_HANDICAP = 36.4
    WOMEN_MAX_HANDICAP = 40.4
    USGA_OFFICIAL_HDCP_ADJUSTER = 0.96

    attr_reader :differentials

    # @param [Array] differentials array of float representing the previously calculater hdcp differentials for this player
    def initialize(differentials = [], gender = :male)
      @differentials = differentials
      @gender = gender.downcase.to_sym
      @last_handicap_calculated = ([:m, :male, :man, :men].include?(@gender) ? MEN_MAX_HANDICAP : WOMEN_MAX_HANDICAP)
      fail unless @last_handicap_calculated
    end

    def add_round(course_rating: 72.0, slope: 113, pars: nil, scores: nil, adjusted_score: nil, round_settings: nil)
      round_settings ||= Handicapper::RoundSettings.new(course_rating, slope.to_f, pars || []) if course_rating && slope
      fail ArgumentError, 'round settings, or course rating and slope is required to add round' unless round_settings
      adjusted_score ||= adjust_score(round_settings, scores) if scores.present?
      fail ArgumentError, 'scores collection or adjusted score is required to validate round' unless adjusted_score
      @differentials << round_settings.handicap_differential(adjusted_score)
      current_handicap
    end

    def current_handicap
      if (new_hdcp = calculate_from_differentials).present?
        @last_handicap_calculated = new_hdcp
      end
      @last_handicap_calculated
    end

    private

    def adjust_score(setting, scores)
      if scores.is_a?(Enumerable)
        course_hdcp = setting.course_handicap(current_handicap)
        setting.adjust_gross_scores(course_hdcp, scores)
      elsif scores.is_a?(Numeric)
        scores
      end
    end

    def calculate_from_differentials
      d_count = number_to_consider
      return unless d_count > 0
      differentials_selected = @differentials.min(d_count)
      result = (differentials_selected.inject(&:+) / differentials_selected.size) * USGA_OFFICIAL_HDCP_ADJUSTER
      result.chop
    end

    def number_to_consider
      size = @differentials.size
      case size
        when 5..16
          ((size - 4) + 1) / 2
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
