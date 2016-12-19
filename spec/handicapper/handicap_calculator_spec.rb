require 'spec_helper'
require 'handicapper/handicap_calculator'

describe Handicapper::HandicapCalculator do

  let(:fresh) { Handicapper::HandicapCalculator.new }

  it 'has an attribute differentials' do
    expect(fresh).to respond_to(:differentials)
  end

  describe :initialize do
    it 'returns an instance without differentials if no params given' do
      expect(fresh.differentials).to be_empty
    end
    it 'returns an instance with differentials if provided' do
      status = Faking.differentials(n=10)
      instance = Handicapper::HandicapCalculator.new(status)
      expect(instance.differentials).to include(*status)
      expect(instance.differentials.size).to eql(status.size)
    end
  end

  describe :calculate do
    it 'loads a new differential for every score loaded' do
      expect { fresh.calculate(Faking.round_settings, Faking.scores) }.to change { fresh.differentials.size }.by(1)
    end
    it 'returns nil unless 5 scores are loaded' do
      4.times do
        expect(fresh.calculate(Faking.round_settings, Faking.scores)).to be_nil
      end
      expect(fresh.calculate(Faking.round_settings, Faking.scores)).to be_a(Float)
    end
    it 'will start giving handicaps using initialization differentials' do
      7.times do
        fresh.calculate(Faking.round_settings, Faking.scores)
      end
      d = fresh.differentials
      new_instance = Handicapper::HandicapCalculator.new(d)
      expect(new_instance.calculate(Faking.round_settings, Faking.scores)).to be_a(Float)
    end
    it 'accepts total scores' do
      expect { fresh.calculate(Faking.round_settings, Faking.scores.inject(:+)) }.not_to raise_exception
    end
    it 'accepts hole by hole scores' do
      expect { fresh.calculate(Faking.round_settings, Faking.scores) }.not_to raise_exception
    end
    it 'fails if scores number do not match holes number' do
      expect { fresh.calculate(Faking.round_settings(holes=18), Faking.scores(holes=15)) }.to raise_exception(ArgumentError)
    end
  end

  describe :current_handicap do
    let(:foury) { Handicapper::HandicapCalculator.new(Faking.differentials(n=4)) }
    it 'returns nil unless 5 scores are loaded' do
      expect(fresh.current_handicap).to be_nil
      expect(foury.current_handicap).to be_nil
    end
    let(:fivy) { Handicapper::HandicapCalculator.new(Faking.differentials(n=5)) }
    it 'returns handicap if there is more than 5 scores loaded' do
      expect(fivy.current_handicap).to be_a(Float)
    end
  end
end
