require 'rspec'
require 'cgi/util'
include CGI::Util

describe "HTMLエスケープ" do

  it "#escape_html" do
    html = %|<script>alert('danger!')</script><a src="http://danger.com/test?a=1&b=2">Danger!</a>|
    str = escape_html(html)
    expect(str).to eq '&lt;script&gt;alert(&#39;danger!&#39;)&lt;/script&gt;&lt;a src=&quot;http://danger.com/test?a=1&amp;b=2&quot;&gt;Danger!&lt;/a&gt;'

    # h メソッドも同じ
    str2 = h html
    expect(str2).to eq str
  end

end