#!/usr/bin/env bash
# Print Redis 6+/7 ACL commands that create an app user without dangerous commands
# (FLUSHALL, FLUSHDB, KEYS, CONFIG, DEBUG, ...). Commands go to stdout and the password
# to stderr, so you can pipe them straight into redis-cli as an admin user:
#
#   ./create-acl-user.sh -u store_erp_stg \
#     | redis-cli --tls -h <host> -p 6380 --user default --askpass
#
# Usage: create-acl-user.sh -u user [-p password] [-k key-pattern] [-n] [-s]
#   -u  user name
#   -p  password (default: random 32 chars, printed to stderr)
#   -k  allowed key pattern (default: *). Redis ACLs cannot restrict a logical DB
#       (SELECT n), so isolate apps with a key prefix (-k 'app:*') or by convention
#       on the DB index.
#   -s  strict: do NOT re-allow INFO and CLIENT SETNAME/GETNAME/ID. By default they are
#       re-allowed after -@dangerous because BullMQ refuses to start without INFO (version
#       check) and names its connections with CLIENT SETNAME.
#   -n  do not append ACL SAVE. Use it when users live inline in redis.conf (no aclfile):
#       ACL SAVE fails there, so persist with `redis-cli CONFIG REWRITE` afterwards.
#
# Re-running resets the user (ACL SETUSER ... reset) to exactly these rules.
set -euo pipefail

user='' password='' keys='*' save=true strict=false
while getopts 'u:p:k:nsh' opt; do
    case "$opt" in
        u) user="$OPTARG" ;;
        p) password="$OPTARG" ;;
        k) keys="$OPTARG" ;;
        n) save=false ;;
        s) strict=true ;;
        h) sed -n '2,21p' "$0"; exit 0 ;;
        *) exit 2 ;;
    esac
done

die() { echo "error: $*" >&2; exit 1; }

[ -n "$user" ] || die "-u is required (see -h)"
[[ "$user" =~ ^[A-Za-z0-9_-]{1,64}$ ]] || die "user name may only use letters, digits, _ and -"
[ "$user" != default ] || die "refusing to modify the default user"
[[ "$keys" =~ ^[A-Za-z0-9_:*.{}-]+$ ]] || die "invalid key pattern: $keys"
if [ -z "$password" ]; then
    # Read a fixed byte count first: `tr < /dev/urandom | head` gets SIGPIPE, which pipefail turns
    # into a failed command substitution.
    password="$(head -c 256 /dev/urandom | LC_ALL=C tr -dc 'A-Za-z0-9' | cut -c1-32)"
fi
[[ "$password" =~ ^[A-Za-z0-9_@#%+=.,:-]{12,}$ ]] || die "password must be 12+ chars without quotes, spaces or backslashes"

extra=''
[ "$strict" = true ] || extra=' +info +client|setname +client|getname +client|id'
echo "ACL SETUSER ${user} reset on >${password} ~${keys} &* +@all -@dangerous${extra}"
[ "$save" = true ] && echo "ACL SAVE"

{
    echo "# user:     ${user} (keys ~${keys}, +@all -@dangerous${extra})"
    echo "# password: ${password}"
    echo "# url:      rediss://${user}:${password}@<host>:6380/<db>"
} >&2
