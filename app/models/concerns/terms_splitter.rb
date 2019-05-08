module Concerns
  module TermsSplitter
    def splitted_terms(terms_string)
      terms_string.to_s.split(/\W/)
    end
  end
end
