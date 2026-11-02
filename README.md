# personal-blog

Мой личный блог: [nl.kinkirill.ru](https://nl.kinkirill.ru/).
Hugo + тема [hugo-brewm](https://github.com/foxihd/hugo-brewm), два языка: `ru` (по умолчанию) и `en`.

## Требования

- Hugo **0.169+** — `sudo pacman -S hugo` (версия должна совпадать с `hugo-version` в CI)
- git

## Локальный просмотр

```bash
hugo server -D --navigateToChanged
```

- Русская версия: http://localhost:1313/ru/
- Английская: http://localhost:1313/en/

Флаг `-D` показывает черновики (`draft = true`). `--navigateToChanged` открывает в браузере страницу, которую правишь.

## Новая статья

```bash
scripts/new-post.sh ru moya-statya "Моя статья"
```

Создаётся `content/ru/post/moya-statya/index.md` с `draft = true`. Чтобы сразу сделать заготовку и для английского:

```bash
scripts/new-post.sh ru moya-statya "Моя статья" --both
```

## Структура статьи

Статья — это **page bundle**: папка с `index.md` и картинками рядом.

```
content/ru/post/moya-statya/
├── index.md
├── cover.svg        # обложка (файл cover.*)
├── diagram.svg      # картинки, на которые ссылаешься из текста
└── photo.jpg
```

Front matter (TOML):

```toml
+++
title = "Моя статья"
date = 2026-06-29T12:00:00+03:00
draft = false
type = "post"
description = "Короткое описание для соцсетей и RSS"
tags = ["hugo", "math"]
categories = ["meta"]
translationKey = "moya-statya"  # общий ключ для ru/en версий
+++
```

## Картинки

Все файлы кладутся в папку статьи — ссылки в markdown относительные.

**Обложка** — файл `cover.*` (любой формат, который понимает браузер). Подхватывается автоматически. Alt-текст — `alt = "..."` во front matter.

**Обычная картинка:**

```markdown
![Alt-текст](diagram.svg "Подпись")
```

**Картинка на полях** (шорткод темы):

```markdown
{{< figure src="diagram.svg" alt="Alt-текст" caption="Подпись" type="margin" >}}
```

`type` может быть `margin`, `full` или пустым (обычная картинка). Ещё есть `class`, `link`, `title`, `attr`, `attrlink`.

Форматы: `svg`, `png`, `jpg`, `webp`. Для фото лучше `webp`/`jpg` шириной 1200–2000px, для схем — `svg`.

## Формулы

Поддерживается LaTeX. По умолчанию формулы рендерит **KaTeX на этапе сборки** (HTML + MathML), поэтому они видны даже без JavaScript.

```markdown
В строке: $e^{i\pi} + 1 = 0$

Блок:
$$
\int_0^1 x^2 \, dx = \frac{1}{3}
$$

Система:
$$
\begin{align}
  \nabla \cdot \mathbf{E} &= \frac{\rho}{\varepsilon_0}, \\
  \nabla \cdot \mathbf{B} &= 0.
\end{align}
$$
```

Если нужен совсем полный LaTeX — `\label`/`\ref`, `\newcommand`, `mhchem` (`\ce{H2O}`) — добавь во front matter:

```toml
mathJax = true
```

Тогда эта статья отрисуется MathJax'ом в браузере (тяжелее, но умеет больше). Локальный хук: `layouts/_markup/render-passthrough.html`.

Доллары в обычном тексте (цены) экранируй: `\$100`.

## Черновики и публикация

- `draft = true` — статья видна только локально, в прод не попадает.
- `date` в будущем — Hugo не публикует статью, пока дата не наступит.
- Публикация: `git add`, `git commit`, `git push` в `main`. GitHub Actions соберёт сайт и зальёт на сервер по rsync.
- `public/` в git не хранится — это артефакт сборки.

Проверить сборку как в CI:

```bash
hugo --gc --minify
```

## Что где лежит

| Путь | Что это |
|---|---|
| `hugo.toml` | конфиг сайта: языки, математика, параметры темы |
| `content/ru`, `content/en` | контент |
| `layouts/` | локальные переопределения шаблонов темы |
| `archetypes/post.md` | шаблон front matter для `hugo new` |
| `scripts/new-post.sh` | создание новой статьи |
| `themes/hugo-brewm/` | тема (апстрим, руками не правим) |
| `.github/workflows/deploy.yml` | CI: сборка и деплой |

## Giscus

Комментарии на GitHub Discussions. Нужно:

1. Репозиторий публичный (уже).
2. Включить **Discussions** в настройках репо.
3. Поставить [GitHub App giscus](https://github.com/apps/giscus).
4. Создать категорию (например, `General`) — не `Announcements`, там писать могут только мейнтейнеры.
5. Получить `repoID` и `categoryID` на [giscus.app](https://giscus.app) и раскомментировать `[params.giscus]` в `hugo.toml`.
