# Architecture

Orientation map for the Fabric Stash codebase. This is reference context — the
imperative rules (commands, conventions, don'ts) live in `CLAUDE.md`.

Phoenix 1.7 LiveView app for managing a personal fabric inventory. Uses
PostgreSQL, Tailwind CSS, esbuild, and Bandit as the HTTP server.

## Contexts

- **`FabricEx.Accounts`** — phx.gen.auth-generated user authentication (bcrypt, session-based). Handles registration, login, password reset, email confirmation via Swoosh (local adapter in dev, viewable at `/dev/mailbox`).
- **`FabricEx.Fabrics`** — CRUD for fabric records. Fabrics belong to a user; all queries are scoped by `user_id`.

## Fabric Schema

Fields: `image` (upload path string), `color`, `shade`, `weight`, `content`, `structure` (all strings with datalist suggestions in the UI), `width` (integer, inches), `yards` (float), `item_number` (optional string).

## LiveViews

- **`HomeLive`** (`/home`) — Main view. Displays fabrics in both a table and an image grid. "Add Fabric" opens a modal with a form including LiveView file upload. Row click opens a details modal using `FabricComponents.details_card/1`. Edit/delete actions per row.
- **`EditLive`** (`/fabrics/:fabric_id/edit`) — Standalone edit form. Image upload is optional on edit (keeps existing image if none uploaded).

## File Uploads

LiveView uploads stored to `priv/static/uploads/`. Accepts `.png` and `.jpg`, max 1 file per upload. Both `HomeLive` and `EditLive` have their own `consume_files/1` helper that copies the temp file to the uploads directory.

## Routing

Three live_sessions with auth scoping:
- `:redirect_if_user_is_authenticated` — registration, login, password reset
- `:require_authenticated_user` — `/home`, `/fabrics/:fabric_id/edit`, user settings
- `:current_user` — email confirmation (public)

The root `/` route renders `PageController` (landing page), separate from `/home` (authenticated fabric list).

## Custom Components

`FabricExWeb.FabricComponents` provides `details_card/1` (used in HomeLive's detail modals) and `edit_details_card/1` (currently unused — editing uses EditLive directly).
