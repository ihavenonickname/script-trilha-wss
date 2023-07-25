root_domain="$1"

(
    amass enum -passive -d $root_domain 2> /dev/null ;
    subfinder -silent -d $root_domain
) \
| sort \
| uniq \
| httpx-toolkit -sc -td -json -probe 2> /dev/null \
| jq 'select(.failed == false)' \
| jq '.url, .host, .technologies'
