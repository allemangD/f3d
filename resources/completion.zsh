#compdef f3d

local commandlist
local longopts
local shortopts
local arguments

# commandlist operations:
# Discard:
#   - Header.
#   - Keys/examples sections.
#   - Section headers.
#   - Illegal characters [].
#   - Leading whitespace.
# Join multiline helptext. See https://stackoverflow.com/a/37951863/4672189 for details.
# Normalize whitespace.
# Discard trailing whitespace.
commandlist=$(
  f3d --help 2>&1 |
    tail -n +5 |
    sed '1,/Keys:/!d' | sed '/.*:$/d' | sed 's/\[.*\] *//g' | sed 's/^\s*//' |
    sed -e ':a' -e 'N' -e '/\n-[a-z\-]/!s/\n/ /' -e 'ta' -e 'P' -e 'D' | 
    sed 's/\s\{1,\}/ /g; s/\s*$//'                                                       
)

shortopts=$(echo $commandlist | sed -n 's/^\(-[a-z]\), --[^ ]* \(.*\)/\1[\2]/p')
longopts=$(echo $commandlist | sed -n 's/-., //; s/\(--[^ ]*\) *\(.*\)/\1[\2]/p')

arguments=("${(f)shortopts}")
arguments+=("${(f)longopts}")

_arguments "${arguments[@]}" "*:file:_files"
