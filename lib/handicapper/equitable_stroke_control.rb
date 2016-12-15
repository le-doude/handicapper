module Handicapper
  module EquitableStrokeControl
      def self.included(klass)
        klass.class_eval do
          attr :par_scores
        end
      end

      # @param [Fixnum] handicap
      # @param [Array] scores is an array of ints representing the gross scores per hole from the round being scored
      # @return [Fixnum] return a int representing the adjusted score for the round using the ESC rules from USGA
      def adjust_gross_scores(handicap = nil, scores)
        fail ArgumentError, 'Need as many scores ase there is holes' unless scores && scores.size == par_scores.size
        adjuster = make_adjuster(handicap)
        @par_scores.zip(scores).map(&adjuster).inject(&:+)
      end

      private

      def make_adjuster(handicap)
        return max_score_at(10) unless handicap
        case handicap
          when 10...20
            max_score_at(7)
          when 20...30
            max_score_at(8)
          when 30...40
            max_score_at(9)
          else
            if handicap < 10
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
