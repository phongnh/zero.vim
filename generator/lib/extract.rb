class Extract
  PARSE_PATTERNS = {
    head: "(defcustom dumb-jump-find-rules",
    tail: '  "List of regex patttern templates organized by language and type to use for generating the grep command."',
  }

  def initialize(input: "dumb-jump.el", output: "dumb-jump-find-rules.el")
    @input = input
    @output = output
  end

  def call
    puts "Reading #{input}"
    source = File.read(input)

    puts "Extracting find-rules from #{input}"
    # Extract find-rules which are source between `head` and `tail`
    head = source.index(PARSE_PATTERNS[:head])
    source = source[(head + PARSE_PATTERNS[:head].length + 1)..-1]
    tail = source.index(PARSE_PATTERNS[:tail])
    source = source[0..(tail - 1)]

    # Remove whitespaces
    source.strip!
    # Remove ' at start of source
    source.sub!(/^'\(\(/, "((")
    # Remove indent
    source = source.each_line.map { |line| line.start_with?("  ") ? line[2..-1] : line }

    # Write raw source
    raw_output = "#{File.basename(output, File.extname(output))}-with-comments#{File.extname(output)}"
    File.open(raw_output, "w") { |file| file.puts(source) }
    puts "Saved: #{raw_output}"

    # Remove comments
    source = source.select { |line| !line.start_with?(/\s{2,};;?/) }
    File.open(output, "w") { |file| file.puts(source) }
    puts "Saved: #{output}"

    source
  end

  def self.call(...)
    new(...).call
  end

  private

  attr_reader :input, :output
end
