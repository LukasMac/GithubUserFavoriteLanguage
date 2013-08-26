require_relative "values_distribution"
require_relative "http_response"

module Github

  def favorite_language_of(username)
    AccountDetailsPrinter.new(Account.new(username)).print
  end
  

  class Account
    LANGUAGE_KEY = "language"

    attr_reader :username, :languages

    def initialize(username)
      raise ArgumentError, 'Username can not be empty' if !username || username.empty?

      @username = username
      @repos = HTTPResponse.get_user_repos(username)
      @languages = ValuesDistribution.new(@repos.map { |repo| repo[LANGUAGE_KEY] })
    end
  end


  class AccountDetailsPrinter
    def initialize(github_account)
      @github_account = github_account
    end

    def print
      favorite_language
      languages_percentage_spread_table if @github_account.languages.count > 0
    end

  private

    def favorite_language
      language = @github_account.languages.favorite

      if language
        puts "User's '#{@github_account.username}' favorite programing language: #{language}. Used in #{@github_account.languages.occured(language)} repo(s) from total #{@github_account.languages.count} repo(s)"
      else
        puts "Sorry could not find user's '#{@github_account.username}' favorite programming language"
      end
    end

    def languages_percentage_spread_table
      return unless language_usage = @github_account.languages.percentage_spread

      split_line = "-" * 32

      puts "\nLanguages percentage usage table\n\n"
      puts split_line
      puts "| #{sprintf('%15s', 'Language')} | #{sprintf('%10s', 'Usage')} |"
      puts split_line

      language_usage.each do |language, usage|
        puts "| #{sprintf('%15s', language)} | #{sprintf('%9.2f', usage)}% |"
      end

      puts split_line
    end
  end

end