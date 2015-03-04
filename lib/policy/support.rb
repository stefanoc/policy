module Policy
  module Support
    def self.underscore(s)
      s.gsub('::', '/').gsub(/([a-z])([A-Z])/, '\1_\2').downcase
    end
  end
end
