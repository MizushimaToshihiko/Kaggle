# REVIEW_CHECKLIST

提出前に必ず確認すること。

## 1. leakage
- 前処理 fit を fold 外でしていないか
- target encoding を train 全体で作っていないか
- pseudo label が混ざっていないか

## 2. CV / LB
- CV だけが高すぎないか
- LB が mainline より悪いのに採用しようとしていないか

## 3. 相関
- 既存主力と rank corr が高すぎないか
- 高相関でも補正素材として機能したか

## 4. stack での役割
- 主力か
- 補助か
- 負補正か
- そもそも不要か

## 5. cost
- 実行時間に見合う価値があるか
- GPU を食うだけのノイズではないか

## 6. final
- 置換候補か追加候補か
- 1回だけ試す価値なのか、継続探索価値があるのか
