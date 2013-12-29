#!/usr/bin/env rake

$LOAD_PATH << File.expand_path('lib', File.dirname(__FILE__))

task :tick do
  require 'frenchbabies'
  require 'configliere'
  
  Settings.define 'email-user-name', :env_var => 'EMAIL_USER_NAME', :description => 'Account email for receiving posts.'
  Settings.define 'email-password', :env_var => 'EMAIL_PASSWORD', :description => 'Account password for receiving posts.'
  
  Settings.use :commandline
  Settings.resolve!
  
  FrenchBabies.initialize
  FrenchBabies.tick
end

task :secret, :email do |task,args|
  require 'frenchbabies'
  email = args[:email]
  puts FrenchBabies.secret_code(email)
end
