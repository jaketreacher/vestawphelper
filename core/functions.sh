# Show the help menu
function show_help()
{
    echo "[Usage] $(basename $0) [domain] [database] [user] [password]"
}

# Generate a random string of $1 length
function gen_random_str()
{
    local MATRIX='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
    local LENGTH="$1"
    while [ ${n:=1} -le $LENGTH ]; do
        local PASS="$PASS${MATRIX:$(($RANDOM%${#MATRIX})):1}"
        let n+=1
    done
    echo "$PASS"
}

# Check if the array contains a value
function array_contains()
{
    local array=("$@")
    local last_idx=$((${#array[@]} - 1))
    local value=${array[last_idx]}
    unset array[last_idx]

    for item in "${array[@]}"; do
        if [[ $item == $value ]]; then
            return 0
        fi
    done
    return 1
}

# Generate a prefix for the database
function gen_db_prefix()
{
    local Bad_list
    mapfile -t Bad_list < <(mysql -e "SHOW TABLES IN ${Db_name}" | grep "users" | grep -oP "wp_\K.*(?=_users)")
    local idx=0

    while true; do
        local prefix="$(gen_random_str 4)"
        if ! (array_contains "${Bad_list[@]}" $prefix); then
            break
        fi
    done
    echo "$prefix"
}

function replace_key()
{
    local Key=$1
    local Value=$2
    local File=$3

    sed -i "s/.*${Key}.*/define('${Key}', '${Value}');/" ${File}
}

function replace_prefix()
{
    local Value=$1
    local File=$2

    sed -i "s/.*table_prefix.*/\$table_prefix  = 'wp_${Value}_';/" ${File}
}

function insert_after()
{
    local Pattern=$1
    local Value=$2
    local File=$3
    local Sections
    mapfile -t Sections < <(grep -P "${Pattern}" "${File}")

    local Section=${Sections[0]}

    if ! grep -q "${Value}" "${File}"; then
        sed -i "s/${Section}/${Section}\n${Value}/" ${File}
    fi
}

function find_site()
{

    local site=$1
    local path="$(find $(find /home -type d -name web) -type d -name ${site})"

    echo "${path}"
}
