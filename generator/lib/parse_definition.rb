class ParseDefinition
  # rg, git-grep and git-grep
  RG_WORD_BOUNDARY = "($|[^a-zA-Z0-9\\?\\*-])"

  DEFINITION_KEYS = [:language, :type, :regex, :regex_vim, :pcre_regex, :pcre_regex_vim, :supports]
  TEST_KEYS = [:"skip-ref-filter", :tests, :not]

  # ALL_LISP_KEYS = (DEFINITION_KEYS + TEST_KEYS).map { |key| :"#{key.inspect}" }

  def initialize(definition)
    @definition = normalize(definition)
  end

  def call
    definition
      .except(*TEST_KEYS)
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

  def normalize(definition)
    index = definition.index(:":tests")
    (index ? definition[0...index] : definition)
      .each_slice(2)
      .each_with_object({}) { |(key, value), hash| hash[key.to_s.sub(/^:/, "").to_sym] = value }
  end

  def build_pcre_regexp(regexp)
    regexp.gsub('\\j', RG_WORD_BOUNDARY)
  end

  def format_quotes(string)
    result = string
      .gsub("'", "''")
      .gsub('"', "\\\\\"")
      .gsub("`", "\\\\`")

    language = definition[:language]
    if language == "rust"
      result = result.sub("muts", "mut\\\\s")
    end

    result
  end
end
