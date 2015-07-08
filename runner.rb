require 'optparse'
require_relative 'lib/processor'

options = {}
optparse = OptionParser.new do |opts|
  opts.on('-d', '--destinations DESTINATIONS',
    'Location of the destinations.xml file') do |destinations|
     options[:destinations] = destinations
  end

  opts.on('-t', '--taxonomy TAXONOMY',
    'Location of the taxonomy.xml file') do |taxonomy|
    options[:taxonomy] = taxonomy
  end

  opts.on('-o', '--output_folder OUTPUT_F.',
    'Output folder') do |output_folder|
    options[:output_folder] = output_folder
  end
end

begin
optparse.parse!
puts "Performing task ...."

required = [:destinations, :taxonomy, :output_folder]
missing = required - options.keys

  if missing.any?
     puts "Warning: One or more arguments are missing: #{missing.join(', ')}"
     puts optparse.help
     exit
  end

  rescue OptionParser::InvalidOption, OptionParser::MissingArgument
  puts "Warning: An argument cannot leave in blank"                                # Friendly output when parsing fails
  puts optparse.help
  exit
end

processor = Processor.new(options)
processor.produces_html_files
