#!/bin/bash

# ファイルが指定されているか確認
if [ "$#" -lt 1 ]; then
  echo "使用方法: $0 <ファイル1> <ファイル2> ... <ファイルN>"
  exit 1
fi

# 各ファイルに対して処理を行う
for FILE in "$@"; do
  # ファイルが存在するか確認
  if [ ! -f "$FILE" ]; then
    echo "ファイルが見つかりません: $FILE"
    continue
  fi

  # ファイルサイズを取得
  FILESIZE=$(stat -f%z "$FILE")

  # ディレクトリパスとファイル名を分割
  DIR=$(dirname "$FILE")
  BASENAME=$(basename "$FILE")
  BASENAME_NO_EXT="${BASENAME%.*}"

  # 1MB = 1048576バイト
  if [ $FILESIZE -gt 1048576 ]; then
    echo "ファイルサイズが1MBを超えています。圧縮を開始します: $FILE"
    
    # 画像をJPEG形式に変換して500KB以下にする
    sips -s format jpeg -s formatOptions 50 "$FILE" --out "$DIR/compressed_${BASENAME_NO_EXT}.jpg"
    
    # 圧縮後のファイルサイズを取得
    COMPRESSED_FILESIZE=$(stat -f%z "$DIR/compressed_${BASENAME_NO_EXT}.jpg")
    
    if [ $COMPRESSED_FILESIZE -gt 512000 ]; then
      echo "圧縮後のファイルサイズが500KBを超えています。さらに圧縮します: $FILE"
      sips -s format jpeg -s formatOptions 30 "$DIR/compressed_${BASENAME_NO_EXT}.jpg" --out "$DIR/compressed_${BASENAME_NO_EXT}.jpg"
    fi
    
    echo "圧縮が完了しました。新しいファイル名は $DIR/compressed_${BASENAME_NO_EXT}.jpg です。"
  else
    echo "ファイルサイズは1MB以下です。圧縮は不要です: $FILE"
  fi
done