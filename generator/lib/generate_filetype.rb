require "fileutils"
require "erb"

class GenerateFiletype
  TEMPLATE  = File.join(__dir__, "templates/filetype.vim.erb")

  ENABLED_FILETYPES = [
    "c",
    "cmake",
    "config",
    "cpp",
    "crystal",
    "css",
    "csv",
    "dart",
    "diff",
    "docker",
    "dockercompose",
    "elixir",
    "elm",
    "erb",
    "erlang",
    "fennel",
    "fish",
    "go",
    "graphql",
    "h",
    "haml",
    "html",
    "js",
    "json",
    "jsonl",
    "jupyter",
    "log",
    "lua",
    "make",
    "man",
    "markdown",
    "md",
    "pod",
    "protobuf",
    "py",
    "python",
    "rdoc",
    "readme",
    "ruby",
    "rust",
    "sass",
    "sh",
    "slim",
    "sql",
    "svelte",
    "svg",
    "tf",
    "toml",
    "ts",
    "txt",
    "typescript",
    "v",
    "vim",
    "vimscript",
    "vue",
    "xml",
    "yacc",
    "yaml",
    "zig",
    "zsh",
  ]

  def initialize(namespace: "zero#filetype")
    @filename = "#{namespace.gsub("#", "/")}.vim"
    @output = File.basename(filename)
    @namespace = namespace
  end

  def call
    rg_filetypes = `rg --type-list`.each_line.reduce({}) do |hash, line|
      filetype, extensions = line.chomp.split(": ", 2)
      next hash unless ENABLED_FILETYPES.include?(filetype)
      extensions = extensions.split(", ").map do |ext|
        md = ext.match(/^*\.\{(.*)\}$/)
        if md
          md[1].split(",").map { |ext| "*.#{ext}" }
        else
          ext
        end
      end
      hash[filetype] = extensions.flatten
      hash
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

  attr_reader :filename, :output, :namespace
end
