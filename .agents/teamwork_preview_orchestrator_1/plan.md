# Plan: VelnorDesk Shopify Theme Branding

## Objective
Elevate the VelnorDesk Shopify theme to a premium, futuristic tech aesthetic meeting all criteria in `ORIGINAL_REQUEST.md`.

## Execution Phases

### Phase 0: Survey & Requirements Mapping
- Spawn 3 parallel investigators:
  1. `teamwork_preview_spec_miner_survey_1`: Investigate current `config/settings_data.json`, `config/settings_schema.json`, color schemes, typography variables, font loaders.
  2. `teamwork_preview_explorer_survey_2`: Investigate header, logo handling, templates (index, product, cart, header/footer sections), and Liquid structure.
  3. `teamwork_preview_explorer_survey_3`: Investigate all theme icons (`snippets/icon-*.liquid`), SVGs, asset files, and CSS files (`assets/base.css`, etc.).

### Phase 1: Architecture & Scope Definition
- Synthesize findings into `PROJECT.md` at root.
- Define explicit Feature Inventory, Milestone Decomposition, File Ownership, Interface Contracts, and Verification Criteria.

### Phase 2: Implementation (Milestone Execution)
- Milestone 1: Brand Assets & Global Settings (`config/settings_data.json`, font definitions, color palette).
- Milestone 2: Global Brand Injection (`assets/base.css`, header/footer Liquid, product/cart styling, VelnorDesk stylized SVG/text logo in header).
- Milestone 3: Custom Futuristic Iconography (`snippets/icon-cart.liquid`, `snippets/icon-search.liquid`, `snippets/icon-account.liquid` / feature icons / social icons).

### Phase 3: Review, Challenge & Forensic Integrity Audit
- 2 Independent Reviewers (`teamwork_preview_reviewer`) evaluating aesthetic cohesion, compliance with requirements, syntax correctness.
- 2 Challengers (`teamwork_preview_challenger`) verifying CSS/Liquid integrity, contrast, responsiveness, and rendering correctness.
- 1 Forensic Integrity Auditor (`teamwork_preview_auditor`) ensuring authentic, non-facade implementation.

### Phase 4: Final Sign-off & Completion Reporting
- Record `GATE_STATUS.md`.
- Send completion message to parent.
