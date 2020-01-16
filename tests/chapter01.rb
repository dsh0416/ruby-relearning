require 'stringio'

def capture_stdout(&block)
  original_stdout = $stdout
  $stdout = fake = StringIO.new
  begin
    yield
  ensure
    $stdout = original_stdout
  end
  fake.string
end

# Chapter 01, Editor
test 'print Hello World and returns nil' do
  output = capture_stdout { puts 'Hello World' }
  assert output == "Hello World\n"
  assert (puts 'Hello World') == nil
end

# Chapter 01, Editor
test 'check the combination of print puts and p' do
  output = capture_stdout do
    print 'Hello'
    puts 'Hello'
    p 'Hello'
  end
  assert output == "HelloHello\n\"Hello\"\n"
end
