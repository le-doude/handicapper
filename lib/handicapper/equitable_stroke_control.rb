module Handicapper
  class EquitableStrokeControl
      # @param [Array] par_scores is an array of ints representing pars for the current course played/scored
      def new(par_scores)
        fail ArgumentError, 'Need to set par scores for course to use ESC' unless par_scores.present?
        fail ArgumentError, 'Need a number representing a valid par score for each hole, in order of holes played' unless par_scores.all? { |p| p.is_a?(Fixnum) && (1..10).include?(p) }
        @par_scores = par_scores
      end

      # @param [Fixnum] handicap
      # @param [Array] scores is an array of ints representing the gross scores per hole from the round being scored
      # @return [Fixnum] return a int representing the adjusted score for the round using the ESC rules from USGA
      def adjust_gross_scores(handicap = nil, scores)
        fail ArgumentError, 'Need as many scores ase there is holes' unless scores.size == par_scores.size
        adjuster = make_adjuster(handicap)
        @par_scores.zip(scores).map(&adjuster).inject(&:+)
      end

      private

      def make_adjuster(handicap)
        return max_score_at(10) unless handicap.present?
        case handicap
          when 10..19
            max_score_at(7)
          when 20..29
            max_score_at(8)
          when 30..39
            max_score_at(9)
          else
            if handicap <= 9
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
