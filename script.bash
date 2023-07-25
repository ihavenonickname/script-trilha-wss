root_domain="$1"

(amass enum -passive -d $root_domain 2> /dev/null ; subfinder -silent -d $root_domain ) | sort | uniq
