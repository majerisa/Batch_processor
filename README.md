# Batch XML Processor
The app takes two xml input files, taxonomy.xml holds the information about how destinations are related to each other and destinations.xml holds the actual text content for each destination, and produces an .html file (based on an output template given) for each destination. 
It as been developed using ruby 2.0.0

## To install dependencies, run:

    $ bundle install

## To run the tests:

    $ rspec spec/processor_spec.rb

## To run the app:

 E.g.

    $ ruby runner.rb -t xmlfolder/taxonomy.xml -d xmlfolder/destinations.xml -o output

The files will be created in the folder previously passed as an argument.

## Notes:

* I have included in the resulting html files the overview of each destination, as include more information will be a repetitive task.

## Next steps:
* Test the whole app as I have only tested the input of the processor file.
* Add more error handling code as I´m only handling the error in the input. But it should be taken into consideration other points, such as the input can not be a valid XML format or xpath returning no nodes when is looking for the current_node...


