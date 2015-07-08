require 'fileutils'
require 'nokogiri'
require 'erb'
require 'ostruct'

class Processor

  def initialize(options = {})
    @taxonomy_file_location = options.fetch(:taxonomy)
    @destinations_file_location = options.fetch(:destinations)
    @output_folder = options.fetch(:output_folder)
    produces_html_files(@taxonomy_file_location, @destinations_file_location, @output_folder)
  end

  # Start the process of creating the html files
  def produces_html_files(taxonomy_file_location, destinations_file_location, output_folder)
    @destinations_document = parse_xml_files(destinations_file_location)
    @taxonomy_document = parse_xml_files(taxonomy_file_location)
    output_folder_exist?(output_folder)
    copy_static_files(output_folder)
    destinations_list.each do |destination|
      generate_content_template(destination)
    end
  end

  # Parse XML input files
  def parse_xml_files(file_location)
    Nokogiri::XML(File.read(file_location))
  end

  # Create the output folder passed as an argument if it doesn´t exist
  def output_folder_exist? (output_folder)
    Dir.mkdir(output_folder) unless Dir.exist?(output_folder)
  end

  # Copy static_file(css) to the output folder
  def copy_static_files(output_folder)
    static_output_folder = "#{output_folder}/static"
    unless File.directory?(static_output_folder)
      FileUtils.mkdir_p(static_output_folder)
    end
    FileUtils.cp_r "static/.", "#{static_output_folder}"
  end

  # Build a list of destinations
  def destinations_list
    @destinations_document.xpath('//destination')
  end

  # Generate the content of the html files, and start their creation
  def generate_content_template(destination)
    @destination_name= (destination['title-ascii'])
    @content= overview_content(destination)
    get_parent(destination)                           # Method call
    get_children(destination)                         # Method call
    create_file_name(destination)                     # Method call
    render_template_and_write_files                   # Method call
  end

  # Generate the name of the resulting html files
  def create_file_name(destination)
    html_file_name= "#{destination['atlas_id']}.html"
    @html_file_location= "#{@output_folder}" + "/" + "#{html_file_name}"
  end

  # Take as a parameter a destination and generate the name and the link of the parent node, it will be used in the view
  def get_parent(destination)
    current_node= @taxonomy_document.xpath("//node[@atlas_node_id=#{destination['atlas_id']}]")
    current_node.each do |node|
      @parent_name= node.parent.xpath("node_name").text
      node_parent= node.parent
      @parent_link= "#{node_parent['atlas_node_id']}" + ".html"
    end
  end

  # Take as a parameter a destination and generate a hash which contains the name and the link of the children nodes, it
  #will be used in the view
  def get_children(destination)
    current_node= @taxonomy_document.xpath("//node[@atlas_node_id=#{destination['atlas_id']}]")
    @child_node= Hash.new
    @children_list= current_node.xpath("node")
    @children_list.each do |child|
      @child_node["#{child['atlas_node_id']}" + ".html"]= child.xpath("node_name").text
    end
  end

  # Load and render the erb template.
  def render_template_and_write_files
    template = File.read('template.erb')
    data= ERB.new(template).result(binding)
    File.open("#{@html_file_location}", 'w').write(data)
  end

  # Return information from the destination passed a parameter, in that case only the overview.
  def overview_content(destination)
    destination.xpath('./introductory/introduction/overview').first.text
  end

end