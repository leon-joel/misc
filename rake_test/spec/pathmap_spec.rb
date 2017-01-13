require 'rspec'

require 'rake'

describe 'string pathmap from rake' do

  describe 'simple parameter behavior' do
    it 'for windows パス' do
      # puts "日本語が文字化けしないことを確認"

      # フルパス系
      expect("c:\\dir1\\日本語\\test.txt".pathmap("%p")).to eq "c:\\dir1\\日本語\\test.txt"
      expect("c:\\dir1\\日本語\\test.txt".pathmap("%X")).to eq "c:\\dir1\\日本語\\test"

      # ディレクトリを取得
      expect("c:\\dir1\\日本語\\test.txt".pathmap("%d")).to eq "c:\\dir1\\日本語"

      # ROOTから指定数の階層分だけ取得
      expect("c:\\dir1\\日本語\\test.txt".pathmap("%2d")).to eq "c:\\dir1"
      expect("c:\\dir1\\日本語\\test.txt".pathmap("%1d")).to eq "c:\\"

      # 末端ディレクトリから取得
      expect("c:\\dir1\\日本語\\test.txt".pathmap("%-3d")).to eq "c:\\dir1/日本語" # ★★★セパレーターが混在してる！！！！
      expect("c:\\dir1\\日本語\\test.txt".pathmap("%-2d")).to eq "dir1/日本語"     # ★★★セパレーターが / に変換される！！！
      expect("c:\\dir1\\日本語\\test.txt".pathmap("%-1d")).to eq "日本語"

      # ファイル名・拡張子
      expect("c:\\dir1\\日本語\\test.txt".pathmap("%f")).to eq "test.txt"
      expect("c:\\dir1\\日本語\\test.txt".pathmap("%n")).to eq "test"
      expect("c:\\dir1\\日本語\\test.txt".pathmap("%x")).to eq ".txt"

      # 定義されていれば、代替のファイルセパレータを表します。 定義されてい無い場合は、標準のファイルセパレータを表します。
      expect("c:\\dir1\\日本語\\test.txt".pathmap("%s")).to eq "\\"
      expect("/home/dir1/日本語/test.txt".pathmap("%s")).to eq "\\"
    end

    it "for unix パス" do
      # フルパス系
      expect("/home/dir1/日本語/test.txt".pathmap("%p")).to eq "/home/dir1/日本語/test.txt"
      expect("/home/dir1/日本語/test.txt".pathmap("%X")).to eq "/home/dir1/日本語/test"

      # ディレクトリを取得
      expect("/home/dir1/日本語/test.txt".pathmap("%d")).to eq "/home/dir1/日本語"

      # ROOTから指定数の階層分だけ取得
      expect("/home/dir1/日本語/test.txt".pathmap("%4d")).to eq "/home/dir1/日本語"
      expect("/home/dir1/日本語/test.txt".pathmap("%3d")).to eq "/home/dir1"
      expect("/home/dir1/日本語/test.txt".pathmap("%2d")).to eq "/home"
      expect("/home/dir1/日本語/test.txt".pathmap("%1d")).to eq "/"

      # 末端ディレクトリから取得
      expect("/home/dir1/日本語/test.txt".pathmap("%-3d")).to eq "home/dir1/日本語"
      expect("/home/dir1/日本語/test.txt".pathmap("%-2d")).to eq "dir1/日本語"
      expect("/home/dir1/日本語/test.txt".pathmap("%-1d")).to eq "日本語"

      # ファイル名・拡張子
      expect("/home/dir1/日本語/test.txt".pathmap("%f")).to eq "test.txt"
      expect("/home/dir1/日本語/test.txt".pathmap("%n")).to eq "test"
      expect("/home/dir1/日本語/test.txt".pathmap("%x")).to eq ".txt"
    end
  end

end