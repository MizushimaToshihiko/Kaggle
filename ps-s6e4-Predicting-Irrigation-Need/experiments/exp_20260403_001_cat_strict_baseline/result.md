# 実験名
exp_YYYYMMDD_NNN_short_name

## タイトル
Short experiment title

## 目的
この実験で何を検証したいのかを1〜3行で書く。  
単体CV改善を見たいのか、Ridge / Hill Climb への変換価値を見たいのか、相関を崩したいのかを明記する。

## 実験区分
- single / blend / stack / ablation / sanity-check
- human / ai-assisted

## baseline
- 比較対象の実験名:
- 比較対象の要点:
- 置換候補 / 追加候補:

## 仮説
- なぜ効くと思ったか:
- 既存主力と何が違う想定か:
- 期待する役割: 主力 / 補助 / 負補正 / ただの比較用

## 変更点
1.
2.
3.

## 実行環境
- platform:
- notebook:
- gpu / cpu:
- gpu_type:
- runtime:
- commit_hash:

## 入力データ
- train:
- test:
- orig:
- npy:
- sample_submission:

## 出力ファイル
- oof:
- pred:
- submission:
- corr:
- log:

## 単体結果
- CV:
- LB:
- fold:
- inner_fold:
- seed:
- 実行時間:

## 既存候補との比較
| compare_to | pearson | rank_corr | comment |
|---|---:|---:|---|
| mainline_1 |  |  |  |
| mainline_2 |  |  |  |
| current_best_single |  |  |  |

## ブレンド投入結果
### Ridge
- 投入先:
- Ridge CV:
- Ridge LB:
- 係数:
- 置換 / 追加:
- コメント:

### Hill Climb
- 投入先:
- HC CV:
- HC LB:
- 重み:
- 置換 / 追加:
- コメント:

## 判定
- 採用 / 保留 / 不採用

## 判定理由
### 単体
- 単体で価値があったか:

### 相関
- mainline に対して十分に別人格か:
- 高相関でも補正素材として価値があったか:

### ブレンド
- 単体改善が Ridge / HC 改善に変換されたか:
- 置換の方がよいか、追加の方がよいか:

### コスト
- 実行時間に見合ったか:
- GPU/Colabコストに見合ったか:

## 一言で結論
ここは1文で断定する。  
例:
- 単体微改善だがスタック改善に変換されず不採用。
- 単体は弱いが負補正素材として有効。
- 単体もブレンドも改善したため採用。

## 次アクション
次にやることを1つだけ書く。  
複数書くと、結局何も決まっていないのと同じになる。
