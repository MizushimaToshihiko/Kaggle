# requirements

## business goal
- Public / Private を上げることではなく、最終2提出の質を上げる

## experiment goal
- 何を検証する実験か

## success criteria
- 単体CV改善
- Ridge / HC 改善
- 相関が mainline より十分に下がる
- 実行時間が許容範囲内

## failure criteria
- 単体微差のみ
- ブレンド改善に変換されない
- mainline とほぼ同相関
- GPUコスト過大

## constraints
- Kaggle GPU 制限
- Colab Compute Units
- 提出枠は2本
- 既存 mainline を壊さない
