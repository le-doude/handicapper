require 'spec_helper'
require 'handicapper/calculator'

describe Handicapper::Calculator do
  shared_examples :calculation do |differentials, gender, rounds, final_handicap|
    let(:calculator) { Handicapper::Calculator.new(differentials: differentials, gender: gender) }
    it 'should be correct' do
      rounds.each do |round|
        if (expected = round[:expected_differential])
          round.delete(:expected_differential)
          expect(calculator.add_round(**round)).to eql(expected)
        else
          round.delete(:expected_differential)
          expect(calculator.add_round(**round)).to be_a(Float)
        end
      end
      expect(calculator.current_handicap).to eql(final_handicap)
    end
  end

  context 'USGA official example' do
    rounds = [
      {adjusted_score: 88, course_rating: 70.1, slope: 116, expected_differential: 17.4},
      {adjusted_score: 89, course_rating: 72.3, slope: 123, expected_differential: 15.3},
      {adjusted_score: 93, course_rating: 72.3, slope: 123, expected_differential: 19.0},
      {adjusted_score: 94, course_rating: 72.3, slope: 123, expected_differential: 19.9},
      {adjusted_score: 84, course_rating: 70.1, slope: 116, expected_differential: 13.5},
      {adjusted_score: 82, course_rating: 70.1, slope: 116, expected_differential: 11.6},
      {adjusted_score: 78, course_rating: 68.7, slope: 105, expected_differential: 10.0},
      {adjusted_score: 85, course_rating: 68.0, slope: 107, expected_differential: 18.0},
      {adjusted_score: 92, course_rating: 72.3, slope: 123, expected_differential: 18.1},
      {adjusted_score: 90, course_rating: 70.1, slope: 116, expected_differential: 19.4},
      {adjusted_score: 86, course_rating: 68.7, slope: 105, expected_differential: 18.6},
      {adjusted_score: 91, course_rating: 70.1, slope: 116, expected_differential: 20.4},
      {adjusted_score: 91, course_rating: 70.1, slope: 116, expected_differential: 20.4},
      {adjusted_score: 91, course_rating: 72.3, slope: 123, expected_differential: 17.2},
      {adjusted_score: 90, course_rating: 72.3, slope: 123, expected_differential: 16.3},
      {adjusted_score: 89, course_rating: 70.1, slope: 116, expected_differential: 18.4},
      {adjusted_score: 88, course_rating: 70.1, slope: 116, expected_differential: 17.4},
      {adjusted_score: 94, course_rating: 72.3, slope: 123, expected_differential: 19.9},
      {adjusted_score: 91, course_rating: 70.1, slope: 116, expected_differential: 20.4},
      {adjusted_score: 90, course_rating: 70.1, slope: 116, expected_differential: 19.4}
    ]
    it_behaves_like :calculation, [], :male, rounds, 14.8
  end

end
