require 'rubygems'
require 'pdf_reader'

class SimpleReader
  def self.read_pdf(chart_name)
    p = PDFReader.new(File.dirname(__FILE__) + "/" + chart_name)
    puts p.raw_text
    last = nil
    ["brother","father","family","tribe","neighbouring tribe","regional community","fellow citizens","foreigners"].each_with_index { |curr,i| puts "I hate my #{last} --> But I stand with my #{last} against my #{curr}" unless i == 0; last = curr; }
  end
  
end
puts "Test"
SimpleReader.read_pdf("test.pdf")
