require 'bundler/gem_tasks'
require 'rake/testtask'

THRIFT_IN = 'test/test.thrift'
THRIFT_OUT = Rake::FileList['test/gen-rb/test_constants.rb', 'test/gen-rb/test_types.rb']

THRIFT_OUT.each do |output|
  file output => THRIFT_IN do
    sh 'thrift', '-o', 'test', '--gen', 'rb', THRIFT_IN
  end
end

desc 'Cleans generated files from workspace'
task :clean do
  rm THRIFT_OUT
end

Rake::TestTask.new do |t|
  t.test_files = Rake::FileList['test/**/*_test.rb']
end
task test: THRIFT_OUT # add dependency

task default: :test
