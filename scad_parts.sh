#!/bin/bash

#set -x

IN="$1"
TMP="$1.temp.scad"

if [ ! -f "$IN" -o "${IN: -5}" != ".scad" ] ; then 
	echo "Usage: $0 <INPUT.scad>"
	exit 23
fi

#OUT=$(dirname "$IN")/out
OUT="${IN%.scad}"
MD="$OUT/README.md"
rm "$MD"
mkdir -p "$OUT"

git add "$IN"
git commit -m "$0 $1 auto-commit" "$IN"

echo "\n**$CMD**\n\n![all.png](all.png)\n\n    use <$IN>\n    $CMD\n\n" >> "$MD"

cat "$IN" | while read L ; do 
	if echo "$L" | grep -q "^\s*PART" ; then
		CMD=$(echo "$L" | cut -f2- -d')' | sed -e 's/\s*//' )
		NAME=$(echo "$CMD" | sed -e 's/\(\[[0-9x ]*\),/\1x/g' | sed -e 's/\(\[[0-9x ]*\),/\1x/g' | sed -e 's/\(\[[0-9x ]*\),/\1x/g' | tr -d ' []);' | tr -c '[:alnum:]\n' '_' | sed -e 's/_*$//')
	
	        echo "exporting $OUT/$NAME"
	        echo -e "use <$IN>\n$CMD\n" > "$TMP"
		echo -e "\n**$CMD**\n\n![$NAME.png]($NAME.png)\n\n    use <$IN>\n    $CMD\n\n" >> "$MD"
		###echo -e "[$NAME.3mf]($NAME.3mf)" >> "$MD"
	        echo -e "[$NAME.stl]($NAME.stl)\n\n" >> "$MD"
	        openscad -o "$OUT/$NAME.png" --viewall --autocenter --imgsize 256,256 "$TMP"
	        openscad -D GUI=0 -o "$OUT/$NAME.stl" "$TMP"
	       	###openscad -D GUI=0 -o "$OUT/$NAME.3mf" "$TMP"
		git add "$OUT/$NAME.png" "$OUT/$NAME.stl" ### "$OUT/$NAME.3mf"
	elif echo "$L" | grep -q "///" ; then
		echo "${L#*///}" >> "$MD"
	fi

done
openscad -o "$OUT/all.png" --viewall --autocenter --imgsize 512,512 "$IN"


git add "$MD"
git commit -m "$0 $1" "$OUT/"
#git commit -m "$0 $1" "$MD"

rm "$TMP"




