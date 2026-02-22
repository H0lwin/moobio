# FitCore App Blueprint

## Overview
FitCore is a premium training app with a dark-first, emotionally warm interface designed for clarity, confidence, and momentum. Every screen should feel intentional, with one dominant action and predictable global structure.

## Style, Design, and Features

### 🧭 Core Philosophy
- Users should never feel lost and should always feel elevated.
- Dark-first, emotionally warm aesthetic.
- Deep layering plus subtle glassmorphism (overlays only).
- Purposeful micro-animations and haptics (no decoration).
- One clear primary action per screen.
- Predictable global elements (Settings `⚙️` always top-right).
- Thumb-zone priority for CTAs and frequent actions.

### 🎨 Design System (Winning Palette & Rules)

#### Colors
- Background: `#0A0A0E`
- Surface: `#13131A`
- Surface Elevated: `#1C1C26`
- Accent Violet: `#8B6FFF` (brand primary)
- Accent Coral: `#FF5F3D` (CTA, live progress, energy)
- Accent Amber: `#FFB547` (challenges, warm alerts)
- Success: `#3DDC97`
- Danger: `#FF4D6D`
- Text Primary: `#F0F0F5`
- Text Secondary: `#72728A`
- Border Subtle: `#22222E`

#### Typography
- Font: SF Pro (iOS) / Google Sans (Android)
- Display Huge: `700 / 36px`
- Heading: `600 / 22px`
- Subheading: `600 / 17px`
- Body: `400 / 15px`
- Caption: `400 / 12px`

#### Component Rules
- Cards: `24px` radius, `20px` padding, `1px` subtle border, depth via layered color (no hard shadows).
- Primary Button: Coral `#FF5F3D`, `54px` height, `16px` radius, weight `600`.
- Ghost Button: `1px` Violet border with Violet text.
- Chips: full pill shape; selected state uses light Violet background plus Violet text.
- Bottom Sheet: `28px` top radius, frosted blur, small handle.
- Bottom Nav: Surface plus blur; active item has a thin glowing Violet bar under icon.

### Animation & Haptics
- Screen push: slide plus fade, `280ms`, ease-out.
- Accordion expand: height transition, `220ms`, ease.
- Set tick: micro-bounce, `150ms` plus light haptic.
- Timer end: pulse ring plus medium haptic pattern.
- Badge earned: scale plus small confetti, `600ms` plus medium haptic.
- Bottom sheet: spring transition, `300ms`.

### 🧭 Global Navigation

#### Bottom Navigation (4 Items Only)
- `⌂` Home (Dashboard)
- `◈` Train (Workout Hub)
- `∿` Club (Club Hub)
- `📊` Progress (Analytics)

Active tab behavior:
- Thin glowing Violet bar under icon.
- Active icon tinted Violet.

#### Global Header (Fixed Across App)
- Left: `[← or small Club Logo]`
- Center: `Page Title / Context`
- Right: `[🔔 with badge] [⚙️]`

Rules:
- Home shows a small elegant logo on the left.
- Sub-pages show a back arrow and parent page name in title context.
- `🔔` always shows a red dot when unread items exist.
- `⚙️` is always top-right and routes to Settings & Profile.

### ⚙️ Settings & Profile Screen

#### Hero Block
- Gradient from Accent Violet into background.
- Large circular avatar with glowing ring.
- Name plus level line (example: `Intermediate · 2 Years`).
- Ghost `Edit Profile` button.

#### Sections
Use small gray section headers and clean spacing (no hard divider lines).

ACCOUNT:
- Personal Info
- Health & Medical
- Sports & Fitness Goals
- Nutrition Preferences

PREFERENCES:
- Notifications
- Privacy
- Sound & Vibration
- Appearance (Dark / Light / System toggle)

SUPPORT:
- Help & FAQ
- Contact Support
- Rate FitCore

ABOUT:
- Terms of Service
- Privacy Policy
- Version `2.1.0` (gray caption style)

Footer actions:
- Log Out (orange text)
- Delete Account (muted red, double confirmation required)

### 📱 Home (Dashboard): Energy and Glanceability

#### Hero Card: Today's Workout
- Largest visual block on the screen.
- Gradient accent background.
- Title: `PUSH DAY` in bold display style.
- Target muscle chips.
- Circular progress arc for today's completion percentage.
- Primary CTA: `Start Workout`

## Current Plan: Implement This Blueprint

Objective: Build the app shell and first-pass UI to match this system exactly.

Steps:
1. Create centralized theme tokens for all colors, typography scales, spacing, radii, and component states.
2. Implement global scaffold with fixed header behavior and 4-item bottom navigation with active glow indicator.
3. Build Home dashboard hero card with gradient, chips, progress arc, and single primary CTA.
4. Build Settings & Profile screen with hero block, structured section lists, appearance controls, and footer actions.
5. Add motion primitives and haptic hooks for push, accordion, set tick, timer end, badge earned, and bottom sheet.
6. Validate thumb-zone CTA placement and ensure each screen has only one dominant primary action.
