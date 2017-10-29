class AnalyzeSentiment
  attr_reader :analyzer

  def initialize
    @analyzer = Sentimental.new
    # Load the default sentiment dictionaries
    analyzer.load_defaults
  end

  def score(tweet)
    analyzer.score(tweet)
  end
end
