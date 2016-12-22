require 'spec_helper'
require 'handicapper/calculator'

describe Handicapper::Calculator do
  let(:calculator) { Handicapper::Calculator.new }
  let(:round_settings) { Handicapper::RoundSettings.new(72.0, 113, [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4]) }
  let(:scores) { [4, 2, 3, 4, 5, 6, 7, 8, 9, 5, 6, 3, 3, 4, 5, 6, 7, 8] }
  let(:insufficient_scores) { [4, 2, 3, 4, 5, 3, 3, 4, 5, 6, 7, 8] }

  it 'has an attribute differentials' do
    expect(calculator).to respond_to(:differentials)
  end

  describe :initialize do
    it 'returns an instance without differentials if no params given' do
      expect(Handicapper::Calculator.new.differentials).to be_empty
    end
    it 'returns an instance with differentials if provided' do
      status = [5.0, 12.2, 2.6, 3.6, 5.8, 8.9, 10.0, 11.2]
      instance = Handicapper::Calculator.new(differentials: status)
      expect(instance.differentials).to include(*status)
      expect(instance.differentials.size).to eql(status.size)
    end

    it 'accepts gender as input' do
      expect {Handicapper::Calculator.new(gender: :female)}.not_to raise_exception
      expect {Handicapper::Calculator.new(gender: :f)}.not_to raise_exception
      expect {Handicapper::Calculator.new(gender: 'female')}.not_to raise_exception
      expect {Handicapper::Calculator.new(gender: 'F')}.not_to raise_exception
      expect {Handicapper::Calculator.new(gender: 'Female')}.not_to raise_exception
      expect {Handicapper::Calculator.new(gender: :male)}.not_to raise_exception
      expect {Handicapper::Calculator.new(gender: 'male')}.not_to raise_exception
      expect {Handicapper::Calculator.new(gender: :m)}.not_to raise_exception
      expect {Handicapper::Calculator.new(gender: 'MALE')}.not_to raise_exception
      expect {Handicapper::Calculator.new(gender: 'M')}.not_to raise_exception
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
    it 'returns the newly calculated differential using raw scores' do
      expect(calculator.add_round(round_settings: round_settings, scores: scores)).to be_a(Float)
    end
    it 'returns the newly calculated differential using adjusted_score' do
      expect(calculator.add_round(round_settings: round_settings, adjusted_score: 112)).to be_a(Float)
    end
    it 'accepts to mix adjusted_score and raw scores as input' do
      50.times do |i|
        expect(calculator.add_round(round_settings: round_settings, **(i.even? ? {adjusted_score: 95} : {scores: scores}))).to be_a(Float)
      end
    end
  end

  shared_examples 'current handicap' do |max_handicap|
    it 'returns Max handicap when less than 5 rounds are submitted' do
      subject.differentials = [4.6, 5.6, 3.2, 3.1]
      expect(subject.current_handicap).to eql(max_handicap)
    end
    it 'returns new handicap index when more than 5 rounds are submitted' do
      subject.differentials = [4.6, 5.6, 3.2, 3.1, 6.5, 1.5, 1.1]
      expect(subject.current_handicap).not_to eql(max_handicap)
      expect(subject.current_handicap).to be_a(Float)
    end
  end
  describe :current_handicap do
    it 'uses only last 20 differentials' do
      dz = 50.times.map { (-5.5..15.5).step(0.1).to_a.sample }
      expect(Handicapper::Calculator.new(differentials: dz).current_handicap).to eql(Handicapper::Calculator.new(differentials: dz.last(20)).current_handicap)
    end
    context 'player gender set to male' do
      subject {Handicapper::Calculator.new(gender: :male)}
      it_behaves_like 'current handicap', Handicapper::Calculator::MEN_MAX_HANDICAP
    end
    context 'player gender set to female' do
      subject {Handicapper::Calculator.new(gender: :female)}
      it_behaves_like 'current handicap', Handicapper::Calculator::WOMEN_MAX_HANDICAP
    end
  end
end
