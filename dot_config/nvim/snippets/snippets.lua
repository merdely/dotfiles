local ls = require("luasnip")

ls.add_snippets("all", {
  ls.snippet("mike", {
    ls.text_node({ 'mike@erdelynet.com' })
  })
})
ls.add_snippets("sh", {
  ls.snippet("bash", {
    ls.text_node({
      '#!/usr/bin/env bash',
      '',
    })
  }),
  ls.snippet("getopt", {
     ls.text_node({
       'usage() { echo "usage: ${0##*} [-h] [-a] [-b b]" ; exit "${1:-0}" ; }',
       '# local OPTIND=1 OPTARG="" opt=""',
       'while getopts ":hab:" opt; do',
       '  case $opt in',
       '    a) a=true ;;',
       '    b) b=$OPTARG ;;',
       '    h) usage ;;',
       '    :) echo "-$OPTARG requires an argument" ; exit 1 ;;',
       '    \\?) echo "Unknown option: -$OPTARG" ; exit 1 ;;',
       '  esac',
       'done',
       'shift $(( OPTIND - 1 ))'
     }),
  }),
  ls.snippet("function", {
    ls.insert_node(1, "function_name"),

    ls.text_node('() {'),
    ls.insert_node(2, " true; "),
    ls.text_node('}'),
  }),
})
