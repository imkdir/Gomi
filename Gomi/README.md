#  Gomi - Waste Classification Tool

## Script to generate table.plist from txt file

table.txt each line's format: `name groupId`.

```
cat table.txt | \
awk '{printf "<dict>\n\t<key>name</key>\n\t<string>%s</string>\n\t<key>group</key>\n\t<integer>%d</integer>\n</dict>\n", $1, $2}' > table_plist.txt
```

then copy paste table_plist.txt content to table.plist.
