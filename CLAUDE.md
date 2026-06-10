# CLAUDE.md

Guidance for AI assistants (Claude Code and others) working in this repository.

## Project overview

**IDS-Estudantes** is a static, single-page marketing/institutional website for the
*IDS-Estudantes — Projeto de Formação de Quadros*, a non-profit Angolan project that
sponsors and supports students ("formação do novo homem Angolano"). The mantenedor/tutor
of the project is Ismael Diogo da Silva.

The site is built on a free **W3Layouts "Freightage"** Bootstrap template (Creative
Commons Attribution 3.0) that has been progressively customized for the IDS brand and
Portuguese-language content. Much of the original template's placeholder copy (Lorem
ipsum, "Vehicles Gallery", "Comfortable Payment", London contact address, etc.) is still
present and is being replaced section by section.

There is **no build step, no package manager, and no backend**. It is plain HTML, CSS,
and JavaScript served as static files.

## Tech stack

- **HTML5** — single page, `index.html` is the entire site.
- **CSS3** — Bootstrap 3 grid + a large custom stylesheet.
- **JavaScript** — jQuery 2.1.4 plus a handful of vendor plugins (no custom JS modules;
  initialization is done inline at the bottom of `index.html`).
- **Fonts/Icons** — Font Awesome and Glyphicons (local files under `fonts/`).
- No Node, no npm, no bundler, no transpilation, no tests.

## Repository structure

```
/
├── index.html                 # The entire site (all sections + inline JS init)
├── css/
│   ├── bootstrap.css          # Vendor — Bootstrap 3 (do not edit)
│   ├── font-awesome.min.css   # Vendor — icon font (do not edit)
│   ├── chocolat.css           # Vendor — lightbox styles
│   ├── style.css              # PRIMARY custom stylesheet — edit this for site styling
│   └── common.css             # Small shared helpers (e.g. .ch-grid)
├── js/
│   ├── jquery-2.1.4.min.js    # Vendor — jQuery (required first)
│   ├── bootstrap-3.1.1.min.js # Vendor — Bootstrap JS (navbar, modals)
│   ├── responsiveslides.min.js# Vendor — banner slider (#slider3)
│   ├── jarallax.js            # Vendor — parallax background (.jarallax)
│   ├── jquery.chocolat.js     # Vendor — gallery lightbox (.gallery a)
│   ├── modernizr.custom.js    # Vendor — feature detection
│   ├── numscroller-1.0.js     # Vendor — animated number counters
│   ├── move-top.js, easing.js # Vendor — scroll-to-top button
│   └── SmoothScroll.min.js    # Vendor — smooth scrolling
├── images/                    # All site imagery and brand logos
├── fonts/                     # Font Awesome + Glyphicons webfonts
└── w3layouts-License.txt      # Template license / attribution notes
```

### Page sections (anchors inside `index.html`)

The navbar scrolls to in-page anchors. Key section IDs:

- `#home` — banner / hero slider (`.rslides #slider3`)
- `#features` — **"Sobre o IDS"** (visão / missão / valores, tutor bio)
- `#stats` — parallax band with EDUCAÇÃO / SOCIEDADE / etc.
- `#capabilities` — **"Distribuição dos Campus"** (UNASP, IABC, UAP, Huaqiao…)
- `#team` — "Our Team" (still template placeholder content)
- `#gallery` — image gallery with Chocolat lightbox
- `#contact` — contact info + Google Maps iframe
- Modals: `#myModal1` (Send Message), `#myModal2` (Login), `#myModal3` (Register)

## Local development

This is a static site — just open or serve the files. No install step.

```bash
# Option A: open directly
open index.html              # macOS (use xdg-open on Linux)

# Option B: serve over HTTP (preferred — modals, iframes, fonts behave better)
python3 -m http.server 8000  # then visit http://localhost:8000
```

There is nothing to build, lint, or test. "Running the app" means loading
`index.html` in a browser and visually verifying the affected section.

## Conventions

- **Edit `css/style.css` for styling.** Treat `bootstrap.css`, `font-awesome.min.css`,
  `chocolat.css`, and everything in `js/` as vendored third-party files — do not modify
  them unless explicitly asked.
- **Layout uses the Bootstrap 3 grid** (`col-md-*`, `col-xs-*`, `.container`, `.row`,
  `.clearfix`). Follow the existing column patterns rather than introducing flexbox/grid.
- **JavaScript is initialized inline** at the bottom of `index.html` (slider, jarallax,
  Chocolat, smooth scroll, scroll-to-top). Add new plugin init in the same place, after
  the relevant `<script src>` include, and keep jQuery loaded first.
- **Class naming** follows the template's `w3l`, `w3ls`, `agileits`, `wthree`,
  `hvr-*` (Hover.css) conventions. Reuse existing classes where possible.
- **Content language is Portuguese (pt-AO)** for IDS copy; the template still ships some
  English placeholder text. When replacing placeholders, write in Portuguese to match the
  customized sections.
- **Images** go in `images/`. Reference them with relative paths (`images/foo.jpg`).
  Brand logos use the `LOGOTIPO …` filenames; the active navbar logo is `images/0012.png`.
- **Preserve the W3Layouts footer attribution** unless the user confirms they have the
  rights/plan to remove it (see `w3layouts-License.txt`).

## Git workflow

- Active development branch for this work: **`claude/claude-md-documentation-bfd1lu`**.
  Develop, commit, and push here. Do not push to `master` without explicit permission.
- Commit history is incremental with short, version-style messages, often in Portuguese
  (e.g. "atualização 2.1", "AT3,2", "Atualização 1.8"). Keep messages short and
  descriptive; English or Portuguese is fine.
- Push with `git push -u origin <branch>`; retry transient network failures with backoff.
- **Do not open a pull request unless explicitly asked.**

## Working notes for AI assistants

- This is an ongoing customization of a template: expect a mix of finished IDS content and
  leftover template placeholders in the same file. When asked to "develop per the
  prototypes," the task is typically to replace remaining placeholder sections (team,
  gallery captions, contact details, slider copy) with real IDS content and styling.
- Because there are no tests, **verify changes visually** in a browser and check that you
  have not broken the Bootstrap grid (`.clearfix` / column counts) or the inline JS init.
- Keep edits surgical and section-scoped — `index.html` is one large file; match the
  surrounding indentation (tabs) and HTML style.
- When adding interactivity, prefer the jQuery/Bootstrap 3 already loaded over pulling in
  new dependencies.
```
