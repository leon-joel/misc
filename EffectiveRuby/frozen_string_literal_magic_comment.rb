# frozen_string_literal: true
# ↑リテラル（"aaa"みたいなの）をデフォルトでfreezeする設定
#   ※ruby3.0からはこの設定（マジックコメント）がなくてもデフォルトでfreezeされる


puts <<~EOS

    ############## stringのfreezeに関する実験 ※ruby2.3/3.0で仕様が変わるので要注意 #################
    # ruby2.3より前  : string literalは明示的にfreezeしない限り、freezeされない
    # ruby2.3～      : マジックコメント frozen_string_literal: true によって
    #                  string literalがデフォルトでfreezeされる
    # ruby3.0～      : マジコメなしでもstring literalがデフォルトでfreezeされるようになる。
    #                  上記マジックコメントを明示的にfalseにすればfreezeされないようになる
EOS
abc = "abc"
nf = +"not frozen"
f = -"frozen"

# ruby2.3から導入された SQUIGGLY HEREDOC演算子を使って、インデントを取り除く ※ActiveSupportの strip_heredoc と同じ
puts <<~EOS
    #### frozen? 確認 ###
    普通のリテラル       : #{abc.frozen?} # -> true

    リテラルの前置+/-演算子:
       挙動が分かりにくく危険な香りがするので、使用の際には注意が必要
       ※これらの演算子の名前がよく分からない。文字列リテラル専用の演算子でもないようだし…

      +演算子の挙動（必ずfreezeされていないstringを返す）:
        freezeされているstring⇒複製を返す(freezeが外れる)  freezeされていない⇒selfを返す
        => #{nf.frozen?}    # -> false
      -演算子の挙動（必ずfreezeされているstringを返す）:
        freezeされているstring⇒selfを返す  freezeされていない⇒freezeされた複製を返す
        => #{f.frozen?}     # -> true
    ###############################################################################################

EOS

