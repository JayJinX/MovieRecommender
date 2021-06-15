class MovieRecommender::CLI
  attr_accessor :scraper

  @@location = []

  def initialize
  end

  def start 
    puts "Hi! Welcome to MovieRecommender"
    puts "Do you want to want to list movies currently in theaters near to your location?"
    puts "**Input [Y] to continue or input [N] to exit**"

    input = gets.strip

    if input.downcase == "y"
      postalcode_prompt
    elsif input.downcase == "n"
      exit
    else
      puts "Invaild input!"
      start
    end
  end

  def postalcode_prompt
    puts "Please enter the postal code of your location"
    input = gets.strip
    @@location << input
    location_prompt
  end

  def location_prompt
    puts "Please enter your location from the following list"
    puts "AR, AU, CA, CL, DE, ES, FR, IT, MX, NZ, PT, UK, US"
    input = gets.strip
    @@location << input
    list_movies
  end

  def list_movies
    scraper = MovieRecommender::Scraper.new
    scraper.scrape_movies.each.with_index(1) do |movie, index|
      puts "#{index}. #{movie.title}"
    end
    prompt_user
  end

  def prompt_user 
    puts "*************************************"
    puts "Enter the number of the movie you want to check the detail."
    puts "Input [exit] to quit."
    puts "*************************************"

    input = ""

    while input.downcase != "exit"
      input = gets.strip
      actual_input = input.to_i-1

      if input.to_i != 0 && input.to_i <= MovieRecommender::Movie.all.size
        url = MovieRecommender::Movie.all[actual_input].url
        title = MovieRecommender::Movie.all[actual_input].title
        scraper = MovieRecommender::Scraper.new
        scraper.scrape_details(url)
        score = scraper.score
        description = scraper.description
        puts "*******#{title} |IMDB:#{score}|*******"
        puts "***************SUMMARY***************"
        puts description
        puts "*************************************"
        puts "Enter the number of the movie you want to check the detail."
        puts "Input [exit] to quit."
        puts "*************************************"
      elsif input.downcase == "exit"
        puts "See you next time."
        exit
      else
        puts "Invaild input. Please try again."
      end
    end
  end

  def self.all
    @@location
  end

  def self.clear
    @@location.clear
  end

end
