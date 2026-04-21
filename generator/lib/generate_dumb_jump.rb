require "fileutils"
require "json"
require "erb"
require "sxp"
require "pp"
require_relative "parse_definition"

class GenerateDumbJump
  BASE_DIR = File.expand_path(File.join(__dir__, "..", ".."))

  VIML_TEMPLATE = File.join(__dir__, "templates/dumb_jump.vim.erb")
  VIM9SCRIPT_TEMPLATE = File.join(__dir__, "templates/dumb_jump.vim9script.erb")

  LANGUAGE_MAPPINGS = {
    "c" => "c++",
    "cpp" => "c++",
    "cs" => "csharp",
    "javascriptreact" => "javascript",
    "typescriptreact" => "typescript",
    "sh" => "shell",
    "zsh" => "shell",
  }

  IGNORED_LANGUAGES = [
    "apex",
    "cobol",
    "commonlisp",
    "coq",
    "dlang",
    "elisp",
    "faust",
    "fortran",
    "jai",
    "janet",
    "julia",
    "matlab",
    "odin",
    "pascal",
    "purescript",
    "racket",
    "scad",
    "scheme",
    "sml",
    "systemverilog",
    "tcl",
    "vhdl",
  ]

  def initialize(input: "dumb-jump-find-rules.el")
    @input = input
  end

  def call
    puts "Reading: #{input}"
    source = File.read(input)

    puts "Parsing S-expressions from #{input}"
    s_expressions = SXP.read(source)
    # s_expressions = SXP::Reader::Basic.read(source)

    # puts "=" * 80, JSON.pretty_generate(s_expressions), "=" * 80

    puts "Parsing #{s_expressions.count} found definition rules from #{input}"
    definitions = s_expressions.map do |s_expression|
      ParseDefinition.call(s_expression)
    end

    puts "Formatting #{definitions.count} definitions"
    definitions = definitions.each_with_object({}) do |definition, group|
      language = definition[:language]
      next if IGNORED_LANGUAGES.include?(language)
      group[language] ||= []
      group[language] << definition[:pcre_regex_vim]
    end

    LANGUAGE_MAPPINGS.each do |key, value|
      puts "Mapping definitions for #{key.inspect} from #{value.inspect}"
      definitions[key] = definitions[value]
    end

    FileUtils.mkdir_p(File.join(BASE_DIR, "autoload", "zero"))
    FileUtils.mkdir_p(File.join(BASE_DIR, "vim9", "autoload", "zero"))

    puts "Generating VimL from #{VIML_TEMPLATE}"
    template = ERB.new(File.read(VIML_TEMPLATE), trim_mode: "<>-")
    vimscript = template.result(binding)
    vimscript_file = File.join(BASE_DIR, "autoload", "zero", "dumb_jump.vim")
    File.open(vimscript_file, "w") { |file| file.puts(vimscript) }
    puts "Saved: #{vimscript_file}"

    puts "Generating Vim9script from #{VIM9SCRIPT_TEMPLATE}"
    template = ERB.new(File.read(VIM9SCRIPT_TEMPLATE), trim_mode: "<>-")
    vimscript = template.result(binding)
    vimscript_file = File.join(BASE_DIR, "vim9", "autoload", "zero", "dumb_jump.vim")
    File.open(vimscript_file, "w") { |file| file.puts(vimscript) }
    puts "Saved: #{vimscript_file}"
  end

  def self.call(...)
    new(...).call
  end

  private

  attr_reader :input
end
