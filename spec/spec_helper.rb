$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift File.expand_path('../../spec', __FILE__)
require 'handicapper'
require 'byebug'
require 'awesome_print'
require 'simplecov'

SimpleCov.start
