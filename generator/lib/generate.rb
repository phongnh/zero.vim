require "fileutils"
require "json"
require "erb"
require "sxp"
require_relative "parse_definition"

class Generate
  TEMPLATE  = File.join(__dir__, "templates/dumb_jump.vim.erb")

  LANGUAGE_MAPPINGS = {
    "c" => "c++",
    "cpp" => "c++",
    "javascriptreact" => "javascript",
    "typescriptreact" => "typescript",
  }

  def initialize(input: "dumb-jump-find-rules.el", namespace: "zero#dumb_jump")
    @filename = "#{namespace.gsub("#", "/")}.vim"
    @input = input
    @output = File.basename(filename)
    @namespace = namespace
  end

  def call
    puts "Reading: #{input}"
    source = File.read(input)

    puts "Parsing S-expressions from #{input}"
    s_expressions = SXP.read(source)
    # s_expressions = SXP::Reader::Basic.read(source)

    puts "Parsing #{s_expressions.count} found definition rules from #{input}"
    definitions = s_expressions.map do |s_expression|
      ParseDefinition.call(s_expression)
    end

    puts "Formatting #{definitions.count} definitions"
    definitions = definitions.each_with_object({}) do |definition, group|
      language, type = definition.values_at(:language, :type)
      group[language] ||= {}
      group[language][type] ||= []
      group[language][type] << definition[:pcre_regex_vim]
    end

    LANGUAGE_MAPPINGS.each do |key, value|
      puts "Mapping definitions for #{key.inspect} from #{value.inspect}"
      definitions[key] = definitions[value]
    end

    puts "Generating VimL from #{TEMPLATE}"
    template = ERB.new(File.read(TEMPLATE), trim_mode: "<>-")
    vimscript = template.result(binding)

    File.open(output, "w") { |file| file.puts(vimscript) }
    puts "Saved: #{output}"

    FileUtils.chdir(File.expand_path("../..", __dir__), verbose: true) do
      FileUtils.mkdir_p("autoload/#{File.dirname(filename)}")
      FileUtils.mv("generator/#{output}", "autoload/#{filename}", verbose: true)
    end

    vimscript
  end

  def self.call(...)
    new(...).call
  end

  private

  attr_reader :input, :filename, :output, :namespace
end
