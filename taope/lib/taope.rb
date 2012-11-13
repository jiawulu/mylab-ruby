require "taope/version"

module Taope
  # Your code goes here...

  def self.hello
    puts 'hello world'
  end

  class Demo

    def initialize(str)
      @hello = str
    end

    def hello
      puts @hello
    end
  end

end
