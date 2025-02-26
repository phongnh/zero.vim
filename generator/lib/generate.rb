require "json"
require "erb"
require "sxp"
require_relative "parse_definition"

class Generate
  TEMPLATE  = File.join(__dir__, "templates/dumb_jump.vim.erb")

  def initialize(input: "dumb-jump-find-rules.el", output: "dumb_jump.vim")
    @input = input
    @output = output
  end

  def call
    puts "Reading #{input}"
    source = File.read(input)

    puts "Parsing S-expressions from #{input}"
    s_expressions = SXP.read(source)
    # s_expressions = SXP::Reader::Basic.read(source)
    puts "Found #{s_expressions.count} rules"

    definitions = s_expressions.map do |s_expression|
      ParseDefinition.call(s_expression)
    end

    definitions = definitions.each_with_object({}) do |definition, group|
      group[definition[:language]] ||= []
      group[definition[:language]] << definition
    end
    definitions["c"] = definitions["c++"]
    definitions["cpp"] = definitions["c++"]
    definitions["javascriptreact"] = definitions["javascript"]
    definitions["typescriptreact"] = definitions["typescript"]

    template = ERB.new(File.read(TEMPLATE), trim_mode: "<>-")
    vimscript = template.result(binding)

    puts "Saved #{output}"
    File.open(output, "w") { |file| file.puts(vimscript) }

    vimscript
  end

  def self.call(...)
    new(...).call
  end

  private

  attr_reader :input, :output
end
