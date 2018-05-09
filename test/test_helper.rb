require 'bundler/setup'

$LOAD_PATH << File.expand_path('../gen-rb', __FILE__)

require 'thrift-validator'

Thrift.type_checking = true

require 'test_types'
require 'minitest/autorun'
