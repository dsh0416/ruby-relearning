require 'stringio'
require 'open3'
require 'minitest/autorun'

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

  # Chapter 01, Variables
  def test_int_ops
    assert_equal 1 + 1, 2
    assert_equal 1 - 5, -4
    assert_equal 3 * 7, 21
    assert_equal 6 / 2, 3
    assert_equal 5 / 2, 2
    assert_equal 5 % 2, 1
    assert_equal (-5 % 2), 1

    assert_equal 5 % -2, -1
    assert_equal (-5 % -2), -1
    assert_raises ZeroDivisionError do
      3 / 0
    end
    assert_equal 10000000000000000000 * 10000000000000000000, 100000000000000000000000000000000000000
    assert_equal 2**256, 115792089237316195423570985008687907853269984665640564039457584007913129639936
  end

  # Chapter 01, Variables
  def test_local_variables
    a = 1
    assert_equal a + 1, 2
    assert_equal a + 3, 4
    a = 2
    assert_equal a + 1, 3
    assert_equal a + 3, 5
    assert_raises SyntaxError do
      eval('2 = a')
    end
  end

  # Chapter 01, Variables (Answers)
  def test_local_variables_answers
    assert_equal(capture_stdout do
      a = 1
      b = 1
      puts a + b
    end, "2\n")

    assert_equal(capture_stdout do
      a = 1
      b = 1
      puts a * b
    end, "1\n")

    a = 1
    b = 1
    c = a + b
    assert_equal c, 2
  end

  # Chapter 01, Consts
  def test_consts
    assert_equal `ruby -e "CONST_A = 'foo';CONST_A = 'bar';puts CONST_A"`, "bar\n"
  end

  # Chapter 01, Consts
  def test_freeze
    assert_raises FrozenError do
      a = 'foo'.freeze
      a << 'bar'
    end

    a = 'foo'.freeze
    a = 'bar'
    assert_equal(a, 'bar')
  end

  # Chapter 01, Functions
  def test_func_with_single_arg
    assert_equal(proc do
      def succ(x)
        x + 1
      end

      succ(1)
    end.call, 2)
  end

  # Chapter 01, Functions
  def test_func_with_no_args
    assert_equal(proc do
      def hello
        'Hello'
      end

      hello
    end.call, 'Hello')
  end

  # Chapter 01, Functions
  def test_func_with_multi_args
    assert_equal(proc do
      def add(a, b)
        a + b
      end

      add(1, 2)
    end.call, 3)
  end

  # Chapter 01, Functions
  def test_func_with_early_stop
    assert_equal(proc do
      def add(a, b)
        return a + b
        a - b
      end

      add(1, 1)
    end.call, 2)
  end

  # Chapter 01, Functions
  def test_func_call
    assert_equal(proc do
      def add(a, b)
        return a + b
      end

      add 1, 1
    end.call, 2)
  end

  # Chapter 01, Functions
  def test_func_nil_return
    assert_nil(proc do
      def nil_func
        return
      end

      nil_func
    end.call)
  end

  # Chapter 01, Functions
  def test_undef
    assert_raises NameError do
      def foo
        'bar'
      end
      assert_equal(foo, 'bar')
      undef foo
      foo
    end
  end
end
