module Asciidoctor
  module Pdf
    module CJK
      module CJKGothic
        VERSION = "0.0.1"
      end

      def self.break_words(string)
        string.gsub(/(?<!^|\p{Space}|\p{Ps}|\p{Pi})[\p{Han}\p{Hiragana}\p{Katakana}\p{Ps}\p{Pi}]/) {|s| "#{::Prawn::Text::ZWSP}#{s}"}
      end
    end

    class Converter
      def typeset_text_with_break_words(string, line_metrics, opts = {})
        typeset_text_without_break_words ::Asciidoctor::Pdf::CJK.break_words(string), line_metrics, opts
      end
      alias_method :typeset_text_without_break_words, :typeset_text
      alias_method :typeset_text, :typeset_text_with_break_words
    end

    class ThemeLoader
      DataDir.replace ::File.expand_path(::File.join(::File.dirname(__FILE__), 'data'))
      ThemesDir.replace ::File.join DataDir, 'themes'
      FontsDir.replace ::File.join DataDir, 'fonts'
    end
  end
end
