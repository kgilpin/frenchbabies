require 'configliere'

Settings.define 'email-user-name', :env_var => 'EMAIL_USER_NAME', :description => 'Account email for receiving posts.'
Settings.define 'email-password', :env_var => 'EMAIL_PASSWORD', :description => 'Account password for receiving posts.'
Settings.define 'google-client-id', :env_var => 'GOOGLE_CLIENT_ID', :description => 'Google OAuth2 client id.'
Settings.define 'google-client-secret', :env_var => 'GOOGLE_CLIENT_SECRET', :description => 'Google OAuth2 client secret.'
Settings.define 'google-refresh-token', :env_var => 'GOOGLE_REFRESH_TOKEN', :description => 'Google OAuth2 refresh token.'
