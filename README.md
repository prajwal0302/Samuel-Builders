# Samuel Builders and Suppliers Pvt. Ltd.

A Next.js, TypeScript, and Tailwind CSS website for the construction and supply company based in Damak, Jhapa, Nepal. Built for local use; no website has been published.

## Run locally

Double-click **index.html** to browse the website directly from this folder. The file-based copy includes English and Nepali, the service and blog pages, and the contact links. The consultation form runs in the full local website. Double-click **Start Website.cmd** to start that version and open it in your browser.

Refresh the file-based copy after site edits with `pnpm build`, then `pnpm preview:offline`. Keep `index.html`, `offline-preview`, and `public` together when moving the copy.

For a background preview, double-click **Start Website.cmd** in this project folder, or run `pnpm preview`. The launcher checks whether this website is already running before starting a hidden local server. On Windows it uses the local Windows process provider to create the server independently of the calling terminal's process job; ordinary detached child processes can still be terminated when an agent session ends. It waits for an HTTP response and prints **http://127.0.0.1:3000**. Logs and process IDs are in the ignored `.local-preview` folder. No service, scheduled task, or startup entry is installed. Run the launcher again after a computer restart or if the server has stopped. This is a local preview on this computer, not a published internet address.

The Windows launcher uses Node.js from PATH, with a fallback to the Codex-bundled Node executable available when it was created. If a Codex update removes that executable and Node is not on PATH, install Node.js 24 or launch `pnpm preview` from a configured terminal.

Windows startup uses native process-provider commands, without executing a `.ps1` file or changing the machine's script-execution policy. The hidden `server-runner.mjs` keeps server output in `.local-preview/server.log`. The browser address works only while this local process is running.

Requirements: Node.js 24 and pnpm. The project was verified using Node.js 24 and pnpm 11.25, including the offline DOM tests.

```powershell
pnpm install
pnpm dev
```

Open **http://127.0.0.1:3000**. Stop the server with Ctrl+C.

When using `pnpm dev`, keep that terminal open. Closing it stops the foreground server. The background launcher above avoids that dependency.

```powershell
pnpm lint
pnpm typecheck
pnpm test
pnpm build
pnpm start
```

The development and build scripts select Next.js's supported webpack compiler. Turbopack's CSS worker exited unexpectedly on the Windows runtime used for this implementation; webpack builds successfully.

## What is included

- Home, About Us, Services, Blog, and Contact pages.
- Three complete article pages generated from local structured content.
- Construction, aggregates supply, machinery rental, earthworks, and interiors content.
- A consistent “Book a free consultation call” action and service-specific form preselection.
- Responsive layouts, mobile navigation with Escape and keyboard focus handling, semantic page structure, and accessible validation.
- Conditional, optional requirements fields for each service, plus Nepal callback dates and times.
- Server-side submission validation, body-size limits, a honeypot, and a basic per-instance rate limiter.
- Resend email or HTTPS webhook delivery, with genuine receipt checks and useful failure states.
- Page metadata, configured canonical URLs, business structured data, robots, sitemap, a generated social image, and an SVG favicon.
- Original local SVG architectural illustrations, support for optimized replacement photographs, and a designed image fallback. Illustrations are representative; no fictional projects, testimonials, prices, or contact details are presented.

## Update company information

Edit `lib/company.ts` to set the phone, email, WhatsApp number, business hours, verified map URL, logo, social links, and company photo paths. Unknown values are empty and their public links are omitted.

Use a country code for phone and WhatsApp numbers. The WhatsApp link uses the digits of the configured number. Use a verified map link for the exact company location; a generic or invented pin is not included.

To identify the company location from the device you are using, open `http://localhost:3000/find-location` while at the company premises and click **Use my current location**. The browser requests permission only after the click. Review the reported accuracy and pin in Google Maps before sharing the generated link. Coordinates stay in component memory and are not automatically saved or published. The helper page is excluded from the sitemap and marked noindex. Once verified, set `mapUrl` to a Google Maps directions URL for that destination; the bilingual directions button appears immediately below the Damak address. No company pin is guessed from the city name alone.

Replace the representative illustrations with approved company images when available. Update image descriptions in `lib/company.ts`, the homepage, and `lib/articles.ts` to match replacements. Change the imagery disclosure only once actual company photographs are used. Illustration authorship and replacement guidance are recorded in `ASSET_CREDITS.md`.

Articles live in `lib/articles.ts`. Each article has a slug, title, excerpt, category, reading time, image, sections, and a related service. Add another entry to create another listing card and generated article page.

## English / नेपाली language switch

Use **EN / नेपाली** in the header on desktop or mobile. Switching updates visible text immediately without reloading the document or changing the URL. All five pages, all three full articles, navigation, image descriptions, FAQs, form labels, options, placeholders, errors, and confirmation messages have Unicode Nepali translations. The page structure, images, colors, and existing layout are retained; Devanagari typography has appropriate line spacing.

`components/language.tsx` provides the shared language context and text component. Its `T` component renders a React fragment, so it changes text without adding layout elements. `lib/language-store.ts` stores the active choice and saves it under `samuel-language` in localStorage. The choice survives navigation and future visits and synchronizes between tabs. If storage is blocked, switching still works during the current visit.

The initial server HTML is English. After hydration, a saved Nepali choice is restored without hydration errors. The HTML `lang` attribute and browser tab title also update. Dates and internal service identifiers retain their machine-readable values. Switching preserves typed form data and the selected service; errors are translated when displayed. Names and descriptions are never automatically rewritten. Nepali digits entered in phone numbers are normalized for validation and delivery.

Translations are local dictionaries, with no translation API or network call:

- `lib/translations.ts`: shared interface, homepage copy, and translation lookup.
- `lib/translations-content.ts`: company, services, FAQs, and full articles.
- `lib/translations-pages.ts`: About, Services, Contact, Blog, and 404 page copy.
- `lib/translations-form.ts`: form copy, validation errors, and delivery messages.

When editing English source copy, update its matching dictionary key and Nepali value. Wrap new visible content in `T`, or call `t()` for placeholders and accessible labels. Unknown future strings fall back to English. The existing English metadata and share image remain the default server-rendered SEO representation; the toggle does not create separate indexed language URLs.

Automated offline DOM tests verify saved-language hydration, instant changes, unchanged URL, retained input controls and values, translated errors, storage fallback, cross-tab updates, and Nepali rendering of all eight content views. These tests do not replace a rendered device/font review.

## Enable consultation delivery

Copy `.env.example` to `.env.local` and configure **one** delivery option. Restart development after changing environment variables. In production, use the hosting provider's server-side environment settings.

### Option 1: Resend

```dotenv
RESEND_API_KEY=your_server_side_key
CONSULTATION_FROM_EMAIL=your_verified_sender
CONSULTATION_TO_EMAIL=the_inbox_that_receives_inquiries
```

The sender must be verified in Resend. All three variables are required. The inquiry is sent as plain text; an optional customer email is used as Reply-To. Success is returned only when Resend supplies an acceptance receipt. An acceptance receipt confirms acceptance by the provider, not a guaranteed inbox delivery or a booked appointment.

### Option 2: Company-controlled webhook

```dotenv
CONSULTATION_WEBHOOK_URL=https://your-receiver.example/consultations
CONSULTATION_WEBHOOK_SECRET=your_optional_bearer_secret
```

The webhook takes precedence when both options are configured. It receives JSON with `type`, `company`, `receivedAt`, `timezone`, and normalized `consultation` data. If configured, the secret is sent in `Authorization: Bearer …`.

The receiver must retain or forward the inquiry before acknowledging it with a 2xx response. Production URLs must use HTTPS. Redirects are rejected. A local HTTP receiver is allowed only outside production.

**Without a delivery destination, the server returns HTTP 503 and clearly states that the request was not sent.** Entered form values are preserved. There is no fake booking, local-only simulated success, or silent lead disposal. The team must contact the customer to confirm the consultation time.

Keep all delivery credentials server-side. Never add a `NEXT_PUBLIC_` prefix to a secret. No inquiry content is deliberately logged by the application. Review the chosen delivery provider's retention and access settings before launch.

## Domain and SEO

Set the real public origin when it is known:

```dotenv
NEXT_PUBLIC_SITE_URL=https://your-company-domain.example
```

Rebuild after setting or changing it. Canonicals and sitemap entries are omitted until a valid origin exists, so the application does not invent a company domain. A local build may warn that social image URLs use localhost before this is set. Metadata and business schema use supplied company facts only.

## Deployment

This app includes a server-backed form API and needs a Next.js-compatible Node/serverless host. A static-only export will not support `/api/consultation`. Configure the delivery environment variables and public origin on that host, then build and start with the scripts above or the provider's Next.js integration.

The rate limiter is intentionally basic and stored in memory per process. Before a public deployment with several instances, configure a shared limiter or trusted upstream protection. Only trust client-address headers set by your hosting proxy.

## Verification

The meaningful consultation tests cover flexible phone numbers, optional and conditional fields, Nepal dates, invalid inputs, origin checks, request limits, missing configuration, provider acceptance, webhook failures, and retry limits. Outbound delivery is mocked in automated tests; real email delivery requires your configured provider.

Latest bilingual implementation checks passed: ESLint, TypeScript, 20 automated tests, 16 live server smoke checks, and the webpack production build. A previous unconfigured-delivery smoke check also passed. The four SVG illustration assets were rasterized and visually inspected separately from the website.

For live server smoke checks, run the server and then:

```powershell
node tests/smoke.mjs
```

Only when you have confirmed that delivery credentials are absent, enable the unconfigured-form check:

```powershell
$env:SMOKE_UNCONFIGURED_FORM = '1'
node tests/smoke.mjs
Remove-Item Env:SMOKE_UNCONFIGURED_FORM
```

Browser preview permission was declined in the implementation session. Source-level responsive checks and server checks are available, but rendered visual inspection, keyboard interaction testing, and actual device testing remain to be performed. Review 360px, 390px, 768px, 1024px, and 1440px layouts in a browser before publishing. External photograph downloads were cancelled; the website uses original, locally authored SVG illustrations instead. These can be replaced with approved company photographs.

## Needed before launch

1. Genuine phone, email, WhatsApp, business hours, and exact map link as appropriate.
2. Consultation delivery credentials and receiving inbox or receiver.
3. The real website domain and hosting choice.
4. Official logo and approved company/project photographs, if available.
5. Final owner review of content and service scope.
6. A real delivery check and browser/device review.

No fabricated staff portraits, reviews, contract awards, equipment ownership, fleet counts, material specifications, or delivery guarantees have been added.
