# frozen_string_literal: true

module BCDice
  module GameSystem
    class Oukahoushin3rd < Base
      # ゲームシステムの識別子
      ID = 'Oukahoushin3rd'

      # ゲームシステム名
      NAME = '央華封神RPG 第三版'

      # ゲームシステム名の読みがな
      SORT_KEY = 'おうかほうしんRPG3'

      # ダイスボットの使い方
      HELP_MESSAGE = <<~INFO_MESSAGE_TEXT
        ・各種表
        　・能力値判定裏成功表（NHT）
        　・武器攻撃裏成功表（BKT）
        　・受け・回避裏成功表（UKT）
        　・仙術行使裏成功表（SKT）
        　・仙術抵抗裏成功表（STT）
        　・精神値ダメージ悪影響表（SDT）
        　・狂気表（KKT）
      INFO_MESSAGE_TEXT

      def rollDiceCommand(command)
        chosen = roll_tables(command, TABLES)
        return replace_dice_notation(chosen)
      end

      private

      def replace_dice_notation(text)
        text&.gsub(/(\d+)D(\d+)/) do |matched|
          times, sides = matched.split("D").map(&:to_i)
          value = @randomizer.roll_sum(times, sides)
          "#{matched}(=>#{value})"
        end
      end

      TABLES = {
        "BKT" => DiceTable::Table.new(
          "武器攻撃裏成功表",
          "2D6",
          [
            "1ポイント清徳値が低下。連続攻撃が行える。この場合の連続攻撃においては、命中判定のサイコロは常にひっくり返して用いるが、2撃目以降はこの表は使わない。",
            "敵に叩きつけると同時に武器が破損。素手や身体に備わった武器（爪、牙など）で攻撃をしていた場合には、自身にも1D6（のみ）ダメージ。",
            "効果的命中。ダメージに1D6加算。ただし極度に疲労するため、精神値に1D6点ダメージを受ける。（2ゾロ）1ポイント仙骨が上昇、体力または機敏（攻撃を行った者が選択する）が1ポイント低下。",
            "ふつうの命中。",
            "不完全な命中、ダメージは半分。（3ゾロ）1ポイント仙骨が低下。",
            "ふつうの命中。",
            "体力または機敏（攻撃を行った者が選択する）が1D6日間、1ポイント上昇。（4ゾロ）能力値の上昇は永遠。",
            "ふつうの命中。",
            "体力または機敏（攻撃を行った者が選択する）が1D6日間、1ポイント低下。（5ゾロ）能力値の低下は永遠。",
            "呼吸を乱す、数瞬間（1D6ラウンド）は仙術を使用できない。",
            "1ポイント清徳値が低下。体力または機敏（攻撃を行った者が選択する）が1ポイント上昇。"
          ]
        ),
        "KKT" => DiceTable::Table.new(
          "狂気表",
          "2D6",
          [
            "心神喪失、生ける屍。",
            "被害妄想。仲間も含め、他者は全て自分を傷つけようとしていると思いこむ。行動はゲームマスターが管理。",
            "重度の不安症。失敗を恐れるあまり、次ラウンドは行動不可。それ以降も、2ラウンドに1回しか行動できない（自動武器や使役獣への命令なども）。\\n「次のラウンドに行動できない」状態では、「割り込み」は行えない。",
            "重度の依存症。自分で行動を決められず、仲間に決めてもらわなければならない。",
            "二重人格。二つ目の人格は狂気。新たに狂気表（KKT）で決定（再度二重人格が出た場合は、振りなおす）。狂気表を使った直後は、この二つ目の人格。\\n1日以上、二重人格が持続している場合、その間に精神値ダメージを受けるたびに、その直後に1Dを振らねばならない。1が出たらこの狂気が顔を出す。\\n二つ目の人格が顔を出している時間は、1Dで決定する（1～3：短時間、4～5：半日、6：1日）。",
            "軽度の依存症。仲間の承認がなければ、思いついた行動を実行できない。",
            "軽度の偏執狂。ある行為や物品などに異常な執着を示す。ただし、行動に大きな影響は与えない。具体的な内容は、ゲームマスターとプレイヤーの相談で決定。",
            "重度の偏執狂。行動に重大な影響を与える。具体的内容は、ゲームマスターが決定。",
            "恐怖症。あるものに対して恐怖。対象からは、ひたすら逃亡しようとする。また、対象に遭遇するたびに、難易度10で意志の能力値判定を行わねばならず、失敗したら1Dの精神値ダメージを受ける。恐怖の対象は、ゲームマスターが決定。",
            "狂暴化。仲間も含め、他者はすべて敵とみなし、傷つけようとする。行動はゲームマスターが管理。",
            "錯乱。行動はゲームマスターが「なるべくでたらめになるように」決定する。"
          ]
        ),
        "NHT" => DiceTable::Table.new(
          "能力値判定裏成功表",
          "2D6",
          [
            "1ポイント清徳値が低下。変な癖が身についてしまう。",
            "やりすぎ。過剰な成功をしたり、よけいなことまでして災いが起こりうる。",
            "「気」の爆発。大成功。ただし極度に疲労するため、精神値に1D6点ダメージを受ける。（2ゾロ）1ポイント仙骨が上昇、使用した能力値が1ポイント低下。",
            "ふつうの成功。",
            "不完全な成功、数値的効果は半分ほどに見積もる。（3ゾロ）1ポイント仙骨が低下。",
            "ふつうの成功。",
            "使用した能力値が1D6日間、1ポイント上昇。（4ゾロ）能力値の上昇は永遠。",
            "ふつうの成功。",
            "使用した能力値が1D6日間、1ポイント低下。（5ゾロ）能力値の低下は永遠。",
            "呼吸を乱す、数瞬間（1D6ラウンド）は仙術を使用できない。",
            "1ポイント清徳値が低下。使用した能力値が1ポイント上昇。"
          ]
        ),
        "SDT" => DiceTable::Table.new(
          "精神値ダメージ悪影響表",
          "1D6",
          [
            "一瞬の放心。直後の判定は自動的に失敗。精神値を1D6×最大値の10％回復。",
            "一瞬の放心。直後の判定は自動的に失敗。精神値を1D6×最大値の10％回復。",
            "一瞬の放心。直後の判定は自動的に失敗。精神値を1D6×最大値の10％回復。",
            "放心状態。強制され、自動失敗するまで、自発的行動不可。精神値を（1D6+2）×最大値の10％回復。",
            "精神異常（具体的内容は狂気表（KKT）で決定）。短時間のみ。精神値を（1D6+4）×最大値の10％回復。",
            "精神異常（具体的内容は狂気表（KKT）で決定）。期間は1D6を振って決定（1～3：1日、4～5：99日間、6：永遠）。精神値を最大値まで回復。"
          ]
        ),
        "SKT" => DiceTable::Table.new(
          "仙術行使裏成功表",
          "2D6",
          [
            "1ポイント清徳値が低下。1ポイント仙骨が上昇。",
            "術の効果は術者にも解除不能になる。精神値に1点ダメージを受ける。",
            "「気」の暴走。効果3倍。ただし極度に疲労するため、精神値に1D6点ダメージを受ける。（2ゾロ）術者は1D6日間、仙術が使用不能になる。1ポイント仙骨が上昇。",
            "術が敵にかけたものの場合、仲間の1人を巻きこむ。精神値に1点ダメージを受ける。",
            "不完全な成功、効果半分。（3ゾロ）持続時間のある術の場合、術者がひたすら精神集中していない限り、術はすぐに解除される。",
            "ふつうの成功。",
            "1ポイント清徳値が低下。（4ゾロ）仙骨以外のいずれかの能力値（術者選択）が1D6日間、1ポイント上昇。",
            "術が味方もしくは自分にかけたものの場合、敵の1人にも同じようにかかる。精神値に1点ダメージを受ける。",
            "仙骨以外のいずれかの能力値（術者選択）が1D6日間、1ポイント低下。（5ゾロ）能力値の低下は永遠。",
            "1D3ポイント清徳値が低下。",
            "1D6ポイント清徳値が低下。仙骨以外のいずれかの能力値（術者選択）が1ポイント上昇。"
          ]
        ),
        "STT" => DiceTable::Table.new(
          "仙術抵抗裏成功表",
          "2D6",
          [
            "1ポイント清徳値が低下。",
            "そらされた術の効果が味方に及ぶ。味方の誰にそらされたかは、この表を使ったものが選ぶ。集団攻撃仙術の場合、抵抗に成功したものの中から選ぶこと。ほかの誰も成功に抵抗していなかったときは、ふつうの抵抗成功として扱う。精神値に1点ダメージを受ける。",
            "仙術をかけた敵にその効果が及ぼされる。敵自身はそれに対して、抵抗を試みることができる。（2ゾロ）1ポイント仙骨が上昇。1ポイント知覚が低下。",
            "ふつうの抵抗成功。",
            "不完全な抵抗、ふつうの半分の効果を受ける。（3ゾロ）1ポイント仙骨が低下。",
            "ふつうの抵抗成功。",
            "仙骨または知覚（仙術に抵抗した者が選択する）が1D6日間、1ポイント上昇。（4ゾロ）能力値の上昇は永遠。",
            "ふつうの抵抗成功。",
            "仙骨または知覚（仙術に抵抗した者が選択する）が1D6日間、1ポイント低下。（5ゾロ）能力値の低下は永遠。",
            "呼吸を乱す、数瞬間（1D6ラウンド）は仙術を使用できない。",
            "1ポイント清徳値が低下。仙骨または知覚（仙術に抵抗した者が選択する）が1ポイント上昇。"
          ]
        ),
        "UKT" => DiceTable::Table.new(
          "受け・回避裏成功表",
          "2D6",
          [
            "1ポイント清徳値が低下。",
            "転倒する（空を飛んでいるものは落下。乗騎などに乗っていたら転落）。精神値に1点ダメージを受ける。",
            "相手のバランスを崩すのに成功。攻撃を行った敵が転倒（空を飛んでいるものは落下。乗騎などに乗っていたら転落）。（2ゾロ）1ポイント仙骨が上昇、機敏または知覚（攻撃を防御した者が選択する）が1ポイント低下。",
            "ふつうの防御成功。",
            "不完全な防御、通常の半分のダメージを受ける。しかし敵が連続攻撃を行うことは出来ない。攻撃者が裏成功攻撃であってもその反動は決めない。（3ゾロ）1ポイント仙骨が低下。",
            "ふつうの防御成功。",
            "機敏または知覚（攻撃を防御した者が選択する）が1D6日間、1ポイント上昇。（4ゾロ）能力値の上昇は永遠。",
            "ふつうの防御成功。",
            "機敏または知覚（攻撃を防御した者が選択する）が1D6日間、1ポイント低下。（5ゾロ）能力値の低下は永遠。",
            "呼吸を乱す、数瞬間（1D6ラウンド）は仙術を使用できない。",
            "1ポイント清徳値が低下。機敏または知覚（攻撃を防御した者が選択する）が1ポイント上昇。"
          ]
        ),
      }.freeze

      register_prefix(TABLES.keys)
    end
  end
end
