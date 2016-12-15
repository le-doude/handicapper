module FloatRefinements
  refine Float do
    def chop(ndgits = 1)
      return self if ndgits < 1
      f = 10.0 ** ndgits
      (self * f).floor / f
    end
  end
end
