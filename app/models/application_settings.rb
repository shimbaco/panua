# coding: utf-8

# https://github.com/binarylogic/settingslogic

class ApplicationSettings < Settingslogic
  source "#{Rails.root}/config/application.yml"
  namespace Rails.env
end