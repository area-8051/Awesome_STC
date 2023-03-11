#!/usr/bin/env sh

# Lists the most recent documents available from STC's web site.

# The result is formatted in a consistent way regardless of STC
# changing their mind about presentation from time to time.

wget -q -O - http://www.stcmcudata.com/website-update.txt \
    | iconv -f GB18030 -t UTF-8 \
    | grep -e "^网站更新 " -e " 更新第.次" -e "http://" -e "^www.stcmcudata.com" \
    | sed 's/^网站更新 *\(.*\)/\1/' \
    | sed 's/^\(www.stcmcudata.com\/.*\)/http:\/\/\1/' \
    | sed 's/^.*\(http:.*\)/\1/' \
    | sed 's/^\(20[^[:space:]]*\).*/\1/' \
    | sed 's/^\(http:.*\)[，,].*/\1/' \
    | sed 's/^\(http:[^[:space:]]*\).*/\1/' \
    | sed 's/^\(20.*[.-]\)\([[:digit:]]\)$/\10\2/' \
    | sed 's/^\(20[[:digit:]]*[.-]\)\([[:digit:]][.-].*\)/\10\2/' \
    | sed 's/^\(20[[:digit:]]*\)[.-]\([[:digit:]]*\)[.-]\([[:digit:]]*\).*/\1\2\3/' \
    | sed 's/^\(20[[:digit:]][[:digit:]]\)\([[:digit:]][[:digit:]]\)\([[:digit:]][[:digit:]]\)/\1-\2-\3/' \
    | sed 's/^\(http:.*\)\.PNG/\1.png/' \
    | sed 's/^\(http:.*\)\.PDF/\1.pdf/' \
    | sed 's/^\(http:.*\)\.ZIP/\1.zip/' \
    | sed 's/^\(http:.*\)\.RAR/\1.rar/' \
    | head -20
