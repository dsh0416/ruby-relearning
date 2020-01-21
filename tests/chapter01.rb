require 'stringio'
require "minitest/autorun"

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

class TestChapter01 < Minitest::Test
  # Chapter 01, Editor
  def test_print_hello_world_and_returns_nil
    output = capture_stdout { puts 'Hello World' }
    assert_equal output, "Hello World\n"
    assert_nil (puts 'Hello World')
  end

  # Chapter 01, Editor
  def test_the_combination_of_print_puts_and_p
    output = capture_stdout do
      print 'Hello'
      puts 'Hello'
      p 'Hello'
    end
    assert_equal output, "HelloHello\n\"Hello\"\n"
  end


  # Chapter 01, Variables
  def test_bool_operations
    assert_equal (true and true), true
    assert_equal (true and false), false
    assert_equal (false and true), false
    assert_equal (false and false), false

    assert_equal (true or true), true
    assert_equal (true or false), true
    assert_equal (false or true), true
    assert_equal (false or false), false

    assert_equal (not true), false
    assert_equal (not false), true
  end

  # Chapter 01, Variables
  def test_bool_ops_with_sym
    assert_equal (true && true), true
    assert_equal (true && false), false
    assert_equal (false && true), false
    assert_equal (false && false), false

    assert_equal (true || true), true
    assert_equal (true || false), true
    assert_equal (false || true), true
    assert_equal (false || false), false

    assert_equal !true, false
    assert_equal !false, true
  end

  # Chapter 01, Variables
  def test_bool_ops_practice
    assert_equal (true && (true and not false) or !false || false), true
  end
end
