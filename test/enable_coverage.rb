# frozen_string_literal: true

require 'simplecov'
require 'simplecov-console'

SimpleCov.formatter = SimpleCov.formatter = SimpleCov::Formatter::Console
SimpleCov.start do
  add_filter '/doc/'
  add_filter '/test/'
  add_filter '/features/'
  add_filter '/spec/'
  add_filter '/autotest/'
  add_group 'Binaries', '/bin/'
  add_group 'Libraries', '/lib/'
  add_group 'Extensions', '/ext/'
  add_group 'Vendor Libraries', '/vendor/'
end
