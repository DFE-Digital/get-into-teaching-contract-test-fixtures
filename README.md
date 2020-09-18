#Contract test fixture generator for the Get Into Teaching Service Components

The data profiles XLSX file is exported from https://docs.google.com/spreadsheets/d/1586WsCHLH6OuHf3DRno4EicF2tNyk-tphRZ8fUi_IGA/edit#gid=0. If you need access to edit you will need to request this access.

Once the exported XLSX file has been placed over the existing repository file you will need to run the generator script to create the test fixture data files.

```shell
$ ruby ./generate.rb
```

This process will update the candidate data files in the contract folder. The generated files will need to be included in all the component test suites so that they all run against the same set of contract scenarios.