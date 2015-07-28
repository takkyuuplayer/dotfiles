# Command Options
export GREP_OPTIONS="--exclude=\*.svn\* "
export FIND_OPTIONS="-I --color --exclude=\*.svn\* "
export EDITOR="vim"

if [ -d $LPM_LIB/slib ]; then
    export SCHEME_LIBRARY_PATH=$LPM_LIB/slib/
fi

# Color
echo -ne    '\e]10;#d0d0d0\a' # ForegroundColour
echo -ne    '\e]11;#1c1c1c\a' # BackgroundColour
echo -ne    '\e]12;#ffaf00\a' # CursorColour
echo -ne '\e]4;262;#80e0a0\a' # IMECursorColour
echo -ne   '\e]4;0;#0c0c0c\a' # Black
echo -ne   '\e]4;8;#0a0a0a\a' # BoldBlack
echo -ne   '\e]4;1;#d78787\a' # Red
echo -ne   '\e]4;9;#df8787\a' # BoldRed
echo -ne   '\e]4;2;#afd787\a' # Green
echo -ne  '\e]4;10;#afdf87\a' # BoldGreen
echo -ne   '\e]4;3;#f7f7af\a' # Yellow
echo -ne  '\e]4;11;#ffffaf\a' # BoldYellow
echo -ne   '\e]4;4;#87afd7\a' # Blue
echo -ne  '\e]4;12;#87afdf\a' # BoldBlue
echo -ne   '\e]4;5;#d7afd7\a' # Magenta
echo -ne  '\e]4;13;#dfafdf\a' # BoldMagenta
echo -ne   '\e]4;6;#afd7d7\a' # Cyan
echo -ne  '\e]4;14;#afdfdf\a' # BoldCyan
echo -ne   '\e]4;7;#e6e6e6\a' # White
echo -ne  '\e]4;15;#eeeeee\a' # BoldWhite

alias perltidy-all="git diff --name-status origin/master... | awk '{print \$2}' | grep -v 'perl5' | grep \"\\\\.pm\$\" | xargs perltidy -b;
git diff --name-status origin/master... | awk '{print \$2}' | grep \"\\\\.t\$\" | xargs perltidy -b;
find ./ -name '*.bak'  | xargs rm;
"
