require 'spec_helper'
require 'handicapper/handicap_calculator'

describe Handicapper::HandicapCalculator do

  it 'has an attribute differentials' do
    expect(Handicapper::HandicapCalculator.new).to respond_to(:differentials)
  end

  describe :initialize do
    it 'returns an instance without differentials if no params given' do
      expect(Handicapper::HandicapCalculator.new.differentials).to be_empty
    end

    it 'returns an instance with differentials if provided' do
      status = Faking.differentials(n=10)
      instance = Handicapper::HandicapCalculator.new(status)
      expect(instance.differentials).to include(*status)
      expect(instance.differentials.size).to eql(status.size)
    end
  end

  describe :calculate do
    it 'does not return an handicap until it has 5 scores' do
      instance = Handicapper::HandicapCalculator.new
      # 1
      expect(instance.calculate(Faking.round_settings, Faking.scores)).to be_nil
      # 2
      expect(instance.calculate(Faking.round_settings, Faking.scores)).to be_nil
      # 3
      expect(instance.calculate(Faking.round_settings, Faking.scores)).to be_nil
      # 4
      expect(instance.calculate(Faking.round_settings, Faking.scores)).to be_nil
      # 5
      expect(instance.calculate(Faking.round_settings, Faking.scores)).to be_a(Float)
    end
    it 'will start giving handicaps using initialization differentials' do
      instance = Handicapper::HandicapCalculator.new
      7.times do
        instance.calculate(Faking.round_settings, Faking.scores)
      end
      d = instance.differentials
      new_instance = Handicapper::HandicapCalculator.new(d)
      expect(new_instance.calculate(Faking.round_settings, Faking.scores)).to be_a(Float)
    end
  end
end
