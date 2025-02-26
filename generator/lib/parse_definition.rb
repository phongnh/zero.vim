class ParseDefinition
  # rg, git-grep and git-grep
  RG_WORD_BOUNDARY = "($|[^a-zA-Z0-9\\?\\*-])"
  PLACEHOLDER = "KEYWORD"

  DEFINITION_KEYS = [:language, :type, :regex, :regex_vim, :pcre_regex, :pcre_regex_vim, :supports]
  TEST_KEYS = [:tests, :not]

  def initialize(definition)
    @definition = definition
  end

  def call
    definition
      .each_slice(2)
      .each_with_object({}) { |(key, value), hash| hash[key.to_s.sub(/^:/, "").to_sym] = value }
      .tap { |hash| hash[:pcre_regex] = build_pcre_regexp(hash[:regex]) }
      .tap { |hash| hash[:pcre_regex_vim] = format_quotes(hash[:pcre_regex]) }
      .tap { |hash| hash[:regex_vim] = format_quotes(hash[:regex]) }
      .slice(*DEFINITION_KEYS)
  end

  def self.call(...)
    new(...).call
  end

  private

  attr_reader :definition

  def build_pcre_regexp(regexp)
    regexp
      .gsub("JJJ", PLACEHOLDER)
      .gsub('\\j', RG_WORD_BOUNDARY)
  end

  def format_quotes(string)
    string
      .gsub("'", "''")
      .gsub('"', "\\\\\"")
      .gsub("`", "\\\\`")
  end
end
