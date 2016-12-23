require "minruby"

def sum(tree)
  if tree[0] == "lit"
    # 葉leafの場合は値を返すだけ
    tree[1]
  else
    # 節treeの場合は左右それぞれで再帰呼び出し
    l = sum(tree[1])
    r = sum(tree[2])
    l + r
  end
end


tree = minruby_parse("(1 + 2) + (3 + 4)")
p tree

answer = sum(tree)
p(answer) #=> 10