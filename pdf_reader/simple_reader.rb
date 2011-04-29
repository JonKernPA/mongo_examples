require 'rubygems'
require 'pdf_reader'

class SimpleReader
  def self.read_pdf(chart_name)
    p = PDFReader.new(File.dirname(__FILE__) + "/" + chart_name)
    puts p.raw_text
  end
  
end
puts "Test"
SimpleReader.read_pdf("test.pdf")
