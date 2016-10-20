require 'rspec'

describe '正規表現の実験' do

  str1 =  "1-2-23, Nantoka-Cho, Minato, Tokyo, Japan"

  str2 = <<~EOS
    1-2-23, Nantoka-Cho,
    Minato, Tokyo,
    Japan
  EOS

  describe 'POSIX文字クラス' do
    # 制御文字じゃない文字だけで構成されていることを確認
    # ※ POSIX文字クラス [:xxx:] は文字クラス [] の中でしか使えない ※https://docs.ruby-lang.org/ja/latest/doc/spec=2fregexp.html
    reg = /\A[[:^cntrl:]]+\z/
    # \A … 文字列先頭
    # \z … 文字列末尾

    it "制御文字が含まれているかどうかをチェックする" do
      expect(str1 =~ reg).to be_truthy
      expect($&).to eq str1

      expect(str2 =~ reg).to be_falsey
      expect($&).to be_nil
    end

    it '全角も制御文字とは扱われない＆全角文字数も正しくカウントされる' do
      str = "東京都　港区　赤坂　１－２－２３ "
      len = 17

      expect(str =~ /\A[[:^cntrl:]]{#{len}}\z/).to be_truthy
      expect($&).to eq str

      expect(str.length).to eq len
    end

    it '参考:ヒアドキュメントの改行は \n のようだ' do
      # ヒアドキュメントに限らず、文字列リテラルに含まれる改行文字は常に \n となるようだ。
      # https://docs.ruby-lang.org/ja/latest/doc/spec=2fliteral.html

      str = <<~EOS
        line1
      EOS
      expect(str).to eq "line1\n"

      # 末尾改行を取り除くには chomp
      str = <<~EOS.chomp
        1st line
      EOS
      expect(str).to eq "1st line"
    end
  end

  # 正規表現によるバリデーションでは ^ と $ ではなく \A と \z を使おう ～ 徳丸浩の日記
  # http://blog.tokumaru.org/2014/03/z.html
  # ※『安全なWEBアプリケーションの作り方』にも詳しく記載されている。(p.81あたり)
  #
  # Railsの正規表現でよく使われる \A \z って何？？ ～ jnchitoさんの記事
  # http://qiita.com/jnchito/items/ea7832df6f64a9034872

  describe "正規表現によるバリデーションで ^ と $ を使ってしまうと" do
    reg2 = /^[[:^cntrl:]]+$/

    it '行頭行末 ^ $ を使ってしまうと…' do
      expect(str2 =~ reg2).to be_truthy         # 当然改行が含まれていても（1行目だけで）マッチしてしまう！
      expect($&).to eq "1-2-23, Nantoka-Cho,"   #
    end
  end

  describe "\\Z と \\z の違いを確認" do
    # \Z, \z の違い
    # http://www.rubylife.jp/regexp/anchor/index4.html
    # \Z … 文字列末尾。但し、末尾が改行の場合はその手前まででマッチする。
    # \z … 文字列末尾。（末尾改行も含む）

    it '末尾改行がなければ \z も \Z も同じ結果だが…' do
      expect("abc" =~ /\Aabc\Z/).to be_truthy
      expect($&).to eq "abc"

      expect("abc" =~ /\Aabc\z/).to be_truthy
      expect($&).to eq "abc"
    end

    context '末尾改行がある場合' do
      it '\Z はその手前にマッチしてしまう' do
        expect("abc\n" =~ /\Aabc\Z/).to be_truthy
        expect($&).to eq "abc"
        # つまり、\Zは末尾改行を特別扱いしていると言うこと。
      end

      it '\z は本当の文字列末尾（末尾改行の後ろ）にマッチする' do
        expect("abc\n" =~ /\Aabc\z/).to be_falsey
        expect($&).to be_nil
      end
    end
  end

  describe " \\d \\w \\s は全角にもマッチする？" do

    describe "[Ruby1.9.3以降？] デフォルトでは \\d \\w \\s は全角文字にマッチしない" do
      it "全角数字は \\d に含まれない"do
        expect("０１８９" =~ /\d+/).to be_falsey
        expect($&).to be_nil
      end
  
      it "全角文字（全角スペースも）は \\w に含まれない" do
        expect("ＡＢＣａｂｃＸＹＺｘｙｚ　" =~ /\w+/).to be_falsey
        expect($&).to be_nil
      end

      it "空白文字[ \\t\\r\\n\\f\\v] \\s" do
        expect("　" =~ /\s+/).to be_falsey
        expect($&).to be_nil
      end

    end

    describe "[Ruby2.0以降] 正規表現オプション (?u: xxx) を付けると全角にもマッチする" do
      it "10進数字[0-9] \\d "do
        expect("0189０１８９" =~ /(?u:\d)+/).to be_truthy
        expect($&).to eq "0189０１８９"
      end

      it "単語構成文字[a-zA-Z0-9_] \\w" do
        expect("AZazＡＢＣａｂｃＸＹＺｘｙｚ" =~ /(?u:\w)+/).to be_truthy
        expect($&).to eq "AZazＡＢＣａｂｃＸＹＺｘｙｚ"
      end

      it "空白文字[ \\t\\r\\n\\f\\v] \\s" do
        expect(" 　\t\n" =~ /(?u:\s)+/).to be_truthy
        expect($&).to eq " 　\t\n"
      end

      it "但し16進数字[0-9a-fA-F] \\h は全角にはマッチしない"do
        expect("09Af０９Ａｆ" =~ /\A(?u:\h)+\z/).to be_falsey
        expect($&).to be_nil
      end
    end
  end
end