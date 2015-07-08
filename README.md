# Batch Processor (Lonely Planet technical test)
The app takes two xml input files ese and produces an .html file (based on an output template given) for each destination. It as been developed using ruby 2.0.0

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

* It would be interesting break down the app into different classes avoiding the repetition of some code and improving its performance.
