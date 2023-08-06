#!/usr/bin/env sh

# SPDX-License-Identifier: BSD-2-Clause
# 
# Copyright (c) 2023 Vincent DEFERT. All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions 
# are met:
# 
# 1. Redistributions of source code must retain the above copyright 
# notice, this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright 
# notice, this list of conditions and the following disclaimer in the 
# documentation and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
# COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
# POSSIBILITY OF SUCH DAMAGE.

# Lists the most recent documents available from STC's web site.

# The result is formatted in a consistent way regardless of STC
# changing their mind about presentation from time to time.

# Removes dates for which there's no URL.
cleanDates() {
    local l
    local d=''
    
    while IFS="\n" read l; do
        if [ "$(echo "${l}" | cut -c1-4)" = 'http' ]; then
            if [ -n "${d}" ]; then
                echo "${d}"
                d=''
            fi
            
            echo "${l}"
        else
            d="${l}"
        fi
    done
}

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
    | sed 's/^\(http:.*\)\.JPG/\1.jpg/' \
    | sed 's/^\(http:.*\)\.PNG/\1.png/' \
    | sed 's/^\(http:.*\)\.PDF/\1.pdf/' \
    | sed 's/^\(http:.*\)\.ZIP/\1.zip/' \
    | sed 's/^\(http:.*\)\.RAR/\1.rar/' \
    | head -20 \
    | cleanDates
