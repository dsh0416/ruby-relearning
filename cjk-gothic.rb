require "asciidoctor/pdf/cjk"
require "asciidoctor/pdf/cjk/kai_gen_gothic/version"
require "asciidoctor/pdf/cjk/kai_gen_gothic/theme_loader.rb"

module Asciidoctor
  module Pdf
    module CJK
      module CJKGothic
        VERSION = "0.0.1"
      end
    end

    class ThemeLoader
      DataDir.replace ::File.expand_path(::File.join(::File.dirname(__FILE__), 'data'))
      ThemesDir.replace ::File.join DataDir, 'themes'
      FontsDir.replace ::File.join DataDir, 'fonts'
    end
  end
end
