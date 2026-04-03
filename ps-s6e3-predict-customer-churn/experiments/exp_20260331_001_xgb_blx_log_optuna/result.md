# 実験名
exp_20260331_001_xgb_blx_log_optuna

## 実験目的
XGB blx LOG Optuna が単体微改善にとどまらず、
Ridge / Hill Climb の改善に変換されるか確認する。

## 実験区分
- stable / aggressive
- human / ai-assisted

## baseline
- exp_20260329_004_xgb_blx_log_base

## 変更点
- Optuna best params に差し替え
- FE は据え置き

## 実行環境
- platform:
- gpu:
- runtime:
- commit_hash:

## 単体結果
- CV:
- LB:
- fold:
- seed:

## 相関
| compare_to | pearson | rank_corr |
|---|---:|---:|
| main_xgb_raw_lrpred |  |  |
| ridge_v27_stack |  |  |

## ブレンド結果
- Ridge CV:
- Ridge LB:
- HC CV:
- HC LB:

## 判定
- 採用 / 保留 / 不採用

## 判定理由
- 単体改善:
- ブレンド改善:
- 相関価値:
- 置換 / 追加:

## 学んだこと
- 1行だけ

## 次アクション
- 次にやることを1つだけ
