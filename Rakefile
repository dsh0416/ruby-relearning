require 'rake/testtask'

task :default => :test

Rake::TestTask.new(:test) do |t|
  t.libs << "tests"
  t.test_files = FileList["tests/*.rb"]
end

task :build => [:clean] do
  require 'asciidoctor'
  source = 'book.adoc'
  doc = Asciidoctor.load_file source
  docname = doc.attributes['docname']
  version = doc.attributes['revnumber']
  filename = docname
  build_dir = "build/#{docname}"

  # Build html
  sh "bundle exec asciidoctor -D #{build_dir}/#{filename} -r asciidoctor-mathematical -a mathematical-format=svg -o index.html #{source}"
  cp_r 'images', "#{build_dir}/#{filename}"
  sh 'mkdir -p book'
  cp_r 'images', "book/images" # FIXME: Hack for existingasciidoctor-mathematical bug

  # Build pdf
  sh "bundle exec asciidoctor-pdf -D #{build_dir} -o #{filename}.pdf -r ./cjk-gothic.rb -r asciidoctor-mathematical -a mathematical-format=svg -a pdf-style=cn #{source}"

  # Build epub
  sh "bundle exec asciidoctor-epub3 -D #{build_dir} -o #{filename}.epub #{source}"
end

task :clean do
  rm_r Dir['build/*']
  rm_r Dir['book/*']
end

task :lint do
  file_list = %w(README.md SUMMARY.md chapter*/*.md appendix/*.md preface/*.md)
  sh "mdl -s ./.mdlrc #{file_list.join(' ')}"
end
