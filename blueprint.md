# FitCore App Blueprint

## Overview

This document outlines the design, features, and implementation plan for the FitCore mobile application. The goal is to create a premium, dark-first fitness application with a focus on user experience, clear navigation, and purposeful design.

## Style, Design, and Features

### Core Philosophy
- Users should never feel lost — and should always feel elevated.
- Dark-first, emotionally warm aesthetic.
- Deep layering + subtle glassmorphism (overlays only).
- Purposeful micro-animations & haptics (no decoration).
- One clear primary action per screen.
- Predictable global elements (Settings ⚙️ always top-right).
- Thumb-zone priority for CTAs and frequent actions.

### Design System (Winning Palette & Rules)

#### Colors
- **Background**: `#0A0A0E`
- **Surface**: `#13131A`
- **Surface Elevated**: `#1C1C26`
- **Accent Violet**: `#8B6FFF` (brand primary)
- **Accent Coral**: `#FF5F3D` (CTA, live progress, energy)
- **Accent Amber**: `#FFB547` (challenges, warm alerts)
- **Success**: `#3DDC97`
- **Danger**: `#FF4D6D`
- **Text Primary**: `#F0F0F5`
- **Text Secondary**: `#72728A`
- **Border Subtle**: `#22222E`

#### Typography
- **Font**: Google Sans (Android) / SF Pro (iOS) - *Implementation will use a similar font from `google_fonts` like `Manrope`.*
- **Display Huge**: 700 · 36px
- **Heading**: 600 · 22px
- **Subheading**: 600 · 17px
- **Body**: 400 · 15px
- **Caption**: 400 · 12px

#### Component Rules
- **Cards**: 24px radius, 20px padding, 1px subtle border, soft depth via color layering (no hard shadows).
- **Primary Button**: Coral `#FF5F3D`, 54px height, 16px radius, bold 600.
- **Ghost Button**: 1px Violet border, Violet text.
- **Chips**: full pill shape, selected = light Violet bg + Violet text.
- **Bottom Sheet**: 28px top radius, frosted blur, small handle.
- **Bottom Nav**: Surface + blur, active = thin glowing Violet bar under icon.

### Animation & Haptics
- **Screen push**: slide + fade 280ms ease-out
- **Accordion expand**: height 220ms ease
- **Set tick**: micro-bounce 150ms + light haptic
- **Timer end**: pulse ring + medium haptic pattern
- **Badge earned**: scale + small confetti 600ms + medium haptic
- **Bottom sheet**: spring 300ms

---

## Current Plan: Initial Setup & Theming

**Objective**: Implement the core visual theme based on the FitCore design system.

**Steps**:
1.  **Add Dependencies**: Add `google_fonts` and `provider` packages to `pubspec.yaml`.
2.  **Create Theme Provider**: Implement `ThemeProvider` to manage and toggle between dark, light, and system themes.
3.  **Define Color Scheme**: Create a `ColorScheme` for the dark theme using the specified "Winning Palette".
4.  **Define Typography**: Create a `TextTheme` using `google_fonts` (`Manrope`) with the specified font sizes and weights.
5.  **Implement `ThemeData`**: Configure `ThemeData` for the dark theme, applying the color scheme, text theme, and component styles (e.g., `elevatedButtonTheme`).
6.  **Integrate Theme**: Update `main.dart` to use `ChangeNotifierProvider` and apply the theme to the `MaterialApp`.
7.  **Build Demo UI**: Create a simple home page that showcases the theme, including text styles, a primary button, and theme toggle controls in the `AppBar`.
