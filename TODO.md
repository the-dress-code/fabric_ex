# TODO

- [x] Verify login + create-account flow works end-to-end from the landing-page CTAs (desktop and mobile).
- [ ] On `/home`, the success flash overlay sits above the top nav and intercepts clicks (e.g. "Log out") until dismissed. Give the flash a lower stacking context or auto-dismiss so nav stays clickable.
- [x] Decide top-nav scope for unauthenticated pages (landing vs login/register/reset). Resolved 2026-05-28: scoped a `:auth` layout (`Layouts.auth/1`) to the `:redirect_if_user_is_authenticated` live_session; its "Fabric Stash" wordmark links to the landing page (`/`) instead of `/home`.
- [ ] Email-confirmation pages (`/users/confirm/:token`, `/users/confirm`) are in the `:current_user` live_session and still use the `:app` layout (wordmark → `/home`). A logged-out user confirming email hits the same dead end the `:auth` layout fixed for login/register/reset. Decide whether they should use the `:auth` layout too.
- [x] Update auth-page LiveView tests to match log in / sign up flow.
- [ ] `router.ex:23` and `router.ex:53` both define `GET /`; the line-23 mount in the plain `:browser` pipeline always wins, so the line-53 mount inside `:redirect_if_user_is_authenticated` is dead code (logged-in users hitting `/` don't get bounced to `/home`).
- [ ] **Auth gap (IDOR):** `delete_fabric` in `home_live.ex:312` is not scoped to the current user — `Fabrics.delete/1` (`fabrics.ex:49`) does `Repo.get(Fabric, fabric_id)` with no `user_id`, so any logged-in user can delete any fabric by id. Contradicts the "all queries scoped by `user_id`" invariant. The bound-but-unused `user` at `home_live.ex:313` is the leftover of the intended scoping. Fix: scope the delete by `user_id`, add a regression test. (While there: drop unused `alias Phoenix.LiveView.JS` at `home_live.ex:4` and the unused `changeset` at `home_live.ex:329`.)
- [ ] Hero image (`priv/static/images/hero-fabrics.jpg`) is 895×1100 served as a single JPEG; on 3x retina mobile it'll look slightly soft. Add a `srcset` variant.
- [ ] Override `@page_title` on the landing page — browser tab still shows the default `FabricEx · Fabric Stash`.
