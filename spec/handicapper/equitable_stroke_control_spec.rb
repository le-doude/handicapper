require 'spec_helper'
require 'handicapper/equitable_stroke_control'

describe Handicapper::EquitableStrokeControl do
  let(:holes) { [5, 3, 4, 4, 4, 4, 3, 5, 4, 4, 4, 5, 3, 4, 4, 4, 5, 3] }
  let(:total_par) { holes.inject(:+) }

  let(:instance) do
    Class.new do
      include Handicapper::EquitableStrokeControl

      def initialize(h)
        @par_scores = h
      end
    end.new(holes)
  end

  it 'has a par_scores attribute' do
    expect(instance).to respond_to(:par_scores)
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
          expect(result).to eql(total_par + (18 *2))
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
