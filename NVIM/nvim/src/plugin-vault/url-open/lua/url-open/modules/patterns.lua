local a={}a.DEEP_PATTERN="\\v\\c%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)%([&:#*@~%<>_\\-=?!+;/0-9a-z]+%(%([.;/?]|[.][.]+)[&:#*@~%<>_\\-=?!+/0-9a-z]+|:\\d+|,%(%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)@![0-9a-z]+))*|\\([&:#*@~%_\\-=?!+;/.0-9a-z]*\\)|\\[[&:#*@~%_\\-=?!+;/.0-9a-z]*\\]|\\{%([&:#*@~%_\\-=?!+;/.0-9a-z]*|\\{[&:#*@~%_\\-=?!+;/.0-9a-z]*\\})\\})+"a.PATTERNS={{pattern="(https?://[%w-_%.]+%.%w[%w-_%.%%%?%.:/+=&%%[%]#<>]*)",prefix="",suffix="",file_patterns=nil,excluded_file_patterns=nil,extra_condition=nil},{pattern='["]([^%s]*)["]:%s*"[^"]*%d[%d%.]*"',prefix="https://www.npmjs.com/package/",suffix="",file_patterns={"package%.json"},excluded_file_patterns=nil,extra_condition=function(b)return not vim.tbl_contains({"name","version","proxy"},b)end},{pattern="[\"']([^%s~/]+/[^%s~/]+)[\"']",prefix="https://github.com/",suffix="",file_patterns=nil,excluded_file_patterns={"package%.json","package%-lock%.json"},extra_condition=nil},{pattern='brew ["]([^%s]*)["]',prefix="https://formulae.brew.sh/formula/",suffix="",file_patterns=nil,excluded_file_patterns=nil,extra_condition=nil},{pattern='cask ["]([^%s]*)["]',prefix="https://formulae.brew.sh/cask/",suffix="",file_patterns=nil,excluded_file_patterns=nil,extra_condition=nil},{pattern="^%s*([%w_]+)%s*=",prefix="https://crates.io/crates/",suffix="",file_patterns={"Cargo%.toml"},excluded_file_patterns=nil,extra_condition=function(b)return not vim.tbl_contains({"name","version","edition","authors","description","license","repository","homepage","documentation","keywords"},b)end}}return a
