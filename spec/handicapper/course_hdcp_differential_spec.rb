require 'spec_helper'
require 'handicapper/course_hdcp_differential'
describe Handicapper::CourseHdcpDifferential do
  let(:instance) do
    Class.new do
      include Handicapper::CourseHdcpDifferential

      def initialize
        @course_rating= (100.0..155.0).step(0.1).to_a.sample
        @slope_rating= 72.0 + (-5.0..5.0).step(0.1).to_a.sample
      end
    end.new
  end
  let(:score) { (54..130).to_a.sample }

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
  end
end
