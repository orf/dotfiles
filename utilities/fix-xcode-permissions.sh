#!/bin/zsh
# shellcheck disable=SC2002
set -e

pycharm_bundle_id="com.jetbrains.pycharm"

LS_REGISTER=$(locate lsregister)

uti_list=$(mktemp)
type_id_dir=$(mktemp -d)
match_dir=$(mktemp -d)

echo "Dumping uti list"
"$LS_REGISTER" -dump  >"$uti_list"

echo "Segmenting ${uti_list}"
pushd "$type_id_dir"
cat "$uti_list" | awk '{f="file" NR; print $0> f}' RS='--------------------------------------------------------------------------------'
popd

echo "Grepping $type_id_dir"
rg -l "^uti:" --no-multiline "$type_id_dir" > "$match_dir/type_id_files"
echo "Got UTI files. Length:"
wc -l "$match_dir/type_id_files"

cat "$match_dir/type_id_files" | xargs -P 5 -n50 rg "^conforms to:[[:space:]]*(public.shell-script|public.script|public.text)" -l > "$match_dir/shell_script_uti_files" || true
cat "$match_dir/shell_script_uti_files" | xargs -P 5 -n50 rg "^uti: " | awk '{print $2}' | rg -v '(com\.apple\.|public\.html)' > "$match_dir/actual_uti_names"

echo "Updating"
cat "$match_dir/actual_uti_names" | xargs -n1 printf "${pycharm_bundle_id}\t%s\tall\n" | duti