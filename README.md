# Kaggle

## 最終提出ルール

1. Public最高単体は攻め枠として扱うが、Private耐性は必ず疑う
   - CVよりPublicが大きく跳ねている単体
   - late-stage共有コード由来の単体
   - bias / threshold / postprocess依存が強い単体
   は、Public fit候補として警戒する。

2. 最終2枠は「攻め枠」と「安定枠」に分ける
   - 攻め枠:
     Public最高、または最も上振れ期待がある候補
   - 安定枠:
     CV・Public・OOF構造・相関・blend変換率のバランスが最もよい候補

3. 安定枠は、LR / Ridge / ElasticNet / Avg / NM / HC を横並びで比較して決める
   - LR固定にしない
   - 多クラス分類でクラス境界・biasが効く場合はLRを重視
   - 二値分類や確率平均が安定する場合はRidge / ElasticNetを重視
   - HC / NM はCVだけでなくPublic変換と重みの自然さを確認する

4. late-stageで強い共有コードを見つけた場合、単体だけでなく必ずstack版も最終候補に入れる
   - 共有コード単体
   - 既存主力stackへ追加したLR/Ridge/ElasticNet等
   - 共有コードを含まない既存安定stack
   を比較する。
   共有コード単体だけを最終提出に選ばない。

5. Public最高単体と安定stackで迷ったら、2枠のうち少なくとも1枠は安定stackにする
   - 「Public最高単体を2本」や「同系統Public高値を2本」は避ける
   - 片方はPublicが多少低くても、構造的にPrivate耐性が高そうな候補を残す

6. 単体CV改善だけでは最終候補にしない
   - 最終候補化の条件は、単体CV/LBだけでなく、
     - 既存主力との相関
     - blend後CV
     - Public変換
     - 重みの自然さ
     - 既存候補との差別化
     を満たすこと。

7. 最終日前に「未選択候補のPrivate想定順位」をメモする
   - 選ばない理由を1行で残す
   - 理由を書けない候補は、実は最終候補として再検討する
