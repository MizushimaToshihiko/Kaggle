# design

## experiment
- exp_20260331_001_xgb_blx_log_optuna

## baseline
- xgb_blx_log_base

## stable plan
- 既存コードに最小変更
- params のみ差し替え
- outer20 / inner5 / seed42 維持

## aggressive plan
- FE 追加または表現変更
- ただし相関低下を狙う
- ブレンド投入前提

## expected impact
- stable: CV微差改善
- aggressive: 相関差による補助素材化

## risk
- 単体改善しても stack に効かない
- 実行時間だけ増える
