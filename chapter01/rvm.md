# 如何管理 Ruby 版本

使用 rvm 的一个好处是可以很好管理不同的 Ruby 版本。刚开始写 Ruby 的时候可能不太会意识到这件事情的重要性。但是下面这几种需求在实际开发中可能会发生：

- Ruby 版本更新了，怎么升级？
- 想临时测试某一特定版本 Ruby 的特性，怎么临时切换？
- 如何指定项目的 Ruby 版本，来确保服务器运行环境和开发环境一致？

## 如何安装新的 Ruby 版本？

检查可以安装的 Ruby 版本
```bash
rvm list known
```

```bash
rvm get head
```

```bash
rvm install 2.7.0
```

## 如何设置默认 Ruby 版本？

```bash
rvm --default use 2.7.0
```

```bash
rvm -v
```

## 如何临时切换 Ruby 版本？

```bash
rvm use 2.7.0
```

## 如何设置项目的特定 Ruby 版本？

```ruby
# Gemfile

ruby '2.7.0'
```

Gemfile 是 Bundler 提供依赖管理的重要文件，有关于这方面的功能，我们会在「第六周：Ruby 工程化入门」中重点介绍。
