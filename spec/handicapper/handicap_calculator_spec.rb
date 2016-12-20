require 'spec_helper'
require 'handicapper/handicap_calculator'

describe Handicapper::HandicapCalculator do

  let(:calculator) { Handicapper::HandicapCalculator.new }
  let(:round_settings) { Handicapper.round_settings(72.0, 113, [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4]) }
  let(:scores) { [4, 2, 3, 4, 5, 6, 7, 8, 9, 5, 6, 3, 3, 4, 5, 6, 7, 8] }
  let(:insufficient_scores) { [4, 2, 3, 4, 5, 3, 3, 4, 5, 6, 7, 8] }

  it 'has an attribute differentials' do
    expect(calculator).to respond_to(:differentials)
  end

  describe :initialize do
    it 'returns an instance without differentials if no params given' do
      expect(Handicapper::HandicapCalculator.new.differentials).to be_empty
    end
    it 'returns an instance with differentials if provided' do
      status = [5.0, 12.2, 2.6, 3.6, 5.8, 8.9, 10.0, 11.2]
      instance = Handicapper::HandicapCalculator.new(status)
      expect(instance.differentials).to include(*status)
      expect(instance.differentials.size).to eql(status.size)
    end
  end

  describe :add_round do
    it 'accepts total scores' do
      expect { calculator.add_round(round_settings: round_settings, adjusted_score: 105) }.not_to raise_exception
    end
    it 'accepts hole by hole scores' do
      expect { calculator.add_round(round_settings: round_settings, scores: scores) }.not_to raise_exception
    end
    it 'fails if scores number do not match holes number' do
      expect { calculator.add_round(round_settings: round_settings, scores: insufficient_scores) }.to raise_exception(ArgumentError)
    end
    it 'loads a new differential for every score loaded' do
      expect { calculator.add_round(round_settings: round_settings, scores: scores) }.to change { calculator.differentials.size }.by(1)
    end
    it 'returns max handicap for gender unless 5 scores are loaded' do
      4.times do
        expect(calculator.add_round(round_settings: round_settings, scores: scores)).to eql(Handicapper::HandicapCalculator::MEN_MAX_HANDICAP)
      end
      expect(calculator.add_round(round_settings: round_settings, scores: scores)).to be_a(Float)
    end
    it 'will start giving handicaps using initialization differentials' do
      7.times do
        calculator.add_round(round_settings: round_settings, scores: scores)
      end
      d = calculator.differentials
      new_instance = Handicapper::HandicapCalculator.new(d)
      expect(new_instance.add_round(round_settings: round_settings, scores: scores)).to be_a(Float)
    end
    it 'gives handicaps with total scores too' do
      4.times do
        expect(calculator.add_round(round_settings: round_settings, adjusted_score: 98)).to eql(Handicapper::HandicapCalculator::MEN_MAX_HANDICAP)
      end
      50.times do
        expect(calculator.add_round(round_settings: round_settings, adjusted_score: 112)).to be_a(Float)
      end
    end
    it 'gives handicaps with total scores and hole by hole mixed too' do
      4.times do |i|
        expect(calculator.add_round(round_settings: round_settings, **(i.even? ? {adjusted_score: 95} : {scores: scores}))).to eql(Handicapper::HandicapCalculator::MEN_MAX_HANDICAP)
      end
      50.times do |i|
        expect(calculator.add_round(round_settings: round_settings, **(i.even? ? {adjusted_score: 95} : {scores: scores}))).to be_a(Float)
      end
    end
  end

  describe :current_handicap do
    let(:foury) { Handicapper::HandicapCalculator.new([4.0, 5.0, 6.0, 7.0]) }
    it 'returns nil unless 5 scores are loaded' do
      expect(foury.current_handicap).to eql(Handicapper::HandicapCalculator::MEN_MAX_HANDICAP)
    end
    let(:fivy) { Handicapper::HandicapCalculator.new([4.0, 5.0, 6.0, 7.0, 7.0]) }
    it 'returns handicap if there is more than 5 scores loaded' do
      expect(fivy.current_handicap).to be_a(Float)
    end
  end
end
