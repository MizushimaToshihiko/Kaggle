# review

## 実験名
exp_YYYYMMDD_NNN_short_name

## 1. leakage check
- fold外で fit していないか:
- target encoding の作り方は妥当か:
- orig / test / pseudo label の混線はないか:
- 明確な leakage の疑い:
  - あり / なし
- コメント:

## 2. CV / LB gap
- CV は妥当か:
- LB は CV に対して不自然でないか:
- CV だけ高い「盛れた実験」に見えないか:
- コメント:

## 3. correlation check
- mainline との相関:
- 既存上位との rank_corr:
- ほぼ同系統の塊になっていないか:
- コメント:

## 4. stack role check
この実験の役割を1つに決める。

- 主力候補
- 補助候補
- 負補正候補
- 比較用
- 不要

選んだ役割:
- 

理由:
- 

## 5. adoption check
- 単体で採用価値があるか:
- Ridge で採用価値があるか:
- Hill Climb で採用価値があるか:
- 置換候補か:
- 追加候補か:
- 1回試して終わりでよいか:
- 継続探索価値があるか:

## 6. cost check
- 実行時間:
- GPU使用量:
- Colab compute units 消費:
- このコストに見合うか:
- コメント:

## 7. final judgment
- 採用 / 保留 / 不採用

## 8. one-line reason
1文で断定する。感想は禁止。

## 9. next action
1つだけ書く。
