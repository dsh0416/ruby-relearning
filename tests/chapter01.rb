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

# Chapter 01, Variables
test 'check bool operations' do
  assert (true and true) == true
  assert (true and false) == false
  assert (false and true) == false
  assert (false and false) == false

  assert (true or true) == true
  assert (true or false) == true
  assert (false or true) == true
  assert (false or false) == false

  assert (not true) == false
  assert (not false) == true
end

# Chapter 01, Variables
test 'check bool operations with symbols' do
  assert (true && true) == true
  assert (true && false) == false
  assert (false && true) == false
  assert (false && false) == false

  assert (true || true) == true
  assert (true || false) == true
  assert (false || true) == true
  assert (false || false) == false

  assert !true == false
  assert !false == true
end

# Chapter 01, Variables
test 'check bool operations excercise' do
  assert (true && (true and not false) or !false || false) == true
end
