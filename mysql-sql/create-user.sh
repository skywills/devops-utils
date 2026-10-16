#!/usr/bin/env bash
# Print SQL that creates a MySQL 8.x database plus an app user that can only use it.
# The SQL goes to stdout and the password to stderr, so you can pipe the SQL straight
# into a client:
#
#   ./create-user.sh -d store_erp_stg -u store_erp_stg -s \
#     | mysql -h <host> -u root -p --ssl-mode=REQUIRED
#
# Usage: create-user.sh -d database -u user [-p password] [-H host-pattern] [-s]
#   -d  database name (created utf8mb4 / utf8mb4_unicode_ci if missing)
#   -u  user name (max 32 chars)
#   -p  password (default: random 32 chars, printed to stderr)
#   -H  host part of the account (default: %)
#   -s  REQUIRE SSL for this user (per user, so plaintext clients of other apps keep working)
#
# The user gets ALL PRIVILEGES on <database>.* only: no global grants, no shadow database.
# Re-running is safe: existing database/user are kept, the password is reset.
set -euo pipefail

db='' user='' password='' host='%' require_ssl=false
while getopts 'd:u:p:H:sh' opt; do
    case "$opt" in
        d) db="$OPTARG" ;;
        u) user="$OPTARG" ;;
        p) password="$OPTARG" ;;
        H) host="$OPTARG" ;;
        s) require_ssl=true ;;
        h) sed -n '2,17p' "$0"; exit 0 ;;
        *) exit 2 ;;
    esac
done

die() { echo "error: $*" >&2; exit 1; }

[ -n "$db" ] && [ -n "$user" ] || die "-d and -u are required (see -h)"
[[ "$db" =~ ^[A-Za-z0-9_]{1,64}$ ]] || die "database name may only use letters, digits and _ (max 64)"
[[ "$user" =~ ^[A-Za-z0-9_]{1,32}$ ]] || die "user name may only use letters, digits and _ (max 32)"
[[ "$host" =~ ^[A-Za-z0-9_.%-]+$ ]] || die "invalid host pattern: $host"
if [ -z "$password" ]; then
    # Read a fixed byte count first: `tr < /dev/urandom | head` gets SIGPIPE, which pipefail turns
    # into a failed command substitution.
    password="$(head -c 256 /dev/urandom | LC_ALL=C tr -dc 'A-Za-z0-9' | cut -c1-32)"
fi
[[ "$password" =~ ^[A-Za-z0-9_@#%+=.,:-]{12,}$ ]] || die "password must be 12+ chars without quotes, spaces or backslashes"

ssl_clause=''
[ "$require_ssl" = true ] && ssl_clause=' REQUIRE SSL'

cat <<EOF
CREATE DATABASE IF NOT EXISTS \`${db}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${user}'@'${host}' IDENTIFIED WITH caching_sha2_password BY '${password}'${ssl_clause};
ALTER USER '${user}'@'${host}' IDENTIFIED WITH caching_sha2_password BY '${password}'${ssl_clause};
GRANT ALL PRIVILEGES ON \`${db}\`.* TO '${user}'@'${host}';
FLUSH PRIVILEGES;
EOF

{
    echo "-- user:     ${user}@${host}${ssl_clause:+ (REQUIRE SSL)}"
    echo "-- database: ${db}"
    echo "-- password: ${password}"
    echo "-- url:      mysql://${user}:${password}@<host>:3306/${db}${ssl_clause:+?sslaccept=strict}"
} >&2
