require 'frenchbabies'
require 'configliere'

Settings.use :commandline
Settings.resolve!

FrenchBabies.initialize

FrenchBabies.tick

