require "http"

class Download
  URL = "https://raw.githubusercontent.com/jacktasia/dumb-jump/refs/heads/master/dumb-jump.el"

  def initialize(output: "dumb-jump.el")
    @output = output
  end

  def call
    puts "Downloading: #{URL}"
    HTTP.get(URL).tap do |response|
      File.open(output, "w") { |file| file.puts(response.to_s) }
      puts "Saved: #{output}"
    end
  end

  def self.call(...)
    new(...).call
  end

  private

  attr_reader :output
end
