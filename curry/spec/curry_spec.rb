require 'rspec'
require_relative '../prop_flip'

describe 'My behaviour' do

# 2引数を取る関数を準備する ※lambdaじゃなくても出来るけどまずlambdaで
#   func = -> x, y { x + y }
#   p func
# # 呼び出し方3種類
#   puts func.(2,3)
#   puts func.call(2,3)
#   puts func[2, 3]
#
# # カリー化する
#   curried = func.curry
#   p curried   # -> Proc
#
# # 部分適用する （＝オリジナルの第1引数に2を入れた関数を生成）
#   c2 = curried.call(2)
#   p c2        # -> Proc
#
# # 結果を出す（＝オリジナルの第2引数に3を入れて結果を受け取る）
#   p c2.call(3)

  describe "curried 2 args" do
    let(:func) { -> x, y { x + y } }
    let(:curried) { func.curry }    # 【カリー化】

    it 'should do something' do
      p func    # -> #<Proc:0x3c80fd0@xxx.rb:24 (lambda)>
      expect(func).to be_a(Proc)

      p curried # -> #<Proc:0x3c16158 (lambda)>
      expect(curried).to be_a(Proc)

      # 第1引数に1を与えた Proc を作る 【部分適用】
      c1 = curried.call(1)  # -> #<Proc:0x364d8f8 (lambda)>
      expect(c1).to be_a(Proc)

      # 上記Procに引数2（つまりオリジナルの第2引数に2）を与えて実行する
      result = c1.call(2)
      expect(result).to eq 3
    end
  end

  describe "curried 3 args" do

    def func3(x, y, z)
      x * y * z
    end
    let(:func) { method(:func3) }   # curry化できるようにProc化する ☆ruby2.2以降、Methodもcurry化できるようになったのでこれでOK
    let(:curried) { func.curry }    # 【カリー化】

    it do
      p func    # -> #<Method: RSpec::ExampleGroups::MyBehaviour::Curried3Args#func3>
      expect(func).to be_a(Method)

      p curried
      expect(curried).to be_a(Proc)

      c1 = curried.call(1)  # 【部分適用】
      c2 = c1.call(2)       # 【部分適用】
      result = c2.call(3)

      expect(result).to eq 6

    end
  end

  describe "flip args" do
    let(:func) { -> x, y { x - y } }
    # let(:func) { lambda{ |x, y| x - y } }

    def subst(x, y)
      x - y
    end

    let(:meth) { method(:subst) }

    it "flip func" do
      p func.methods            # -> [:..... , :flip, .....]
      p func.class.ancestors    # -> [Proc, FlipFunction, Object, Kernel, BasicObject]

      flip_curried = func.flip.curry

      # 第2引数を1に固定
      c1 = flip_curried.call(1)
      expect(c1.call(3)).to eq 2

      # ちなみにflipしない場合は 1 - 3 = -2
      expect(func.curry.call(1).call(3)).to eq -2
    end

    it "flip method" do
      p meth
      p meth.methods            # -> [:..... , :flip, .....]
      p meth.class.ancestors    # -> [Method, FlipFunction, Object, Kernel, BasicObject]

      # flipすると 3 - 1 = 2
      expect(meth.flip.curry.call(1).call(3)).to eq 2

      # flipしないと 1 - 3 = -2
      expect(meth.curry.call(1).call(3)).to eq -2
    end

    it "flip symbol" do
      p self                    # -> #<RSpec::ExampleGroups::MyBehaviour::FlipArgs "flip symbol" (./spec/curry_spec.rb:106)>
      p self.methods            # -> [:meth, :func, :subst, :inspect, :described_class, :expect, :be_truthy, :a_truthy_value, :be_falsey, :be_falsy, :a_falsey_value, :a_falsy_value, :be_nil, :a_nil_value, :be, :equal, :a_value, :be_a_kind_of, :be_an, :be_an_instance_of, :match, :be_instance_of, :be_kind_of, :be_between, :a_value_between, :be_within, :be_a, :a_value_within, :within, :change, :a_block_changing, :changing, :contain_exactly, :a_collection_containing_exactly, :containing_exactly, :cover, :a_range_covering, :covering, :end_with, :raise_error, :a_collection_ending_with, :a_string_ending_with, :ending_with, :an_object_eq_to, :eq_to, :eql, :an_object_eql_to, :eql_to, :an_object_equal_to, :equal_to, :exist, :an_object_existing, :existing, :have_attributes, :an_object_having_attributes, :a_collection_including, :a_string_including, :a_hash_including, :including, :match_regex, :an_object_matching, :a_string_matching, :matching, :match_array, :a_block_outputting, :a_block_raising, :raising, :respond_to, :an_object_responding_to, :responding_to, :satisfy, :an_object_satisfying, :satisfying, :start_with, :a_collection_starting_with, :a_string_starting_with, :starting_with, :throw_symbol, :a_block_throwing, :throwing, :yield_control, :aggregate_failures, :a_block_yielding_control, :yielding_control, :yield_with_no_args, :a_block_yielding_with_no_args, :all, :yielding_with_no_args, :yield_with_args, :a_block_yielding_with_args, :yielding_with_args, :yield_successive_args, :a_block_yielding_successive_args, :yielding_successive_args, :eq, :output, :raise_exception, :include, :an_instance_of, :a_kind_of, :setup_mocks_for_rspec, :teardown_mocks_for_rspec, :verify_mocks_for_rspec, :double, :instance_double, :class_double, :object_double, :spy, :instance_spy, :object_spy, :class_spy, :allow_message_expectations_on_nil, :stub_const, :hide_const, :have_received, :allow, :allow_any_instance_of, :expect_any_instance_of, :receive, :receive_messages, :receive_message_chain, :any_args, :anything, :no_args, :duck_type, :boolean, :hash_including, :array_including, :hash_excluding, :hash_not_including, :instance_of, :kind_of, :skip, :pending, :subject, :should, :should_not, :is_expected, :instance_of?, :public_send, :instance_variable_get, :instance_variable_set, :instance_variable_defined?, :remove_instance_variable, :private_methods, :kind_of?, :instance_variables, :tap, :is_a?, :extend, :to_enum, :enum_for, :<=>, :===, :=~, :!~, :eql?, :respond_to?, :freeze, :display, :object_id, :send, :to_s, :method, :public_method, :singleton_method, :define_singleton_method, :nil?, :hash, :class, :singleton_class, :clone, :dup, :itself, :taint, :tainted?, :untaint, :untrust, :trust, :untrusted?, :methods, :protected_methods, :frozen?, :public_methods, :singleton_methods, :!, :==, :!=, :__send__, :equal?, :instance_eval, :instance_exec, :__id__, :stub, :as_null_object, :null_object?, :received_message?, :should_receive, :should_not_receive, :unstub, :stub_chain]
      p self.class.ancestors    # -> [RSpec::ExampleGroups::MyBehaviour::FlipArgs, RSpec::ExampleGroups::MyBehaviour::FlipArgs::LetDefinitions, RSpec::ExampleGroups::MyBehaviour::FlipArgs::NamedSubjectPreventSuper, RSpec::ExampleGroups::MyBehaviour, RSpec::ExampleGroups::MyBehaviour::LetDefinitions, RSpec::ExampleGroups::MyBehaviour::NamedSubjectPreventSuper, RSpec::Core::ExampleGroup, RSpec::Matchers, RSpec::Core::MockingAdapters::RSpec, RSpec::Mocks::ExampleMethods::ExpectHost, RSpec::Mocks::ExampleMethods, RSpec::Mocks::ArgumentMatchers, RSpec::Core::Pending, RSpec::Core::MemoizedHelpers, Object, Kernel, BasicObject]

      proc_subst = :subst.to_proc.curry
      p proc_subst              # -> #<Proc:0x3c8c280(&:subst)>

      # 理由は分からないが curry化したsubstメソッドに対しての部分適用ができない
      # proc_subst.call(self)     # ArgumentError: wrong number of arguments (given 0, expected 2)

      # 全部の引数を与えて呼び出すことは可能だが…
      expect(proc_subst.call(self, 3, 1)).to eq 2


      # -演算子も部分適用できない
      c = :-.to_proc.curry    # 1引数メソッドなのでcurry化してもどうしようもないが…
      p c
      result = c.call(3, 1)   # 第1引数receiver, 第2引数引く数
      expect(result).to eq 2

    end
  end
end

