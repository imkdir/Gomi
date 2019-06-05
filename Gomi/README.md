#  Gomi - Waste Classification Tool

## Script to generate table.plist from txt file

```
cat table.txt | \
awk '{printf "<dict>\n\t<key>name</key>\n\t<string>%s</string>\n\t<key>groupId</key>\n\t<integer>%d</integer>\n</dict>\n", $1, $2}' > table_plist.txt
```
