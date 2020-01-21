# 函数

## 函数定义

```ruby
def succ(x)
  x += 1
end
```

### 豆知识：`void` or `nil`?

在 Ruby 中任何方法都有「返回值」，但返回值可能为「空」。这句话听起来非常拗口，我们来简单比较一下。如果我们在 C++ 语言中定义一个函数如下：

```cpp
void void_function() {
  return;
}

int main() {
  auto x = void_function(); // illegal, 非法代码。
  return 0;
}
```

这段代码是非法的，因为 `void_function()` 没有返回值，不能让其结果赋值给 `x`。
