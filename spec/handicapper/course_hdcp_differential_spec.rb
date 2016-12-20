require 'spec_helper'
require 'handicapper/course_hdcp_differential'
describe Handicapper::CourseHdcpDifferential do

  def make_instance(course_rating, slope)
    Class.new do
      include Handicapper::CourseHdcpDifferential

      def initialize(cr, s)
        @course_rating= cr.to_f
        @slope_rating = s.to_f
      end
    end.new(course_rating, slope)
  end

  let(:instance) { make_instance(72.0 + (-5.0..5.0).step(0.1).to_a.sample, (100.0..155.0).step(0.1).to_a.sample) }
  let(:score) { (54..130).to_a.sample }

  it 'has a course_rating attribute' do
    expect(instance).to respond_to(:course_rating)
  end

  it 'has a slope_rating attribute' do
    expect(instance).to respond_to(:slope_rating)
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
      expect(make_instance(67.2, 113.0).handicap_differential(83)).to eql(15.8)
    end

  end
end
