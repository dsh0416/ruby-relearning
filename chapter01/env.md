# 环境搭建

## Ruby 解释器

## 什么是解释器

## Ruby 解释器有什么？

Ruby 解释器是 Ruby 语言开发的核心。Ruby 是一个开放的语言，任何人都可以为 Ruby 实现自己的解释器。Ruby 的解释器多种多样，常见的仍在维护的解释器有：

- Ruby
  - Ruby MRI (CRuby)
  - JRuby
  - TruffleRuby
  - Rubinius
  - RubyMotion
  - Opal
- mruby
  - mruby
  - mruby/c

这些 Ruby 解释器各有一些差异，支持的语法和执行的性能也并不完全相同。本书所涉及的全部 Ruby 都指官方实现的 Ruby MRI。

MRI 代指 Matz's Ruby Interpreter，即 Ruby 创始人松本行弘最早实现的 Ruby 解释器，是 Ruby 的官方解释器。虽然在 Ruby 1.9 之后的版本中，官方已经把虚拟机换成了由 Kiochi Sasada 主导的 YARV (Yet another Ruby VM) 解释器。但在 1.9 版本后，YARV 已经被合并到 MRI，此后我们已不特别区分 MRI 和 YARV 了，现在仍称呼这一解释器实现为 Ruby MRI。下文所有的 Ruby 解释器，如无特殊标注，都是 Ruby MRI 解释器的缩写。

在撰写本章节的时候，Ruby 的最新版本是 2.7.0，本书全部的代码都在 2.7.0 中进行过测试。我们会自动化测试本书代码在不同环境下的兼容性，以确保正确性。

## 安装方法

### Windows 用户

在 Windows 上安装 Ruby 最简单的方式是 [RubyInstaller](https://rubyinstaller.org/)。在本书的编写过程中，我们会测试书中所有涉及到的程序在 Windows 上的兼容性。但由于 Ruby 的第三方依赖，特别是一些设计给 *NIX 服务器的依赖程序，可能没有测试在 Windows 上的兼容性，从而可能在使用上会遇到一定的困难。

一些教程不推荐新手在 Windows 上开发 Ruby。但事实上，Ruby 的标准库对于 Windows 的兼容性还是相当良好的。如果没有人在 Windows 上使用 Ruby，那么 Ruby 运行在 Windows 上的问题会变得更多，这是一个恶性循环。但是对于初学者，使用 Linux/macOS 进行开发依然是我个人推荐的。主要问题是，初学者缺乏对环境问题处理的经验，遇到问题往往会不知所措。大多数服务器软件的生产环境更愿意使用自由的 Linux 操作系统，而使用 Ruby 开发服务器应用是最常见的用途，使用和生产环境一致的环境，至少是 *NIX 环境能有效避免问题发生的概率。

关于 PC 用户如何选择和安装 Linux 发行版，本书单独开设附录章节来描述，请参阅附录一。另外，在 Windows 10 中可以使用 Windows Subsystem for Linux (WSL) 来产生一个无缝的 Linux 环境。详情请参阅微软的 [WSL 官方文档](https://docs.microsoft.com/en-us/windows/wsl/about)。


### *NIX 用户（Linux、macOS、BSD 用户）

#### RVM

RVM 是最推荐新手安装 Ruby 的方法。笼统来说，使用 RVM 安装 Ruby 需要三步。如果你是 macOS 用户，你可能需要先安装 XCode 和 XCode Command Line Tools 才能安装 RVM。

XCode 可以从 App Store 直接下载到，安装完成后打开「终端（Terminal）」应用，使用 `xcode-select --install` 安装 XCode Command Line Tools。

对于 Linux 用户，请确认自己的 Terminal 是 login shell 的模式。一些 Linux 发行版自带的 Terminal 应用没有 login，可能没有加载用户的环境变量。

第一步是获取 GPG 公钥，RVM 使用 GPG 密钥系统来确保程序在传输过程中不被篡改。打开终端应用，输入下面的命令即可获取 GPG 密钥。

```bash
gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
```

第二步则是一键安装脚本，下面的命令会下载 RVM。

```bash
\curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm # 载入 RVM 环境（新开 Terminal 就不用这么做了，默认自动重新载入的）
```

对于中国大陆地区用户，RVM 的自带镜像源可能下载速度太慢。为此 Ruby China 提供了镜像源，在执行第三步前可以使用

```bash
echo "ruby_url=https://cache.ruby-china.com/pub/ruby" > ~/.rvm/user/db
```

来切换镜像源。

最后一步就是执行下面命令来安装特定版本的 Ruby。

```bash
rvm install 2.7.0 # 这里的 2.7.0 可以切换成阅读本文时最新的 Ruby 版本。Ruby 最新版本可以在 https://www.ruby-lang.org/ 确认。
```

安装成功后可以使用

```bash
ruby -v
```

来检查所安装的 Ruby 版本有没有正确安装成功，如果返回了版本号，那么就是安装成功了。

详细的安装文档可以在 [rvm.io](https://rvm.io/) 来查询。

#### snap

Ruby 在 2018 年 11 月 8 日加入了官方的 snap 套件支持。如果你使用 Ubuntu 16.04 的后续版本，你可以一键安装 Ruby。

```bash
sudo snap install ruby --classic
```

使用 Snap 安装的 Ruby 可能会在环境变量上需要一些额外的配置。建议检查官方的 [新闻](https://www.ruby-lang.org/zh_cn/news/2018/11/08/snap/) 来确认细节。

#### 编译自源代码

在电子游戏《尼尔：机械纪元》的 [用户协议](https://www.jp.square-enix.com/nierautomata/sp/lisence/) 中，我们会发现出现了 Ruby License。可见在这款游戏中使用了 Ruby 语言实现了一定的功能。这款游戏首发在 PS4 平台上，而 PS4 的操作系统是一个修改自 FreeBSD 操作系统。所以 Ruby 语言对于 BSD 系的操作系统同样是非常友好的。

但如果你想在一些嵌入式设备上运行 Ruby 或者需要运行在 PS4 上，使用包管理器可能不是一个好主意，因为你不一定具有全局安装的权限或者不想引入额外的复杂度。这时候直接从源代码编译可能就变成了必须。

![Photo by Monika Grabkowska on Unsplash](/assets/cake-recipe.jpg)

> 生日快乐！欢迎自己编译你的蛋糕。 (Photo by Monika Grabkowska on Unsplash)

从源代码编译安装很简单，你可以先从 Ruby 官方网站下载 [最新的源代码](https://www.ruby-lang.org/zh_cn/downloads/)，在解压后执行：

```bash
./configure
make
```

进行编译。Ruby 的编译过程中，一些组件是可选的，你需要自己确认这些可选的依赖是否准备妥当。如果编译后需要安装，你可以执行：

```bash
sudo make install
```

进行安装。

#### 内置包管理器

使用例如 Ubuntu、Debian 内置的 `apt` 或者 CentOS、Fedora 内置的 `dnf` 或类似方法也可以很方便安装 Ruby。但是，大多数操作系统内建的软件源常有版本滞后、缺少组件的问题。如无必要，不推荐新手使用这样的安装方法。但如果你有一个可控、可信、维护良好的软件源，这也是一个不增加复杂度安装 Ruby 的好方法。
