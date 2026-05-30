# Fabric Stash — Vision

The living product vision. Organized from the original hand-written brief in
`orig_vision.md` (kept untouched for reference). Items are tagged **[v1]**
(near-term scope) or **[later]** (planned, not yet committed) — both live here so
each feature's full arc is in one place. For how the code is currently
structured, see `architecture.md`.

> Note: this doc describes *intended direction*. The codebase remains the source
> of truth for what is actually built today.

## What it is

Fabric Stash is a web app for keeping inventory of the fabric you own and use.
Early-stage Elixir/Phoenix app. The guiding principle is that it should be
**very user-friendly**.

## Inventory model

- **One entry per fabric** — each fabric is a single record with one photo, not
  one record per physical cut. If you buy more of a fabric you already own, you
  **manually update that fabric's quantity**; the app doesn't detect purchases.
  Accurate inventory depends on the user updating it both when fabric is *used*
  and when more is *bought*.
- **Quantity is a length.** **[v1]** the unit is **yards**. **[later]**
  user-selectable unit — add a **meters** option (with conversion and a metric
  step size). Feasibility of making this per-user is itself an open question.

## The collection grid (the emotional core)

The main page is a photo grid — Instagram-like — with **one photo per fabric**
in the collection. It's meant to display fabrics in a pleasing way that reflects
the beauty of the collection.

Its deeper purpose is behavioral: inspire people to **shop their own stash
before acquiring more fabric**. The grid is the hook; the rest of the app keeps
the data accurate enough for that grid to be honest and useful.

**[v1]** A photo is **required** for every fabric — the grid is the product's
face, so no entry is photo-less. The only intended social feature is an optional
**share of the photo grid** (**[later]**); otherwise collections are private.

## Cataloging a fabric

Each fabric is entered with its details:

- **[v1]** Enter details manually.
- **[v1]** Optional **product listing URL** — a link to the vendor's product
  page for that fabric (e.g. `IL109` at `linenstore.com`). A single field that
  also serves as the reorder link (see Reorder). No auto-population yet — the
  user fills in the details themselves.
- **[later]** Auto-populate details *from* the product listing URL via web
  scraping — pull the product image, fabric type, color, weight, vendor name,
  country of origin, etc. The user then supplies only a few things, like the
  quantity they have on hand.
- **[later]** Scan a fabric's barcode to add it to the database.

## Tracking & lifecycle

- **[v1]** Track each fabric's quantity as it gets used. Quantities are updated by
  editing the fabric entry — the **Yards** field is a number input (step 0.25;
  type a value or use the up/down stepper).
- **[v1]** Archive a fabric when it runs out. (Implementation detail to settle:
  the Yards field currently has a 0.25 minimum, so depleting to zero / archiving
  likely needs its own action rather than typing 0 in that field.)
- **[later]** Generate a QR code per fabric. Scanning it pulls up that fabric's
  details and offers a quick update dialog — "how much did you use?" / "how much
  do you have left?" — a frictionless front-end to the same quantity update.

### Archived & low-stock display

The collection grid should stay beautiful, so stock state is shown without
cluttering it:

- **Low stock** (≤ 1 yard; threshold configurable later): the fabric stays in
  the grid, with a small "low stock" indicator in the lower-right corner of its
  image.
- **Depleted / archived**: removed from the main grid to preserve the
  "view your whole collection at once" experience, but surfaced in a separate
  Archived view — and still reorderable (reorder matters most for fabric you've
  run out of).

## Reorder / replenish

A convenience for the user's **curated collection** — making it easy to rebuy
something they love and ran low on (e.g. they have 1 yard of a linen but need 5
for a matching set). This is replenishment, not discovery shopping.

- **[v1]** Because the app stores the product listing URL (the same field used
  when cataloging), "reorder" can start as simply surfacing that link to click —
  the app remembers where they got it even when they don't.
- **[later]** Deeper reorder: check availability / reorder from within the app.

## Filter — the precision tool

Filtering is for when the user **already knows exactly what they want** and
expects accurate, complete results. Example: making a summer dress that needs at
least 5 yards → filter on quantity (≥ 5), type (woven), kind (natural), weight
(lightweight/midweight), and get *every* fabric that matches — no more, no less.

Design principle: **filters must be correct and complete.** No fuzzy matching,
no guessing, no ranking. A fabric either meets the criteria or it doesn't.

(Which attributes become controlled pick-lists vs. free text — required for
filters to be reliably "complete" — is still open; see Open questions. Field
names above are illustrative and not yet finalized.)

## Search

Search is a text box for finding fabrics by criteria. Crucially, the
**"do I have enough?" reasoning happens in the user's head, not in the app.** The
user translates their project into explicit criteria and types them; the app just
returns the fabrics that match.

Example (v1): typing **"60in width, lightweight, blue, natural fibers, 5 yards"**
returns every fabric meeting all those criteria. Width and yardage are criteria
the *user supplies* — the app does **not** compute garment requirements in v1.

- **[v1]** Match explicit, user-supplied criteria — including width and a minimum
  yardage. (How the input is interpreted — free-text natural language vs. more
  structured entry — is still open; see Open questions.)
- **[later]** **Pattern integration** — the pattern itself supplies the yardage
  requirement, so the user no longer has to state the amount. This is what would
  enable a true natural-language query like "which natural fabrics do I have
  enough of to make a longsleeve knit dress in size 16 in a shade of blue?"
- **[later]** **Search by pattern title / number** — reference a sewing pattern
  by name or number and get back the fabrics that suit it. Example: "show me all
  my fabrics suitable for Simplicity 459" returns all lightweight woven fabrics,
  regardless of quantity or color, because that pattern calls for lightweight
  wovens. Because no view or size was given, the query does *not* filter on
  quantity — view/size determine how much fabric is needed, so without them we
  match on fabric characteristics only, not amount.

Filter and search both return exact matches on the same attributes; the
difference is input: **filter uses structured controls, search uses a text box.**
How deeply search interprets free text is still to be decided (see Open
questions).

## v1 scope at a glance

- Photo-grid main page (one entry per fabric; photo required), with low-stock
  indicators.
- Manual entry of fabric details; optional product listing URL.
- Quantity in **yards**; manual updates on use and repurchase; archive when
  depleted.
- Filter on structured attributes (accurate and complete).
- Search by explicit, user-supplied criteria (including width and yardage).

## Open questions (parked)

- **Q3 — Filter taxonomy.** Which attributes are controlled pick-lists vs. free
  text? Reliable, "complete" filtering depends on enumerated values. To work out
  together.
- **Q5 — Search interpretation.** Does search parse free-text natural language
  into criteria, or take more structured input? To be decided, then documented.
- **Q1 — Selectable units.** Whether per-user yard/meter selection is feasible
  for v1 or stays [later]; conversion and metric step size to define when built.
