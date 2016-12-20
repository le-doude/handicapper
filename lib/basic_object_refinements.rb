module BasicObjectRefinements
  refine BasicObject do
    def present?
      !blank?
    end

    def blank?
      respond_to?(:empty?) ? !!empty? : !self
    end
  end

end
