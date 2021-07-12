require 'zip'

SHARED_STRINGS_XML = "xl/sharedStrings.xml"

module XlsxTemplater
  class XlsxCreator
    attr_reader :template_path, :template_processor

    def initialize(template_path, data, escape_html = true)
      @template_path = template_path
      @template_processor = TemplateProcessor.new(data, escape_html)
    end

    def generate_xlsx_file(file_name = "output_#{Time.now.strftime('%Y-%m-%d_%H%M')}.xlsx")
      File.open(file_name, 'w') do |f|
        f.write(generate_xlsx_bytes.string)
      end
    end

    def generate_xlsx_bytes
      Zip::OutputStream.write_buffer(StringIO.new) do |out|
        Zip::File.open(template_path).each do |entry|
          entry_name = entry.name
          out.put_next_entry(entry_name)
          out.write(copy_or_template(entry_name, entry.get_input_stream.read.force_encoding(Encoding::UTF_8)))
        end
      end
    end

    private
    def copy_or_template(entry_name, entry_bytes)
      if entry_name == SHARED_STRINGS_XML
        template_processor.render(entry_bytes)
      else
        entry_bytes
      end
    end
  end
end
