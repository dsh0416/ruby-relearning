# 如何理解 Ruby 变量与常量

**让人出乎意料的是：Ruby 并没有真正意义的常量**

```ruby
CONST_A = 'foo'
CONST_A = 'bar' # => warning: already initialized constant CONST_A
puts CONST_A # 'bar'
```

```ruby
a = 'foo'.freeze
a << 'bar' # FrozenError (can't modify frozen String: "a")
```

```ruby
a = 'foo'.freeze
a = 'bar'
puts a # 'bar'
```

immutable 不变量
