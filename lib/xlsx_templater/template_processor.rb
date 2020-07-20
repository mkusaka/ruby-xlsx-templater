module XlsxTemplater
  class TemplateProcessor
    attr_reader :data, :escape_html

    def initialize(data, escape_html = true)
      @data = data
      @escape_html = escape_html
    end

    def render(document)
      document.force_encoding(Encoding::UTF_8) if document.respond_to?(:force_encoding)
      data.each do |key, value|
        document.gsub!("$#{key.to_s.upcase}$", safe(value))
      end
      document
    end

    def safe(text)
      if escape_html
        text.to_s.gsub('&', '&amp;').gsub('>', '&gt;').gsub('<', '&lt;')
      else
        text.to_s
      end
    end
  end
end