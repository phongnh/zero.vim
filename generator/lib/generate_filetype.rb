require "fileutils"
require "erb"

class GenerateFiletype
  BASE_DIR = File.expand_path(File.join(__dir__, "..", ".."))

  VIML_TEMPLATE  = File.join(__dir__, "templates/filetype.vim.erb")
  VIM9SCRIPT_TEMPLATE  = File.join(__dir__, "templates/filetype.vim9script.erb")

  def call
    rg_filetypes = `rg --type-list`.each_line.reduce({}) do |hash, line|
      filetype, extensions = line.chomp.split(": ", 2)
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

    FileUtils.mkdir_p(File.join(BASE_DIR, "autoload", "zero"))
    FileUtils.mkdir_p(File.join(BASE_DIR, "vim9", "autoload", "zero"))

    puts "Generating VimL from #{VIML_TEMPLATE}"
    template = ERB.new(File.read(VIML_TEMPLATE), trim_mode: "<>-")
    vimscript = template.result(binding)
    vimscript_file = File.join(BASE_DIR, "autoload", "zero", "filetype.vim")
    File.open(vimscript_file, "w") { |file| file.puts(vimscript) }
    puts "Saved: #{vimscript_file}"

    puts "Generating Vim9script from #{VIM9SCRIPT_TEMPLATE}"
    template = ERB.new(File.read(VIM9SCRIPT_TEMPLATE), trim_mode: "<>-")
    vimscript = template.result(binding)
    vimscript_file = File.join(BASE_DIR, "vim9", "autoload", "zero", "filetype.vim")
    File.open(vimscript_file, "w") { |file| file.puts(vimscript) }
    puts "Saved: #{vimscript_file}"
  end

  def self.call(...)
    new(...).call
  end

  private

  attr_reader :filename, :output, :namespace
end
