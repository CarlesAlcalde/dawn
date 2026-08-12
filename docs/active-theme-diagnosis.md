# VelnorDesk active theme diagnosis

Date: 2026-08-10

## What was checked

- Local repository state and latest commit.
- Local theme files modified by the VelnorDesk storefront commit.
- Public live storefront at `https://velnordesk.myshopify.com/`.
- Availability of Shopify/GitHub tooling in the container.

## Findings

The local repository contains the VelnorDesk homepage template and custom sections, but the live storefront is not rendering that homepage configuration. The public live page still renders the original Dawn-style homepage content headed by `Featured products` and the admin navigation labels `Inicio`, `Catálogo`, and `Contacto`.

The live storefront does show the updated footer content from the VelnorDesk commit (`Shop`, `Customer Support`, `About VelnorDesk`, and `Upgrade Your Desk.`), which indicates that at least some theme files from this repository have reached the published storefront. The mismatch is therefore not simply that no files were deployed; the homepage template and navigation configuration are out of sync with the published storefront runtime.

## Most likely cause

The active published theme is either:

1. using a different/stale `templates/index.json` than the repository version, or
2. rendering a Shopify theme-editor-saved homepage configuration that still contains only the original Dawn `featured-collection` section, or
3. using admin navigation menu data (`main-menu`) that has not been updated to the requested VelnorDesk labels.

Shopify navigation menus are store admin data, not theme source files. A theme file can select the menu handle, but the labels/links (`Inicio`, `Catálogo`, `Contacto`) come from the Shopify Navigation admin.

## Verification needed in Shopify admin or Admin API

To complete the active-theme verification, check the published theme in Shopify Admin or via Admin API and confirm:

- Published theme ID and name.
- Whether the published theme's `layout/theme.liquid` includes `velnordesk.css`.
- Whether the published theme has these assets/sections:
  - `assets/velnordesk.css`
  - `sections/velnordesk-hero.liquid`
  - `sections/velnordesk-benefits.liquid`
  - `sections/velnordesk-categories.liquid`
  - `sections/velnordesk-editorial.liquid`
- Whether the published theme's `templates/index.json` contains the VelnorDesk section sequence.
- Whether the `main-menu` navigation in Shopify Admin contains `Shop`, `Desk Mats`, `Cable Management`, `Desk Accessories`, `Workspace`, and `About`.

## Exact correction required

Deploy the repository version of `templates/index.json` and the VelnorDesk assets/sections to the published theme, then update Shopify Admin > Content > Menus > Main menu to the requested labels/links. If the published theme has a stale theme-editor homepage configuration, replace it with the repository `templates/index.json` section sequence.
