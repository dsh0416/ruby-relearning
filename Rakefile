require 'rake/testtask'

task :default => :test

Rake::TestTask.new(:test) do |t|
  t.libs << "tests"
  t.test_files = FileList["tests/*.rb"]
end

task :lint do
  file_list = %w(README.md SUMMARY.md chapter*/*.md appendix/*.md preface/*.md)
  sh "mdl -s ./.mdlrc #{file_list.join(' ')}"
end
