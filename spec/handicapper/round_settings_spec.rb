require 'spec_helper'
require 'handicapper/round_settings'

describe Handicapper::RoundSettings do

  let(:instance) { Handicapper::RoundSettings.new(72.0, 113, [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4]) }

  let(:score) { (54..130).to_a.sample }

  it 'has a course_rating attribute' do
    expect(instance).to respond_to(:course_rating)
  end

  it 'has a slope_rating attribute' do
    expect(instance).to respond_to(:slope_rating)
  end

  it 'has a par_scores attribute' do
    expect(instance).to respond_to(:par_scores)
  end

  describe :handicap_differential do
    it 'returns a float' do
      expect(instance.handicap_differential(score)).to be_a(Float)
    end
    it 'returns a number with at most 1 decimal digit' do
      diff = instance.handicap_differential(score)
      expect(diff).to eq(diff.round(1))
    end
    it 'fails if input is nil' do
      expect { instance.handicap_differential(nil) }.to raise_exception(ArgumentError)
    end
    it 'fails if input is not a number' do
      expect { instance.handicap_differential('Salsa de fuego') }.to raise_exception(ArgumentError)
    end

    it 'should be correct' do
      expect(Handicapper::RoundSettings.new(67.2, 113.0, []).handicap_differential(83)).to eql(15.8)
    end
  end

  describe :adjust_gross_scores do
    context 'input has the rigth amount of holes' do
      it 'prevents scores over 10 if you have no handicap' do
        result = instance.adjust_gross_scores(nil, 18.times.map { 20 })
        expect(result).to eql(18 * 10)
      end
      it 'prevents scores over 10 if you are a hdcp >= 40' do
        expect((40.0...100.0).step(0.1).to_a).to all(satisfy do |hdcp|
          result = instance.adjust_gross_scores(hdcp, 18.times.map { 20 })
          expect(result).to eql(18 * 10)
        end)
      end
      it 'prevents scores over 9 if you are a hdcp >= 30 and < 40' do
        expect((30.0...40.0).step(0.1).to_a).to all(satisfy do |hdcp|
          result = instance.adjust_gross_scores(hdcp, 18.times.map { 20 })
          expect(result).to eql(18 * 9)
        end)
      end
      it 'prevents scores over 8 if you are a hdcp >= 20 and < 30' do
        expect((20.0...30.0).step(0.1).to_a).to all(satisfy do |hdcp|
          result = instance.adjust_gross_scores(hdcp, 18.times.map { 20 })
          expect(result).to eql(18 * 8)
        end)
      end
      it 'prevents scores over 7 if you are a hdcp >= 10 and < 20' do
        expect((10.0...20.0).step(0.1).to_a).to all(satisfy do |hdcp|
          result = instance.adjust_gross_scores(hdcp, 18.times.map { 20 })
          expect(result).to eql(18 * 7)
        end)
      end
      it 'prevents scores over double bogey if you are a hdcp < 10' do
        expect((-10.0...10.0).step(0.1).to_a).to all(satisfy do |hdcp|
          result = instance.adjust_gross_scores(hdcp, 18.times.map { 20 })
          expect(result).to eql(72 + (18 *2))
        end)
      end
    end

    context 'input has not enough holes' do
      it 'fails' do
        expect { instance.adjust_gross_scores(nil, 14.times.map { rand(10) + 1 }) }.to raise_exception(ArgumentError)
      end
    end

    context 'input has too many holes' do
      it 'fails' do
        expect { instance.adjust_gross_scores(nil, 20.times.map { rand(10) + 1 }) }.to raise_exception(ArgumentError)
      end
    end

    context 'input has no holes' do
      it 'fails on nil' do
        expect { instance.adjust_gross_scores(nil, nil) }.to raise_exception(ArgumentError)
      end
      it 'fails on empty' do
        expect { instance.adjust_gross_scores(nil, []) }.to raise_exception(ArgumentError)
      end
    end
  end

end
