require "fileutils"
require "erb"

class Rg
  TEMPLATE  = File.join(__dir__, "templates/rg.vim.erb")

  def initialize(namespace: "zero#rg")
    @filename = "#{namespace.gsub("#", "/")}.vim"
    @output = File.basename(filename)
    @namespace = namespace
  end

  def call
    rg_filetypes = `rg --type-list | cut -d ':' -f 1`.split

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
