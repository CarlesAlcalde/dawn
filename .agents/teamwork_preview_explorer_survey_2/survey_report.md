# Comprehensive Layout, Templates, and Logo Integration Survey Report

**Author**: `teamwork_preview_explorer_survey_2`  
**Date**: 2026-08-28  
**Scope**: Shopify Dawn Theme (VelnorDesk Workspace) — Layout, Header, Footer, Logo Architecture, Key Templates (Index, Product, Cart), Sections, Snippets, and Brand Injection Points.

---

## 1. Executive Summary

This survey provides a complete architectural map of the VelnorDesk Shopify theme codebase. It details:
1. **Core Layout and Header/Footer Systems**: How `layout/theme.liquid`, `sections/header.liquid`, and `sections/footer.liquid` interact, including existing futuristic CSS/JS hooks (`assets/velnordesk.css`, `snippets/velnordesk-futuristic.liquid`).
2. **Logo Rendering & Integration Architecture**: Current image/text fallback mechanism vs. recommended SVG / stylized text logo architecture for "VelnorDesk" across desktop, mobile, sticky navigation, and footer.
3. **Template & Section Architecture**: Comprehensive layout breakdown of Homepage (`templates/index.json`), Product Page (`templates/product.json`), Cart Drawer & Cart Page (`templates/cart.json`, `snippets/cart-drawer.liquid`, `sections/main-cart-*.liquid`).
4. **Brand Injection Inventory**: Exact file paths, Liquid blocks, HTML tags, and CSS classes where typography, futuristic color schemes, glowing accents, 3D tilt effects, cyber badges, and custom icons should be applied.

---

## 2. Layout Structure Analysis (`layout/theme.liquid`)

### 2.1 Head Section & Global CSS Variables
* **File**: `layout/theme.liquid`
* **Key Observations**:
  * **Typography Loading**: Lines 13–15, 62–68 load fonts via Shopify CDN preconnect and `font_face` filters for `settings.type_header_font` and `settings.type_body_font`.
  * **Color Scheme Engine**: Lines 70–108 generate CSS variables per scheme (`.color-{{ scheme.id }}`) including `--color-background`, `--color-foreground`, `--color-button`, `--color-button-text`, `--color-secondary-button-text`, `--color-badge-foreground`, `--color-badge-background`, and `--color-badge-border`.
  * **Design Tokens & Spacing**: Lines 110–245 expose CSS variables for cards, buttons, variant pills, inputs, badges (`--badge-corner-radius`), drawers (`--drawer-border-width`), popups, and grid spacing.
  * **Stylesheet Injections**: Lines 267–278 load:
    * `base.css`
    * `velnordesk.css` (custom brand styles)
    * `component-cart-items.css`, `component-cart-drawer.css`, etc.

### 2.2 Body DOM Hierarchy
```html
<body class="gradient animate--hover-...">
  <!-- Accessibility skip link -->
  <a class="skip-to-content-link button visually-hidden" href="#MainContent">...</a>

  <!-- Cart Drawer (if settings.cart_type == 'drawer') -->
  {%- render 'cart-drawer' -%}

  <!-- Header Section Group -->
  {% sections 'header-group' %}

  <!-- Main Content Body -->
  <main id="MainContent" class="content-for-layout focus-none" role="main" tabindex="-1" data-template="{{ template.name }}">
    {{ content_for_layout }}
  </main>

  <!-- Footer Section Group -->
  {% sections 'footer-group' %}

  <!-- Cybernetic & Futuristic Enhancement Layer -->
  {% render 'velnordesk-futuristic' %}
</body>
```

### 2.3 Existing Futuristic Enhancements
* `snippets/velnordesk-futuristic.liquid` initializes:
  1. Scroll progress bar (`.vd-scroll-progress`)
  2. Custom magnetic cursor & button follower (`.vd-cursor`, `.vd-cursor-follower`)
  3. Text decode scramble effect on `.vd-decode-text`
  4. 3D card tilt & dynamic glare on `.card-wrapper`
  5. Audio feedback engine with web audio blips on interactive elements.
* `assets/velnordesk.css` provides:
  * CRT scanline overlay (`body::after`)
  * HUD animated matrix grid for dark schemes (`.color-scheme-3::before`)
  * HUD data labels (`.header-wrapper::before { content: "// SYS.NAV.ACTIVE"; }`, `.footer::before { content: "DATA_NODE_SECURE"; }`)
  * Pill buttons with sweeping light shimmer (`.button::before`)

---

## 3. Header & Logo Architecture

### 3.1 Header Structure (`sections/header.liquid` & `sections/header-group.json`)
* **Header Group Configuration**: `sections/header-group.json` defines two sections:
  1. `announcement-bar` (`sections/announcement-bar.liquid`, scheme-3, "Upgrade your workspace with VelnorDesk")
  2. `header` (`sections/header.liquid`, scheme-1, mega-menu, sticky: `always`)

### 3.2 Current Logo Rendering Flow
In `sections/header.liquid`, logo rendering is split into two layout paths:
1. **Middle-Left / Top-Left / Top-Center** (`lines 150–176`):
   ```liquid
   {%- if request.page_type == 'index' -%}<h1 class="header__heading">{%- endif -%}
   <a href="{{ routes.root_url }}" class="header__heading-link link link--text focus-inset">
     {%- if settings.logo != blank -%}
       <div class="header__heading-logo-wrapper">
         {{ settings.logo | image_url: width: 600 | image_tag: class: 'header__heading-logo motion-reduce', ... }}
       </div>
     {%- else -%}
       <span class="h2">{{ shop.name }}</span>
     {%- endif -%}
   </a>
   {%- if request.page_type == 'index' -%}</h1>{%- endif -%}
   ```
2. **Middle-Center** (`lines 188–212`): Duplicate structure with centered layout classes.

### 3.3 Recommended "VelnorDesk" Logo Integration Architecture
To achieve seamless brand integration without depending on external binary assets that could fail or load slowly, two complementary methods are recommended:

* **Method A: Dedicated Liquid Snippet (`snippets/velnordesk-logo.liquid`)**
  * Create `snippets/velnordesk-logo.liquid` containing a high-precision vector SVG logo combining a futuristic geometric "V" mark with sharp, tracked typography ("VELNORDESK") and neon glow filters.
  * Update `sections/header.liquid` and `sections/footer.liquid` to render `{% render 'velnordesk-logo' %}` if `settings.logo == blank` or as a direct stylized brand header.
* **Method B: Stylized CSS / SVG Hybrid (`.header__heading-link`)**
  * When `settings.logo == blank`, render a cyber-stylized text element:
    ```html
    <span class="vd-logo">
      <svg class="vd-logo__icon" viewBox="0 0 32 32">...</svg>
      <span class="vd-logo__text">VELNOR<span class="vd-logo__accent">DESK</span></span>
    </span>
    ```
  * Styled with letter-spacing `0.18em`, font-weight `800`, and subtle emerald/cyan LED glow.

### 3.4 Header Iconography
Header icons in `sections/header.liquid` use Shopify Dawn's `inline_asset_content` filter:
* Account icon: `{{ 'icon-account.svg' | inline_asset_content }}` (`line 254`)
* Cart icon (empty): `{{ 'icon-cart-empty.svg' | inline_asset_content }}` (`line 269`)
* Cart icon (active): `{{ 'icon-cart.svg' | inline_asset_content }}` (`line 271`)
* Search icon: in `snippets/header-search.liquid` (`{{ 'icon-search.svg' | inline_asset_content }}`)
* Drawer toggle: in `snippets/header-drawer.liquid` (`{{ 'icon-hamburger.svg' | inline_asset_content }}`)

---

## 4. Footer Structure (`sections/footer.liquid` & `sections/footer-group.json`)

### 4.1 Footer Configuration
* Defined in `sections/footer-group.json` with `scheme-3` (dark mode) containing:
  1. `link_list` ("Shop")
  2. `link_list` ("Customer Support")
  3. `text` ("About VelnorDesk" — "Premium desk setup and workspace accessories for clean, focused work.")
  4. Newsletter: "The Desk of Tomorrow."
  5. Social media icons and payment icons enabled.

### 4.2 Brand Injection Points in Footer
* **Top Area (`.footer__content-top`)**:
  * Brand Block (`case 'brand_information'` line 97): Renders `settings.brand_image`, `settings.brand_headline`, and `settings.brand_description`.
  * Can integrate `snippets/velnordesk-logo.liquid` above the brand description.
* **Social Icons (`snippets/social-icons.liquid`)**:
  * Inlines `icon-facebook.svg`, `icon-instagram.svg`, `icon-youtube.svg`, `icon-tiktok.svg`, `icon-twitter.svg`.
* **Bottom Area (`.footer__content-bottom`)**:
  * Payment list: `{{ type | payment_type_svg_tag: class: 'icon icon--full-color' }}`
  * Copyright & Powered by link (`lines 300–310`).

---

## 5. Key Templates & Section Architecture

### 5.1 Homepage (`templates/index.json`)
The homepage is composed of the following sequential sections:

| Order | Section ID | Type | Color Scheme | Key Content & Blocks |
|---|---|---|---|---|
| 1 | `velnordesk_split_hero` | `velnordesk-split-hero` | `scheme-1` | Eyebrow "The Minimalist Workspace", Heading "Elevate Your Desk Setup.", Scramble decode effect, Button CTA |
| 2 | `featured_collection` | `featured-collection` | `scheme-1` | Title "Signature Collection", 4 columns, quick add enabled, card tilt & glare |
| 3 | `velnordesk_hotspots` | `velnordesk-hotspots` | `scheme-2` | Title "Shop The Setup", 3 interactive pulsing hotspot pins with product cards |
| 4 | `testimonials` | `multicolumn` | `scheme-1` | 3 review cards (Michael T., Sarah J., David L.) |
| 5 | `deep_dive` | `image-with-text` | `scheme-2` | "Engineered for Stability", non-slip suede backing copy, button CTA |
| 6 | `brand_video` | `video` | `scheme-3` | "The Desk of Tomorrow", embedded YouTube workspace video |
| 7 | `newsletter` | `newsletter` | `scheme-3` | "Join the Waitlist", cyber input field, glowing subscribe button |

### 5.2 Product Page (`templates/product.json` & `sections/main-product.liquid`)
The product page is structured around `sections/main-product.liquid` with the following block order:

| Block ID | Block Type | Render File / Mechanism | Brand Injection Target |
|---|---|---|---|
| `vendor` | `text` | Upper case vendor name (`.product__text`) | Monospace cyber typography |
| `title` | `title` | `h1.product__title` | High-tech heading font, tight letter-spacing |
| `price` | `price` | `snippets/price.liquid` | Futuristic price badge, currency code highlight |
| `variant_picker` | `variant_picker` | `snippets/product-variant-picker.liquid` | Cyber pill buttons (`.variant-pills__button`), active glow border |
| `quantity_selector` | `quantity_selector` | `.product-form__quantity` | Minus/Plus custom SVGs (`icon-minus.svg`, `icon-plus.svg`) |
| `buy_buttons` | `buy_buttons` | `snippets/buy-buttons.liquid` | Magnetic Glowing CTA (`.product-form__submit`, `.button--primary`) |
| `benefits` | `icon-with-text` | `snippets/icon-with-text.liquid` | Trust badges (Clean setup ready, Reliable delivery, Easy support) |
| `description` | `description` | `.product__description.rte` | Refined typography, bullet styling |
| `shipping` | `collapsible_tab` | `icon-truck.svg`, accordion details | Accordion borders, glow on expand |
| `returns` | `collapsible_tab` | `icon-return.svg`, accordion details | Accordion borders |
| `details` | `collapsible_tab` | `icon-clipboard.svg`, accordion details | Accordion borders |
| `share` | `share` | `snippets/share-button.liquid` | Custom share icon |

* **Additional Product Page Sections**:
  * `disclosures`: `sections/disclosures.liquid`
  * `product_benefits`: `sections/multicolumn.liquid` ("Why VelnorDesk?", scheme-2)
  * `related-products`: `sections/related-products.liquid` ("Complete your setup")
  * `guarantee`: `sections/rich-text.liquid` ("The Velnor Guarantee", scheme-1)

### 5.3 Cart Architecture (`templates/cart.json`, `snippets/cart-drawer.liquid`, `sections/main-cart-*.liquid`)
1. **Cart Drawer (`snippets/cart-drawer.liquid`)**:
   * Drawer Container: `<cart-drawer class="drawer">` with `<div class="drawer__inner gradient color-{{ settings.cart_color_scheme }}">`.
   * Header: `<h2 class="drawer__heading">{{ 'sections.cart.title' | t }}</h2>`, close button with `icon-close.svg`.
   * Item Rows: `table.cart-items > tbody > tr.cart-item`.
   * Quantity Inputs: `<quantity-input>` with `icon-minus.svg` and `icon-plus.svg`.
   * Remove Action: `<cart-remove-button>` with `icon-remove.svg`.
   * Footer Totals: `.totals__total-value`, `.cart__checkout-button` with magnetic sweeping light effect.
2. **Main Cart Page (`templates/cart.json`)**:
   * `sections/main-cart-items.liquid`: Full table of line items, thumbnails, titles, variant options, and quantity steppers.
   * `sections/main-cart-footer.liquid`: Note drawer, discounts, estimated total, and `#checkout` button.
   * `featured-collection` ("You Might Also Like" upsell grid).

---

## 6. Comprehensive Brand Injection Matrix

The table below catalogs every specific file path, Liquid block, HTML tag, and CSS selector where brand enhancements must be applied to achieve the premium futuristic tech identity:

| Area | File Path | Liquid Block / HTML Element | CSS Selector / Classes | Proposed Brand Injection |
|---|---|---|---|---|
| **Theme Typography** | `config/settings_data.json` & `layout/theme.liquid` | `settings.type_header_font`, `settings.type_body_font`, `{% style %}` | `:root`, `body`, `h1, h2, h3, h4, h5, h6` | Update header/body font pairings to clean modern sans/tech fonts; tighten heading letter-spacing (`-0.03em`) |
| **Color Schemes** | `config/settings_data.json` | `color_schemes` (scheme-1 to scheme-5) | `:root, .color-scheme-*` | Primary dark (`#0d0f12`), clean white (`#ffffff`), tech secondary (`#16191f`), emerald/cyan neon accent (`#00f0ff` / `#2d5a27` / `#10b981`) |
| **Global Borders & Shadows** | `assets/base.css` & `assets/velnordesk.css` | Global styles | `.card-wrapper`, `.product__info-container`, `.drawer__inner`, `.field__input` | Subtle border colors (`rgba(255,255,255,0.08)` or `#e8e8e8`), glassmorphism backdrop-filter (`blur(12px)`), soft ambient shadows |
| **Header Logo** | `sections/header.liquid` | `lines 150-176, 188-212` | `.header__heading-link`, `.header__heading-logo-wrapper` | Render stylized vector SVG logo (`snippets/velnordesk-logo.liquid`) with glowing accent mark |
| **Header Nav & Sticky Bar** | `sections/header.liquid` & `assets/velnordesk.css` | `.header-wrapper` | `.header-wrapper`, `.header__menu-item`, `.cart-count-bubble` | Semi-transparent frosted glass header, glowing active indicators, cyber notification bubble for cart count |
| **Theme Icons (Cart)** | `assets/icon-cart.svg`, `assets/icon-cart-empty.svg` | Inline asset calls in header, drawer, cart items | `.svg-wrapper`, `header__icon--cart` | Sleek geometric futuristic shopping cart SVG vector |
| **Theme Icons (Search)** | `assets/icon-search.svg` | Header search modal, predictive search | `header__icon--search`, `.search__button` | Precision lens / cyber reticle search SVG vector |
| **Theme Icons (Account)** | `assets/icon-account.svg` | Header account link | `header__icon--account` | Futuristic user avatar / shield SVG vector |
| **Theme Icons (UI Carets & Steppers)** | `assets/icon-plus.svg`, `assets/icon-minus.svg`, `assets/icon-arrow.svg`, `assets/icon-close.svg` | Quantity pickers, drawer close, buttons | `quantity__button`, `.drawer__close`, `.button` | Sharp, minimal geometric UI glyphs |
| **Product Badges** | `snippets/card-product.liquid`, `snippets/price.liquid` | `.card__badge`, `.badge` | `.badge`, `.badge--bottom-left`, `.color-scheme-4`, `.color-scheme-3` | Cyber pill badges with glowing border, uppercase monospace tracking, subtle background tint |
| **Product Action Buttons** | `snippets/buy-buttons.liquid`, `sections/main-product.liquid` | `button.product-form__submit` | `.product-form__submit`, `.button--primary` | High-contrast neon/dark gradient fill, magnetic pull effect, light-sweep animation |
| **Product Variant Pills** | `snippets/product-variant-picker.liquid` | `.product-form__input` | `.product-form__input input[type=radio] + label` | Pill shape with glowing outline on `:checked`, monospace size/color labels |
| **Interactive Hotspots** | `sections/velnordesk-hotspots.liquid` | `.vd-hotspot` | `.vd-hotspot__dot`, `.vd-hotspot__tooltip-inner` | Pulsing concentric ripple animation, frosted glass tooltip with neon accent link |
| **Homepage Hero** | `sections/velnordesk-split-hero.liquid` | `.vd-split-hero` | `.vd-split-hero__title`, `.vd-decode-text`, `.vd-eyebrow` | Scramble text decode reveal, high-tech eyebrow tag with cyan accent |
| **Product Cards** | `snippets/card-product.liquid` | `.card-wrapper` | `.card-wrapper.vd-tilt-card`, `.vd-tilt-glare` | 3D perspective mouse tilt, dynamic radial glare reflection, smooth image zoom |
| **Cart Drawer & Page** | `snippets/cart-drawer.liquid`, `sections/main-cart-*.liquid` | `cart-drawer`, `main-cart-items` | `.drawer__inner`, `.cart-item`, `.cart__checkout-button` | Clean tabular layout, glowing checkout CTA button, dark glass footer |
| **Footer Brand & Links** | `sections/footer.liquid`, `snippets/social-icons.liquid` | `footer.footer`, `footer-block` | `.footer`, `.footer-block__brand-info`, `.list-social__link` | High-tech dark scheme (`scheme-3`), glowing social icon hovers, secure data node HUD metadata |

---

## 7. Conclusions & Next Steps

1. **Theme Health**: The codebase is well-structured on Shopify Dawn with custom VelnorDesk extensions already established (`velnordesk.css`, `velnordesk-futuristic.liquid`, custom sections).
2. **Implementation Readiness**: The injection points for typography, color schemes, custom SVG icons, and the "VelnorDesk" logo are precisely pinpointed without breaking any Shopify standard functionality or theme-check compliance.
3. **Synergy**: Upgrading the default icons and injecting the SVG logo snippet will elevate the theme to the desired premium futuristic tech standard.
