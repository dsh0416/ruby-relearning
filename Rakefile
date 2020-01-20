task :default => :test

task :test do
  sh "cutest ./tests/*.rb"
end

task :lint do
  file_list = %w(README.md SUMMARY.md chapter*/*.md appendix/*.md preface/*.md)
  sh "mdl -s ./.mdlrc #{file_list.join(' ')}"
end
