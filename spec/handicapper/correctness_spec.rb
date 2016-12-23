require 'spec_helper'
require 'handicapper/calculator'

describe 'USGA rule compliance' do
  shared_examples 'valid handicap index example' do |differentials, gender, rounds, final_handicap|
    let(:calculator) { Handicapper::Calculator.new(differentials: differentials, gender: gender) }
    it "should output handicap index = #{final_handicap}" do
      rounds.each do |round|
        expected = round[:expected_differential]
        round.delete(:expected_differential)
        if expected
          expect(calculator.add_round(**round)).to eql(expected)
        else
          expect(calculator.add_round(**round)).to be_a(Float)
        end
      end
      expect(calculator.current_handicap).to eql(final_handicap)
    end
  end

  # https://www.usga.org/Handicapping/handicap-manual.html#!rule-14389
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
    it_behaves_like 'valid handicap index example', [], :male, rounds, 14.8
  end

  context 'Random reddit nice guy that gave me his scores' do
    rounds = [
      [74.0, 130, 99, 21.7],
      [69.8, 122, 107, 34.5],
      [69.2, 117, 109, 38.4],
      [74.0, 130, 115, 31.3],
      [74.0, 130, 99, 21.7],
      [67.4, 113, 107, 36.6],
      [69.2, 117, 98, 27.8],
      [67.4, 113, 98, 30.6],
      [74.0, 130, 106, 27.8],
      [69.1, 119, 102, 31.2],
      [67.5, 112, 96, 28.8],
      [66.0, 109, 92, 27.0],
      [69.7, 99, 80, 11.8],
      [69.1, 116, 95, 24.3],
      [69.7, 99, 93, 26.6],
      [68.6, 120, 90, 20.2],
      [67.5, 112, 90, 22.7],
    ].map { |cr, s, score, _| {course_rating: cr, slope: s, adjusted_score: score} }
    it_behaves_like 'valid handicap index example', [], :male, rounds, 20.5
  end

  context 'People on the golf association of Michigan' do
    context 'A-dog' do
      rounds = [
        [84, 73.2, 139, 8.8],
        [81, 74.2, 145, 5.3],
        [79, 73.7, 144, 4.2],
        [79, 73.5, 141, 4.4],
        [79, 71.4, 125, 6.9],
        [81, 71.9, 131, 7.8],
        [74, 70.7, 128, 2.9],
        [83, 70.8, 134, 10.3],
        [77, 68.0, 126, 8.1],
        [77, 70.7, 128, 5.6],
        [86, 71.4, 125, 13.2],
        [86, 72.0, 134, 11.8],
        [80, 70.7, 128, 8.2],
        [81, 72.1, 138, 7.3],
        [79, 73.5, 138, 4.5],
        [82, 73.7, 133, 7.1],
        [80, 71.7, 129, 7.3],
        [89, 71.7, 134, 14.6],
        [79, 69.6, 136, 7.8],
        [76, 71.4, 125, 4.2],
      ].reverse.map { |score, cr, s, ed| {adjusted_score: score, course_rating: cr, slope: s, expected_differential: ed} }
      it_behaves_like 'valid handicap index example', [], :male, rounds, 5.0
    end

    context 'Barbie' do
      rounds =[
        [107, 72.7, 127, 30.5],
        [105, 72.7, 127, 28.7],
        [109, 72.7, 127, 32.3],
        [108, 72.7, 127, 31.4],
        [104, 72.7, 127, 27.8],
        [112, 72.7, 127, 35.0],
        [115, 72.7, 127, 37.6],
        [114, 72.7, 127, 36.7],
        [111, 73.4, 130, 32.7],
        [114, 72.7, 127, 36.7],
        [112, 72.7, 127, 35.0],
        [109, 72.7, 127, 32.3],
        [115, 72.7, 127, 37.6],
        [100, 73.4, 130, 23.1],
        [113, 72.7, 127, 35.9],
        [109, 72.7, 127, 32.3],
        [106, 73.4, 130, 28.3],
        [108, 73.4, 130, 30.1],
        [118, 72.7, 127, 40.3],
        [113, 72.7, 127, 35.9],
      ].reverse.map { |score, cr, s, ed| {adjusted_score: score, course_rating: cr, slope: s, expected_differential: ed} }
      it_behaves_like 'valid handicap index example', [], :female, rounds, 28.4
    end

    context 'Lizzy' do
      rounds = [
        [77, 69.0, 126, 7.2],
        [78, 69.0, 126, 8.1],
        [76, 69.7, 120, 5.9],
        [78, 69.4, 119, 8.2],
        [77, 69.2, 123, 7.2],
        [82, 69.4, 119, 12.0],
        [84, 69.9, 123, 13.0],
        [82, 69.9, 123, 11.1],
        [79, 69.4, 124, 8.7],
        [77, 72.0, 130, 4.3],
        [84, 71.8, 127, 10.9],
        [87, 70.1, 123, 15.5],
        [87, 69.4, 119, 16.7],
        [87, 69.4, 119, 16.7],
        [82, 69.0, 126, 11.7],
        [80, 68.8, 123, 10.3],
        [88, 69.9, 123, 16.6],
        [88, 69.9, 123, 16.6],
        [85, 68.7, 118, 15.6],
        [79, 69.4, 119, 9.1],
      ].reverse.map { |score, cr, s, ed| {adjusted_score: score, course_rating: cr, slope: s, expected_differential: ed} }
      it_behaves_like 'valid handicap index example', [], :female, rounds, 7.6
    end

    context 'Billy' do
      rounds = [
        [94, 71.4, 127, 20.1],
        [94, 71.4, 127, 20.1],
        [92, 71.4, 127, 18.3],
        [91, 71.4, 127, 17.4],
        [88, 71.4, 127, 14.8],
        [87, 71.4, 127, 13.9],
        [94, 71.4, 127, 20.1],
        [91, 71.4, 127, 17.4],
        [91, 71.4, 127, 17.4],
        [92, 71.4, 127, 18.3],
        [90, 71.4, 127, 16.5],
        [90, 71.4, 127, 16.5],
        [92, 71.4, 127, 18.3],
        [92, 71.4, 127, 18.3],
        [92, 71.4, 127, 18.3],
        [91, 71.4, 127, 17.4],
        [89, 71.4, 127, 15.7],
        [93, 71.4, 127, 19.2],
        [93, 71.4, 127, 19.2],
        [92, 71.4, 127, 18.3],
      ].reverse.map { |score, cr, s, ed| {adjusted_score: score, course_rating: cr, slope: s, expected_differential: ed} }
      it_behaves_like 'valid handicap index example', [], :male, rounds, 15.8
    end
  end
end
