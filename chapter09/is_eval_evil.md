# Is eval evil?

> 这篇文章取自博客，需要大幅改写

## 引

对于大多数动态语言，都支持 `eval` 这个神奇的函数。这打他们太爷爷 Lisp 开始就支持这种方法。虽然写法（eg: `(eval '(+ 1 2 3))` ）有稍许不同，但语义是一样的，就是说 `eval` 函数接受一个字符串类型作为参数，将其解析成语句并混合在当前作用域内运行。但我想大家也都听过这么一句话：

> eval is evil.

但是 How evil is eval？那么既然 `eval` 如此罪恶，那么为什么它仍被那么多动态语言作为接口暴露呢？我们不妨来仔细探讨一下 `eval` 在使用中究竟会产生什么问题，在日常编程中究竟该不该使用 `eval`，如果要用，那么又该如何使用。

## 字符串安全

说到 `eval` 第一个会被讨论的当然就是其安全性。比如说，我们现在来实现一个四则运算器：

```ruby
loop do
  print('Expression: ')
  puts("result: #{eval gets.chomp}")
end
```

```text
Expression: 1+1
result: 2
Expression: 2+2
result: 4
Expression: 3*4
result: 12
Expression: 4+(1*1)
result: 6
```

Awesome! 这段程序实现了全部四则运算的功能！只不过，这东西实现了 **不止** 四则运算的功能，事实上，它能处理任意 Ruby 语句，实际上这已经是一个 REPL（Read-Eval-Print Loop）了。我们可以运行一些「危险」的代码，比如：

```text
Expression: exit
Process exit with code 0
```

更实际的应用是，在 JavaScript 中，如果你想要支持 IE7 的话，`JSON.parse()` 是不被支持的，除非你引入一个 JSON 解析库，最方便的写法就是 `eval(json)`，因为毕竟 JSON 也是合法的 JavaScript 语句，这样的方法安全性问题是显然的。

这样的问题不止 `eval` 有，事实上，所有和字符串打交道的事情，或多或少都有类似的问题。比如「SQL 注入」说到底也就是这么一回事。再比如你在 Ruby 代码中试图操作 `git` 命令的时候，如果你使用反引号，也可能遇到这样的问题。

不过我们来看下面这个例子：

```ruby
# gems/rest-client-1.6.7/bin/restclient 摘自《Ruby 元编程(第二版)》第 142 页
POSSIBLE_VERBS = ['get', 'put', 'post', 'delete']
POSSIBLE_VERBS.each do |m|
  eval <<-end_eval
    def #{m}(path, *args, &b)
      r[path].#{m}(*args, &b)
     end
  end_eval
end
```

在这个例子中，也使用了 `eval`，也在 `eval` 中拼接了字符串，存在字符串拼接的安全性问题吗？并没有。因为是从常量数组中读取的字符串，并不存在用户任意输入导致注入的问题。

但，我们反过来说，SQL 驱动自带的 `query` 函数都可能存在注入，难道我们就不用 SQL 了吗？并没有。事实上，注入问题是可以被解决的。如果我们做好对用户输入的 **过滤** 和 **转义** 同样也能解决。问题就在于，这么做的成本和 `eval` 带来的动态性好处，哪个更大的权衡问题。

## Lexer & Parser

> 本来想用中文写这个小标题，但感觉「词法分析器和语法分析器」实在这标题太长了

学过一些《编译原理》都知道，无论是解释器还是编译器，拿到字符串无非就是

`词法分析 -> 语法分析 -> 语义检查 -> 生成语法树 -> 代码优化 -> 生成目标代码/执行`

使用 `eval` 函数意味着，你的程序需要在运行时经历全部的这些步骤。通常来说即使是脚本语言，在你加载所有文件初始化运行的过程中。前期步骤通常都已经完成了，只剩下最后一步执行了。不过加入 `eval` 之后就不一样了。因为 `eval` 传入的是字符串，所以这意味着它需要对这一部分代码从词法分析开始重新走一遍。事实上，词法分析、语法分析、语义检查并不快。

比如说，我们对比下面的代码

```ruby
GC.disable # 禁用 GC 以避免后一段代码在运行过程中遭遇 GC 对其不公

time = Time.now.to_f
1000000.times do
  rand+rand
end
puts "Without eval: #{Time.now.to_f - time}"

time = Time.now.to_f
1000000.times do
  eval('rand+rand')
end
puts "With eval: #{Time.now.to_f - time}"
```

```text
Without eval: 0.11499691009521484
With eval: 6.516125917434692
```

慢了 55 倍。如果我们用 Ruby 自带的 profiler 对这两段代码跑一下的话，结果如下：

没有 eval：

```text
  %   cumulative   self              self     total
 time   seconds   seconds    calls  ms/call  ms/call  name
 62.15    17.03     17.03  1000000     0.02     0.02  nil#
 18.65    22.14      5.11        1  5110.00 27400.00  Integer#times
 12.77    25.64      3.50  2000000     0.00     0.00  Kernel#rand
  6.42    27.40      1.76  1000000     0.00     0.00  Float#+
  0.00    27.40      0.00        2     0.00     0.00  Time.now
  0.00    27.40      0.00        2     0.00     0.00  Fixnum#fdiv
  0.00    27.40      0.00        2     0.00     0.00  Numeric#quo
  0.00    27.40      0.00        2     0.00     0.00  Time#to_f
  0.00    27.40      0.00        1     0.00     0.00  Float#-
  0.00    27.40      0.00        1     0.00     0.00  Float#to_s
  0.00    27.40      0.00        2     0.00     0.00  IO#write
  0.00    27.40      0.00        1     0.00     0.00  IO#puts
  0.00    27.40      0.00        1     0.00     0.00  Kernel#puts
  0.00    27.40      0.00        1     0.00     0.00  TracePoint#enable
  0.00    27.40      0.00        1     0.00     0.00  TracePoint#disable
  0.00    27.40      0.00        2     0.00     0.00  IO#set_encoding
  0.00    27.40      0.00        2     0.00     0.00  Fixnum#+
  0.00    27.40      0.00        2     0.00     0.00  Time#initialize
  0.00    27.40      0.00        1     0.00 27400.00  #toplevel
```

有 eval：

```text
  %   cumulative   self              self     total
 time   seconds   seconds    calls  ms/call  ms/call  name
 57.58    25.67     25.67  1000000     0.03     0.03  Kernel#eval
 16.02    32.81      7.14  1000000     0.01     0.04  nil#
 13.14    38.67      5.86        1  5860.00 44580.00  Integer#times
  9.17    42.76      4.09  2000000     0.00     0.00  Kernel#rand
  4.08    44.58      1.82  1000000     0.00     0.00  Float#+
  0.00    44.58      0.00        2     0.00     0.00  Fixnum#fdiv
  0.00    44.58      0.00        2     0.00     0.00  Numeric#quo
  0.00    44.58      0.00        2     0.00     0.00  Time#to_f
  0.00    44.58      0.00        1     0.00     0.00  Float#-
  0.00    44.58      0.00        1     0.00     0.00  Float#to_s
  0.00    44.58      0.00        2     0.00     0.00  IO#write
  0.00    44.58      0.00        1     0.00     0.00  IO#puts
  0.00    44.58      0.00        1     0.00     0.00  Kernel#puts
  0.00    44.58      0.00        1     0.00     0.00  TracePoint#enable
  0.00    44.58      0.00        1     0.00     0.00  TracePoint#disable
  0.00    44.58      0.00        2     0.00     0.00  IO#set_encoding
  0.00    44.58      0.00        2     0.00     0.00  Fixnum#+
  0.00    44.58      0.00        2     0.00     0.00  Time#initialize
  0.00    44.58      0.00        2     0.00     0.00  Time.now
  0.00    44.58      0.00        1     0.00 44580.00  #toplevel
```

虽然在 profile 的掺和下，差距被缩小到了几倍之内，但也可以看出 `eval` 函数自行的语法解析有多么耗时。所以说，如果你的 `eval` 是一次性运行与加载时候的，比如上面那个 Rest Client 的例子里，问题并不大，但如果你的 `eval` 是被频繁调用的话，使用 `eval` 是非常影响性能的，不应该这么使用。

## 静态分析与代码优化

在分析这个问题前，我们先来看两段代码：

```cpp
#include <cstdio>
void recursion_loop(int count){
  printf("Count: %d\n", count);
  if (count == 0) {return;}
  recursion_loop(count - 1);
}

int main(){
  recursion_loop(100000);
  return 0;
}
```

```ruby
def recursion_loop(count)
  puts("Count: #{count}")
  return if count == 0
  recursion_loop(count - 1)
end

recursion_loop(100000)
```

为什么第一段代码在 C++ 中可以正确运行（注：需要开启 -O2 编译选项），而第二段代码在 Ruby 下会报错。

```text
/Users/Delton/RubymineProjects/untitled/script4.rb:2:in `puts': stack level too deep (SystemStackError)
  from /Users/Delton/RubymineProjects/untitled/script4.rb:2:in `puts'
  from /Users/Delton/RubymineProjects/untitled/script4.rb:2:in `recursion_loop'
  from /Users/Delton/RubymineProjects/untitled/script4.rb:4:in `recursion_loop'
  from /Users/Delton/RubymineProjects/untitled/script4.rb:4:in `recursion_loop'
  from /Users/Delton/RubymineProjects/untitled/script4.rb:4:in `recursion_loop'
  from /Users/Delton/RubymineProjects/untitled/script4.rb:4:in `recursion_loop'
  from /Users/Delton/RubymineProjects/untitled/script4.rb:4:in `recursion_loop'
  from /Users/Delton/RubymineProjects/untitled/script4.rb:4:in `recursion_loop'
   ... 10908 levels...
  from /Users/Delton/RubymineProjects/untitled/script4.rb:4:in `recursion_loop'
  from /Users/Delton/RubymineProjects/untitled/script4.rb:7:in `<top (required)>'
  from -e:1:in `load'
  from -e:1:in `<main>'
```

报错的原因很显然，栈太深了。这个用递归实现的循环，需要建一个深度高达 100000 层深栈。一般的运行时都不会允许这么深的栈。诶？等一下，那为什么在 C++ 中这段代码可以正常运行呢？因为你的 C++ 编译器发现了这是一个「尾递归」，可以进行「尾递归优化」。尾递归可以被优化成一个非递归形式，自然就不需要那么深的栈了。

这就是 `词法分析 -> 语法分析 -> 语义检查 -> 生成语法树 -> 代码优化 -> 生成目标代码/执行` 的倒数第二步。Ruby 中也有尾递归优化的选项，但默认不开启。开启的话方法也比较复杂，需要用到 `InstrctionSequence` 这个编译中间码的类，代码如下：

```ruby
RubyVM::InstructionSequence.compile_option = {
    :tailcall_optimization => true,
    :trace_instruction => false
}

source = <<-end_source
  def recursion_loop(count)
    puts("Count: \#{count}")
    return if count == 0
    recursion_loop(count - 1)
  end
  recursion_loop(100000)
end_source

RubyVM::InstructionSequence.new(source).eval
```

**注：事实上，这里开启的是尾调用优化，尾调用是尾递归的超集，开启尾调用优化不止会优化尾递归。**

但下面这段尾递归代码在即使开启优化的情况下，一样不会得到优化：

```ruby
def recursion_loop(count)
  puts("Count: #{count}")
  return if count == 0
  eval('recursion_loop(count - 1)')
end

recursion_loop(100000)
```

这段代码把一个明明是尾递归的情况破坏成了非尾递归。因为编译器静态分析的时候根本不知道你 `eval` 里是什么东西。怎么可能给你优化？

虽然这个例子非常极端，但其实不止 `eval`，比如：

```ruby
@next_recursion = proc { |count|
  recursion_loop(count - 1)
}

def recursion_loop(count)
  puts("Count: #{count}")
  return if count == 0
  @next_recursion.call(count)
end

recursion_loop(100000)
```

大多数动态方法，都没有办法被静态分析，以提供足够的优化。以至于动态语言的代码优化也一直是一大难点。

## 对 eval 魔法的思考

总结一下，谈一谈对「eval 魔法」的思考。`eval` 在元编程里也一直属于接近于禁术的那种类型。就好像核武器一样可怕。在用 `eval` 的时候要充分认识到可能带来的后果，才能对其进行使用。核国家的战争也不一定非要互相丢核武器，如果常规武器可以解决的，不必如此大动干戈。比如说前面 rest-client 的例子，也可以不用 `eval`：

```ruby
POSSIBLE_VERBS = ['get', 'put', 'post', 'delete']
POSSIBLE_VERBS.each do |m|
  define_method(m) do |path, *args, &b|
    r[path].send(m, *args, &b)
  end
end
```

也可以解决这样的问题。不过 `define_method` 的方法，也不能给代码带来静态分析，而这又是在启动时一次性执行的代码，对性能的提升是微乎其微的。所以 rest-client 的 `eval` 实现并谈不上 evil。

`eval` 被那么多语言至今沿用，其巨大的灵活性带来的便利是毋庸置疑的。只是说，使用 `eval` 包括使用任何元编程技巧的时候，都要充分考虑到这么做的可能造成的后果，以免莽撞瞎写，误伤自己。

## 彩蛋

在 [Leetcode #20](https://leetcode.com/problems/valid-parentheses/) 括号匹配问题里，有一个可以用 JavaScript 的 `eval` 实现的魔法写法，非常有趣，大家可以看看开心开心。

```javascript
/**
 * @param {string} s
 * @return {boolean}
 */
var isValid = function(s) {
    s = s.replace(/\(/g, '+(');
    s = s.replace(/\[/g, '+[');
    s = s.replace(/\{/g, '+{0:');
    s = s.replace(/\)/g, '+0)');
    s = s.replace(/\]/g, '+0]');
    s = s.replace(/\}/g, '+0}');
    try{
        eval(s);
    } catch(err) {
        return false;
    }
    return true;
};
```
