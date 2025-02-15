#!/bin/bash

UA_STRING="Mozilla/5.0 (Macintosh; Intel Mac OS X 12_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Safari/605.1.15"
DL_URL=$(wget --header="Accept: text/html" --user-agent="$UA_STRING" -qO- https://support.wyze.com/hc/en-us/articles/360024852172-Release-Notes-Firmware | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*" | grep /v2/ |   sort -t . -k2r,5 | grep demo | head -1)

echo "create work directory"
mkdir v2_ro

echo "download latest firmware"
wget $DL_URL -P ./v2_ro/

echo "extracting firmware to workdir"
unzip v2_ro/demo_4.9.8.1002.zip -d ./v2_ro/

echo "create firmware dir"
mkdir v2_ro/tmp_dir

echo "unpack stock firmware"
./fw_tool.sh unpack v2_ro/demo_4.9.8.1002.bin v2_ro/tmp_dir

echo "replace kernel"
cp v2_kernel.bin v2_ro/tmp_dir/kernel.bin

echo "pack firmware with new kernel"
./fw_tool.sh pack v2_ro/tmp_dir/ demo.bin

echo "md5sum is:  " `md5sum demo.bin`
rm -rf v2_ro

echo "demo.bin ready.  Please copy demo.bin to your memory card"
