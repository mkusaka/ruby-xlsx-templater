module XlsxTemplater
  module_function

  def log(str)
    puts str if ENV['DEBUG']
  end
end

require 'xlsx_templater/template_processor'
require 'xlsx_templater/xlsx_creator'
