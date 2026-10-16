#!/usr/bin/env bash
# Print Redis 6+/7 ACL commands that create an app user without dangerous commands
# (FLUSHALL, FLUSHDB, KEYS, CONFIG, DEBUG, ...). Commands go to stdout and the password
# to stderr, so you can pipe them straight into redis-cli as an admin user:
#
#   ./create-acl-user.sh -u store_erp_stg \
#     | redis-cli --tls -h <host> -p 6380 --user default --askpass
#
# Usage: create-acl-user.sh -u user [-p password] [-k key-pattern] [-n]
#   -u  user name
#   -p  password (default: random 32 chars, printed to stderr)
#   -k  allowed key pattern (default: *). Redis ACLs cannot restrict a logical DB
#       (SELECT n), so isolate apps with a key prefix (-k 'app:*') or by convention
#       on the DB index.
#   -n  do not append ACL SAVE (when the server has no aclfile configured)
#
# Re-running resets the user (ACL SETUSER ... reset) to exactly these rules.
set -euo pipefail

user='' password='' keys='*' save=true
while getopts 'u:p:k:nh' opt; do
    case "$opt" in
        u) user="$OPTARG" ;;
        p) password="$OPTARG" ;;
        k) keys="$OPTARG" ;;
        n) save=false ;;
        h) sed -n '2,19p' "$0"; exit 0 ;;
        *) exit 2 ;;
    esac
done

die() { echo "error: $*" >&2; exit 1; }

[ -n "$user" ] || die "-u is required (see -h)"
[[ "$user" =~ ^[A-Za-z0-9_-]{1,64}$ ]] || die "user name may only use letters, digits, _ and -"
[ "$user" != default ] || die "refusing to modify the default user"
[[ "$keys" =~ ^[A-Za-z0-9_:*.{}-]+$ ]] || die "invalid key pattern: $keys"
if [ -z "$password" ]; then
    password="$(LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 32)"
fi
[[ "$password" =~ ^[A-Za-z0-9_@#%+=.,:-]{12,}$ ]] || die "password must be 12+ chars without quotes, spaces or backslashes"

echo "ACL SETUSER ${user} reset on >${password} ~${keys} &* +@all -@dangerous"
[ "$save" = true ] && echo "ACL SAVE"

{
    echo "# user:     ${user} (keys ~${keys}, +@all -@dangerous)"
    echo "# password: ${password}"
    echo "# url:      rediss://${user}:${password}@<host>:6380/<db>"
} >&2
