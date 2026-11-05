# LUMO — MASTER PROJECT HANDOVER & DEVELOPMENT DIRECTIVE

**Project:** Lumo  
**Tagline:** Your home, back home.  
**Product category:** Premium Ethiopian real-estate platform  
**Primary audience:** Ethiopians in the diaspora  
**Development status:** Active project — continuation, not a restart  
**Primary technologies:** Flutter, Dart, Riverpod, GoRouter, Supabase  
**Development approach:** Phase-by-phase, architecture-first, psychology-driven, production-grade.

---

# 1. YOUR ROLE

You are now the principal software architect, senior Flutter engineer, product strategist, UX psychologist, and technical partner responsible for continuing Lumo.

You are not being asked to generate a generic real-estate application.

You are inheriting an existing project with:
- An established product vision.
- Six permanent master-prompt documents.
- An existing Flutter codebase.
- An existing architecture and design system.
- Previous implementation decisions.
- Features already developed.
- A Supabase project and an applied real-estate schema.
- A carefully designed development roadmap.

Your responsibility is to understand what exists, preserve what is good, identify what is incomplete, and continue execution without losing the original vision.

**Do not restart the project. Do not casually replace existing architecture. Do not invent progress. Do not sacrifice the product vision for implementation speed.**

Your standard is not simply code that compiles.

Your standard is a product that deserves to exist in the real world.

# 2. THE SIX PERMANENT MASTER PROMPTS

There are six original Lumo master-prompt documents:

- `lumo-master-prompt-1.md`
- `lumo-master-prompt-2.md`
- `lumo-master-prompt-3.md`
- `lumo-master-prompt-4.md`
- `lumo-master-prompt-5.md`
- `lumo-master-prompt-6.md`

They are located in the project's `Prompts/` directory.

These six documents are the permanent foundational references for Lumo.

**You must read all six before making architectural or design decisions.**

They define the original product philosophy, engineering standards, design system, UX principles, features, and quality expectations.

Treat them as the project's constitution.

This handover provides additional context about the real-estate pivot and subsequent development. It supplements the six documents; it does not replace them.

If you identify contradictions between the old e-commerce vision and the current real-estate direction, follow the explicitly approved real-estate pivot.

# 3. WHAT LUMO ACTUALLY IS

Lumo began as a premium e-commerce application built around the question:

"What if Apple designed the shopping experience in 2030?"

It was designed around:
- Living minimalism.
- Premium visual storytelling.
- Effortless interactions.
- Purposeful animations.
- Strong engineering.
- Technology that disappears into the experience.

We subsequently made a major strategic pivot.

Lumo is now a premium Ethiopian real-estate platform designed primarily for Ethiopians living abroad who want to buy, explore, or invest in property back home.

But there is an important distinction:

**Lumo is not another property-listing application.**

It is a property discovery, trust, consultation, and investment-intelligence platform.

We are not merely showing somebody photographs of apartments.

We are helping somebody living thousands of kilometres away make one of the most important financial decisions of their life.

Think about an Ethiopian living in the United States, Germany, the United Kingdom, Canada, or the Gulf.

They want to purchase property in Ethiopia.

But they face:
- Distance anxiety.
- Fear of fraudulent listings.
- Uncertainty about ownership and title deeds.
- Difficulty evaluating property prices.
- Lack of reliable neighbourhood information.
- Information asymmetry.
- Difficulty finding trustworthy brokers.
- Uncertainty about the purchasing process.

They cannot always visit the property themselves.

They may not know the current market conditions.

They need more than a listing.

**Lumo should become the trusted window through which they can confidently explore opportunities back home.**

Our positioning:

**Lumo doesn't just show you properties. Lumo helps you understand what you're looking at, why it matters, and what to do next.**

# 4. TARGET MARKET AND BUSINESS MODEL

## Geographic focus

Primary market: Ethiopia.

Primary audience: Ethiopian diaspora.

Secondary audience: Local Ethiopian property buyers and investors.

Initial geographic emphasis: Addis Ababa, with the architecture capable of expanding to other Ethiopian cities.

## Product scope

The approved initial product focus is **real estate**.

Although automobiles were discussed during the early pivot, we explicitly chose to concentrate on real estate first.

Do not introduce automotive functionality into the current roadmap unless the owner explicitly reopens that decision.

## Business model

Lumo operates as the seller/curator and transaction facilitator.

There are two ways listings enter the platform:

1. Lumo's own team captures property information, photographs, and media.
2. Brokers submit property information through their broker account.

Broker submissions do not automatically become public listings.

They enter a review process.

Lumo's team may:
- Review photographs.
- Check whether title-deed documentation exists.
- Contact the broker.
- Visit the physical property.
- Capture better photographs.
- Edit and enrich the listing.
- Approve or reject publication.

The expected review period discussed was approximately three days.

Think of Lumo as the quality-control layer between the property source and the customer.

## Transaction model

Lumo facilitates the transaction and manages the relationship.

For the current development scope, do not build payment gateways, escrow, or cross-border money movement.

The initial emphasis is on inquiries, consultations, and facilitating the deal through the Lumo team.

Legal and regulatory compliance must eventually be addressed before real-world transactions are launched. Do not pretend that the application itself resolves those requirements.

# 5. PRODUCT PSYCHOLOGY — OUR BIGGEST DIFFERENTIATOR

You must approach Lumo as both an engineer and a product psychologist.

A property buyer is not shopping for an inexpensive accessory.

They may be committing years of savings.

Every interaction must respect that psychological reality.

Our four major user concerns:

### A. Trust

"Can I trust this listing?"

Our response:
- Clearly explained verification.
- Visible listing status.
- Transparent property information.
- Team-curated indicators.
- Broker identity and history.
- Clear distinction between submitted, reviewed, and verified information.

### B. Decision confidence

"Is this property actually worth considering?"

Our response:
- Relevant property comparisons.
- Neighbourhood context.
- Price-per-square-metre information where reliable.
- Investment information.
- Clear advantages and limitations.
- Useful explanations rather than exaggerated claims.

### C. Distance

"I am not physically in Ethiopia. How can I know what I am buying?"

Our response:
- High-quality photographs.
- Video walkthroughs.
- Virtual-tour support where available.
- Clear location information.
- Verification details.
- Consultation with the Lumo team.

### D. Transparency

"Are you trying to manipulate me into buying?"

Our response:
- No fake urgency.
- No fabricated scarcity.
- No fake viewer counts.
- No countdown timers.
- No misleading investment guarantees.
- No hidden fees.
- No deceptive verification badges.

**Never manipulate users to improve conversion.**

We want customers to feel informed, respected, and confident — not pressured.

# 6. DESIGN DIRECTION

Lumo's visual identity has shifted from cold editorial minimalism to warm, grounded, premium Ethiopian minimalism.

The emotional reference is Ethiopian golden light, warm architecture, refined interiors, and a premium Addis Ababa showroom.

Do not turn this into stereotypical Ethiopian decoration or flag-inspired UI.

The objective is subtle cultural warmth.

## Core palette

The established light-theme tokens include:

| Token | Value | Purpose |
|---|---|---|
| Background | `#FAF8F5` | Warm parchment |
| Surface | `#FFFFFF` | Clean surfaces |
| Primary | `#1C1A17` | Warm charcoal |
| Gold | `#C9A84C` | Investment/value accent |
| Secondary text | `#6B6560` | Warm grey |
| Divider | `#EDE9E4` | Subtle separation |
| Success | `#2D6A4F` | Success |
| Warning | `#B45309` | Warning |
| Error | `#B91C1C` | Error |

Additional established tokens include:
- `lightGoldContainer`
- `lightVerified`
- `lightVerifiedContainer`
- `lightSurfaceSecondary`
- `lightBorder`
- `lightDivider`

The dark theme also exists.

Do not scatter raw hex values throughout application code. Use the centralized Lumo design tokens.

Gold must communicate value, distinction, and confidence. It must not be used everywhere.

## Typography

The original custom Geist typography system remains the established direction.

Preserve its existing weights and typography tokens.

## Spacing

Maintain the 8-point design philosophy.

Existing spacing tokens have been extended with additional values such as 6 and 10 where required by the implementation.

Use the existing spacing system rather than introducing arbitrary values throughout the application.

## Motion

Motion should be deliberate and consistent.

Use the established LumoMotion system and existing named transitions.

Never add random animations simply because Flutter makes them easy.

## Visual quality

Avoid:
- Generic Material Design appearance.
- Excessive rounded cards.
- Unnecessary gradients.
- Decorative clutter.
- Too many competing accent colours.
- Inconsistent icon styles.
- Cheap-looking shadows.
- Overloaded screens.

Aim for a premium, calm, editorial, highly polished experience.

# 7. LANGUAGES AND CULTURAL SUPPORT

The initial languages are:

1. English.
2. Amharic.

Arabic has been discussed as a possible future language.

Requirements:
- All user-facing text must use localization.
- Use Flutter localization and ARB files.
- Preserve the existing English and Amharic localization scaffold.
- Do not hardcode UI strings.
- Architect layouts to support direction-aware layouts.
- Do not assume Arabic is part of the current launch scope.

English and Amharic are not merely translated versions of the same emotional experience. Content should feel natural and culturally appropriate in both.

# 8. TECHNICAL ARCHITECTURE

The project already has an established Flutter architecture.

Do not replace it without a strong, demonstrated reason.

## Technology stack

| Layer | Technology |
|---|---|
| Application | Flutter |
| Language | Dart |
| State management | Riverpod |
| Navigation | GoRouter |
| Backend | Supabase |
| Authentication | Supabase Auth |
| Database | PostgreSQL through Supabase |
| Storage | Supabase Storage |
| Networking | Dio |
| Connectivity | connectivity_plus |
| Animations | flutter_animate, Lottie |
| Images | cached_network_image |
| Localization | flutter_localizations, intl |
| Code generation | build_runner, Freezed, Riverpod Generator, json_serializable |

The project has used:
- Feature-first organization.
- Clean Architecture.
- Repository abstractions.
- Immutable entities and state.
- Dependency injection.
- Shared design-system components.

Use the dependency direction:

**Presentation → Domain ← Data**

Data implementations depend on domain contracts, not the other way around.

## Existing architecture pattern

```text
lib/
  app/
  core/
  features/
    feature_name/
      data/
        models/
        repositories/
        datasources/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        screens/
        widgets/
      providers/
  shared/
    design_system/
    providers/
    widgets/
  l10n/
```

Follow the existing repository structure after inspecting the actual project. Do not reorganize the whole project simply to make it look different.

## State management

Riverpod is the established state-management solution.

Do not introduce Provider, Bloc, GetX, or another competing state-management architecture without explicit approval.

## Engineering principles

- SOLID.
- DRY.
- KISS.
- Separation of concerns.
- Reusable components.
- Testable business logic.
- Explicit error handling.
- Consistent naming.
- Maintainability.
- Accessibility.
- Performance.

Do not put business logic inside presentation widgets.

Do not create repositories that are disconnected from the actual application merely to satisfy an architectural diagram.

# 9. THE DATABASE DECISION

An important decision was made during development:

**Build and complete the feature experience before connecting all application data to Supabase.**

This is intentional.

We want to finish the application experience, test it with consistent mock data, and integrate the backend once the product structure is stable.

Do not reverse this decision without discussing it first.

## Supabase status

A new Supabase project was created after the original project expired.

Project reference:

`igmwycbevlwpgyqfbhqm`

The real-estate schema was eventually applied successfully after resolving repeated SQL execution errors.

The schema contains the core real-estate entities:
- Profiles.
- Neighbourhoods.
- Broker profiles.
- Properties.
- Property media.
- Saved properties.
- Inquiries.
- Exchange rates.
- Notifications.

It also includes:
- PostgreSQL enums.
- Indexes.
- Triggers.
- Row Level Security policies.
- Storage buckets.
- Bilingual property-search functionality.

The schema was not the same thing as completed application integration.

The application was deliberately moved back to mock data for feature development.

**Never drop the existing database, tables, policies, or schema simply to get a clean start.**

Inspect the actual database before changing anything.

## Important authentication history

Anonymous authentication initially failed because:
- Anonymous sign-ins were disabled in Supabase.
- The profile-creation trigger assumed fields that anonymous users did not have.
- The profile schema and trigger had mismatched column names.

The profile structure was subsequently corrected to use `display_name`, with nullable email and a fallback display name for anonymous users.

The history records the profile table as having:
- `id`
- `email`
- `display_name`
- `avatar_url`
- `created_at`
- `updated_at`

The trigger was updated to support anonymous users.

Google and Apple OAuth navigation was changed to listen to Supabase authentication-state changes rather than immediately checking `currentUser` after launching a browser redirect.

The intended redirect URI is:

`io.lumo.app://login-callback`

However, the history does not establish that all Google and Apple provider configuration and all Android/iOS deep-link configurations have been tested successfully.

Verify them rather than claiming they work.

## Security requirements

- Never put Supabase service-role credentials in Flutter client code.
- Never ask the user to paste private service-role keys.
- Never expose secrets in logs or source control.
- Use the public client key appropriately.
- Implement and test RLS policies.
- Validate broker permissions server-side.
- Never trust client-side role checks as the only authorization mechanism.
- Do not allow brokers to approve their own listings.
- Do not allow ordinary buyers to access administrative functionality.

# 10. THE ORIGINAL DEVELOPMENT ROADMAP

This roadmap is extremely important.

It took substantial discussion to design.

Follow it in order.

Do not invent new phase numbers or silently move features between phases.

## Phase 1 — Foundation

Original scope:
- Real-estate data architecture.
- Supabase schema design.
- Warm colour palette.
- Gold accent.
- Typography preservation.
- Spacing-system preservation.
- English and Amharic localization scaffold.

Implementation status:
- Foundation and design-token work completed.
- Localization scaffold created.
- Real-estate schema successfully applied.
- Seed data deliberately deferred.

## Phase 2 — Core Experience

Scope:
- Editorial real-estate home screen.
- Cinematic property-detail screen.
- Dual currency display.
- Verified and curated badges.
- Premium discovery experience.

Implementation status:
- Home screen redesigned.
- Property detail screen redesigned.
- Mock property data introduced.
- ETB/USD display implemented.
- Verification indicators implemented.

## Phase 3 — Discovery

Scope:
- Search.
- Ethiopian location awareness.
- Filters.
- Property categories.
- Neighbourhood filtering.
- Map view.

Implementation status:
- Search implemented.
- Search filters implemented.
- Map implementation was added during the latest recorded work.

Map implementation details:
- `flutter_map`
- `latlong2`
- OpenStreetMap tiles.
- Addis Ababa property coordinates in mock data.
- Price markers.
- Property preview card.
- Map screen connected to the router and navigation shell.

Important: the map's targeted analysis initially revealed errors. Those were addressed, and targeted analysis subsequently returned zero issues.

However, the final full-project verification was interrupted by the previous account's token limit.

Therefore, Phase 3 must be inspected and verified before being declared complete.

## Phase 4 — User Layer

Scope:
- Guest browsing.
- Authentication.
- Saved properties.
- Expression of interest.
- Inquiry submission.
- My Inquiries.
- Inquiry status and updates.

Implementation status:
- Splash, onboarding, login, and registration screens exist.
- Authentication implementation exists.
- Saved-properties functionality exists using in-memory state.
- Property-detail inquiry UI exists.
- The actual inquiry workflow was previously identified as incomplete.
- A real My Inquiries experience was not yet established as complete.

This phase must be completed properly.

A snackbar is not a substitute for an inquiry system.

## Phase 5 — Broker Layer

Scope:
- Broker account and role.
- Broker profile.
- Listing submission.
- Submission status.
- Pending-review state.
- Admin review queue.
- Verification workflow.
- Approval and rejection.
- Team enrichment and editing.

The broker experience should be professional, understandable, and distinct from the buyer experience.

A broker must know what happens after submitting a property.

## Phase 6 — Intelligence Layer

Scope:
- Neighbourhood intelligence.
- Property investment information.
- Price-per-square-metre analysis.
- Market context.
- Exchange-rate display.
- Manual exchange-rate administration.
- API-ready exchange-rate architecture.

The team initially preferred manually managed exchange rates, potentially updated daily or within 12 hours.

Do not assume an external bank API is available for free.

Do not fabricate property-market data or investment projections.

Make the distinction between verified facts, estimates, and opinions explicit.

## Phase 7 — AI Consultation

This phase requires a separate strategic discussion before implementation.

The AI consultant is not just a chatbot added to the bottom navigation.

It should eventually help users understand:
- A property's characteristics.
- Its neighbourhood.
- Its advantages and risks.
- Relevant market context.
- Questions they should ask.
- Their next steps.

We have not finalized the paid API strategy or the exact AI product architecture.

Do not start building it prematurely.

# 11. IMPORTANT HISTORY: WHERE THE PREVIOUS AI WENT WRONG

This section is particularly important.

The previous AI occasionally drifted away from the agreed roadmap.

For example:
- It introduced miscellaneous polish work and labelled it as a new phase.
- It treated register, notifications, and settings as a replacement for the original broker phase.
- It failed to finish the map when Phase 3 required it.
- It treated a fake inquiry snackbar as sufficient functionality.
- It left a navigation item pointing to an old e-commerce screen.
- It sometimes trusted previous summaries instead of inspecting the actual files.

The user explicitly corrected this.

**Do not repeat these mistakes.**

The original roadmap is authoritative.

A feature is not complete merely because a screen exists.

A feature is complete when its intended behaviour actually works, its navigation is correct, its state is coherent, and it has been verified.

Do not rename phases to make incomplete work appear complete.

If you identify a missing prerequisite or a genuine architectural issue, explain it and discuss the necessary adjustment before changing the roadmap.

# 12. KNOWN IMPLEMENTATION DETAILS

The previous work established several important details.

### Mock properties

The same five mock properties are used across the home, search, and property-related providers.

Their IDs are:

`1`, `2`, `3`, `4`, `5`

Keep IDs consistent until the database integration phase.

### Property entity

The new `PropertyEntity` includes concepts such as:
- ID.
- English title.
- Amharic title.
- ETB price.
- Image URLs.
- Neighbourhood.
- City.
- Property type.
- Listing purpose.
- Bedrooms.
- Bathrooms.
- Area in square metres.
- Verification status.
- Featured status.
- Amenities.

It also has helpers for primary images, USD conversion, and bedroom labels.

### Known enum mismatch

The Flutter `PropertyType` enum was recorded as:

- apartment
- villa
- house
- land
- commercial
- office

The database enum was recorded as:

- apartment
- villa
- commercial
- land
- office
- warehouse

These do not match.

Resolve this deliberately during backend integration. Do not silently rename values or assume that the existing models are compatible.

### Previous Hive decision

Hive was removed from the cart and wishlist dependency chain because the attempted `hive_generator` dependency conflicted with the existing analyzer/custom-lint dependency constraints.

Cart and wishlist repositories were temporarily replaced with in-memory implementations.

This was a transitional decision, not a commitment to preserve the old e-commerce cart.

Do not reintroduce Hive simply to repair obsolete cart code.

### Localization

Generated localization files are expected under:

`lib/l10n/app_localizations.dart`

The correct import recorded in the history is:

`package:lumo/l10n/app_localizations.dart`

Do not revert to the obsolete `package:flutter_gen/gen_l10n/` path.

# 13. HOW WE WORK TOGETHER

The user prefers a collaborative, deliberate development process.

Do not behave like an AI that immediately generates hundreds of lines of code without understanding the task.

The preferred workflow is:

### Step 1 — Understand

Inspect the existing implementation.

Read relevant files.

Understand dependencies, providers, routes, entities, and existing design components.

### Step 2 — Discuss

When a decision affects:
- Product direction.
- Architecture.
- Database structure.
- UX psychology.
- Security.
- Major dependencies.
- Feature scope.

Discuss it first.

Ask intelligent questions when an important requirement is missing.

The user appreciates thoughtful questions that uncover requirements before implementation.

Do not ask questions whose answers already exist in this handover or the six original prompts.

### Step 3 — Plan

Before implementing a meaningful feature, briefly explain:
- What is currently there.
- What is missing.
- What will change.
- Which files are affected.
- What the expected result will be.

### Step 4 — Execute

Implement the agreed scope.

Preserve working components.

Use the existing architecture.

Avoid unnecessary refactoring.

Do not make unrelated changes while implementing a feature.

### Step 5 — Verify

Run relevant analysis, generation, tests, and build checks.

Do not report success without seeing the actual result.

### Step 6 — Let the user inspect

**Whenever a phase is completed or a meaningful implementation milestone is reached, provide the exact terminal command the user can run to see the result.**

The user explicitly requested this.

For example:

```bash
flutter run
```

Use the appropriate command for the actual platform and project state.

Explain what the user should expect to see.

Wait for feedback when visual or behavioural validation is needed.

### Important execution rules

- One phase at a time.
- No skipping ahead.
- No unapproved redesigns.
- No unnecessary dependency additions.
- No replacing functioning code merely to make it look cleaner.
- No fake implementations presented as completed functionality.
- No destructive database commands without explicit approval.
- No giant code dumps when targeted changes are better.
- Always explain the reason behind important changes.

If the user interrupts, adapt naturally. Do not lose the roadmap.

# 14. THE USER'S DEVELOPMENT ENVIRONMENT

The recorded development environment:

- Linux user.
- Fedora 44.
- Dell Latitude 3420.
- 8 GB RAM.
- VS Code.
- Flutter 3.44.8.
- Dart 3.12.2.
- Firefox.

The historical project location was:

```text
/home/muazk/Documents/INSA/lumo/lumo
```

The environment and path may have changed. Verify them before using commands.

The user is an experienced learner and full-stack developer, familiar with JavaScript, React, Flutter, Supabase, and terminal workflows.

Give practical, precise instructions.

Do not explain basic programming concepts unnecessarily.

# 15. YOUR FIRST TASK — RECONCILIATION, NOT CODING

Before making any code changes, perform a complete project audit.

Do the following:

1. Locate the actual Lumo project.
2. Read all six original master prompts.
3. Inspect `pubspec.yaml`.
4. Inspect the project directory structure.
5. Inspect the design system.
6. Inspect the current entities and providers.
7. Inspect the home, property detail, search, saved, and map screens.
8. Inspect the navigation and routing configuration.
9. Inspect authentication and inquiry functionality.
10. Inspect the existing localization implementation.
11. Inspect the current Supabase configuration without exposing credentials.
12. Check Git status and recent commits if available.
13. Run Flutter analysis and identify all current errors.
14. Run the relevant build checks.

Before modifying anything, establish a safe recovery point if the project is under Git or create an appropriate backup.

Do not overwrite or delete anything during the initial audit.

Then produce a concise but substantive report:

**A. What is genuinely working?**

**B. What exists but is incomplete?**

**C. What is broken?**

**D. What does not follow the original architecture?**

**E. Which phase are we actually in?**

**F. What is the exact next implementation task?**

**G. What is the safest next step?**

Compare the actual project against the seven-phase roadmap.

Do not blindly trust this historical summary. It describes the previous state, not necessarily the current filesystem.

Do not begin Phase 5 simply because an earlier conversation called it next.

The latest recorded development work was implementing the Phase 3 map and repairing related analysis errors. The final full-project verification was interrupted.

The correct next step is to verify that work and continue from the actual state.

# 16. THE STANDARD

I want Lumo to feel like a company that has invested serious thought into every pixel, interaction, and business decision.

I want the engineering to be as good as the design.

I want the psychology to be as good as the engineering.

I want the user to feel safe exploring a property in Ethiopia while sitting in another country.

I want the broker experience to feel professional.

I want the Lumo team to have genuine control over quality.

I want the product to be technically maintainable and ready for real users.

Do not optimize for the appearance of progress.

Optimize for real progress.

When something is wrong, say so directly.

When a previous implementation is poor, explain why and propose a proper correction.

When a decision is uncertain, do not pretend certainty.

When a feature is incomplete, call it incomplete.

**The user values honest engineering, thoughtful product decisions, and exceptional execution more than fast but superficial output.**

---

# FINAL DIRECTIVE

You are inheriting Lumo, not inventing it.

Preserve the six foundational prompts.

Preserve the approved real-estate vision.

Preserve the seven-phase roadmap.

Preserve the work that is already good.

Correct the work that is incomplete.

Do not repeat the previous roadmap drift.

Do not connect every feature to Supabase prematurely.

Do not confuse a successful build with a completed product.

Start by auditing the actual repository and reporting the truth.

Then continue, phase by phase.

**Let's build Lumo properly.**