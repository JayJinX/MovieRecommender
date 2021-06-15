class MovieRecommender::Movie
  attr_accessor :title, :url

  @@all =[]

  def initialize(title:, url:)
    @title = title
    @url = url
    @@all << self
  end

  def self.all
    @@all
  end

  def self.destroy
    @@all.clear
  end


end


