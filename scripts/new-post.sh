#!/usr/bin/env bash
# Создать новую статью (leaf bundle): content/<lang>/post/<slug>/index.md
set -euo pipefail

usage() {
    cat <<'EOF'
Использование:
  scripts/new-post.sh <ru|en> <slug> "<Заголовок>" [--both]

Примеры:
  scripts/new-post.sh ru my-first-post "Моя первая статья"
  scripts/new-post.sh ru my-first-post "Моя первая статья" --both

  --both  создать заготовку и во втором языке с тем же translationKey
EOF
}

if [[ $# -lt 3 ]]; then
    usage
    exit 1
fi

lang=$1
slug=$2
title=$3
shift 3

both=false
for arg in "$@"; do
    case "$arg" in
        --both) both=true ;;
        *) echo "Неизвестный аргумент: $arg" >&2; usage; exit 1 ;;
    esac
done

case "$lang" in
    ru|en) ;;
    *) echo "Язык должен быть ru или en" >&2; exit 1 ;;
esac

if [[ ! "$slug" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    echo "slug должен быть в kebab-case: латиница в нижнем регистре, цифры, дефисы" >&2
    exit 1
fi

if [[ -z "${title// /}" ]]; then
    echo "Заголовок не может быть пустым" >&2
    exit 1
fi

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

# Экранирование для TOML basic string ("...")
toml_escape() {
    local s=$1
    s=${s//\\/\\\\}
    s=${s//\"/\\\"}
    printf '%s' "$s"
}

create_post() {
    local l=$1 t=$2
    local dir="$root/content/$l/post/$slug"

    if [[ -e "$dir" ]]; then
        echo "Уже существует: $dir" >&2
        return 1
    fi

    mkdir -p "$dir"
    cat > "$dir/index.md" <<EOF
+++
title = "$(toml_escape "$t")"
date = $(date +%Y-%m-%dT%H:%M:%S%:z)
draft = true
type = 'post'
description = ''
tags = []
categories = []
translationKey = '$slug'
+++

Напиши здесь что-нибудь.
EOF
    echo "Создано: $dir/index.md"
}

create_post "$lang" "$title"

if $both; then
    if [[ "$lang" == "ru" ]]; then
        other=en
    else
        other=ru
    fi
    create_post "$other" "TODO: translate"
    echo "Не забудь перевести $other-версию."
fi

main_dir="$root/content/$lang/post/$slug"
echo
echo "Дальше:"
echo "  1. Пиши в $main_dir/index.md"
echo "  2. Картинки клади в $main_dir/ (обложка — cover.*)"
echo "  3. Превью: hugo server -D --navigateToChanged"
echo "  4. Когда готово: draft = false и git push"
