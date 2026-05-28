# TODO

- [ ] Verify login + create-account flow works end-to-end from the landing-page CTAs (desktop and mobile).
- [ ] Decide top-nav scope for unauthenticated pages (landing vs login/register/reset). Open question from 2026-05-28; revisit after researching the idiomatic Phoenix approach to scoping layout chrome.
- [ ] Update auth-page LiveView tests to match log in / sign up flow.
- [ ] `router.ex:23` and `router.ex:53` both define `GET /`; the line-23 mount in the plain `:browser` pipeline always wins, so the line-53 mount inside `:redirect_if_user_is_authenticated` is dead code (logged-in users hitting `/` don't get bounced to `/home`).
- [ ] Hero image (`priv/static/images/hero-fabrics.jpg`) is 895×1100 served as a single JPEG; on 3x retina mobile it'll look slightly soft. Add a `srcset` variant.
- [ ] Override `@page_title` on the landing page — browser tab still shows the default `FabricEx · Fabric Stash`.
