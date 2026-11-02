+++
title = '{{ path.Base (strings.TrimSuffix "/" .File.Dir) | replaceRE "-" " " | title }}'
date = {{ .Date }}
draft = true
type = 'post'
description = ''
tags = []
categories = []
translationKey = '{{ path.Base (strings.TrimSuffix "/" .File.Dir) }}'
+++

Напиши здесь что-нибудь.

<!--
  Формулы: $inline$ и $$block$$ (рендерит KaTeX на сборке).
  Для \label/\ref/mhchem добавь в front matter: mathJax = true
  Картинки: положи файл рядом с index.md и вставь ![alt](file.png)
  Обложка: файл cover.* в этой же папке.
-->
