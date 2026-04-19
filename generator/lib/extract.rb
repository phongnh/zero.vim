class Extract
  PARSE_PATTERNS = {
    head: "(defcustom dumb-jump-find-rules",
    tail: '  "List of search regex pattern templates organized by language and type.',
  }

  def initialize(input: "dumb-jump.el", output: "dumb-jump-find-rules.el")
    @input = input
    @output = output
  end

  def call
    puts "Reading: #{input}"
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
    lines = source.each_line.map { |line| (line.start_with?("  ") ? line[2..-1] : line).rstrip }

    # Write raw source
    raw_output = "#{File.basename(output, File.extname(output))}-with-comments#{File.extname(output)}"
    File.open(raw_output, "w") { |file| file.puts(lines) }
    puts "Saved: #{raw_output}"

    # Remove comments
    lines = lines.select { |line| !line.start_with?(/\s{2,};;?\s/, ';;', '  ;;--', /^\s{4,};;\?;\?/) }
    lines[0].sub!(/^'\(\(/, "((")
    lines = lines.map do |line|
      next line if line.end_with?("))")
      index = line.index(' ;; ')
      if index
        line[0...index].rstrip
      else
        index = line.index(' ; ')
        index ? line[0...index].rstrip : line
      end
    end
    (0...(lines.size - 1)).each do |idx|
      if lines[idx].end_with?(':') && lines[idx + 1].start_with?(/^\s+supports/)
        lines[idx] = lines[idx][0..-2]
        lines[idx + 1] = lines[idx + 1].sub(' supports', ' :supports')
      end
    end
    File.open(output, "w") { |file| file.puts(lines) }
    puts "Saved: #{output}"

    lines
  end

  def self.call(...)
    new(...).call
  end

  private

  attr_reader :input, :output
end
