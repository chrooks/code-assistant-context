# UI/UX Frontend Style Guide Reference

## Purpose & Overview

This document provides a comprehensive reference for generating professional UI/UX frontend style guides. It synthesizes industry best practices from major design systems (Material Design, IBM Carbon, Atlassian, Shopify Polaris, USWDS) and expert research to inform the creation of optimal style guide documentation for development teams.

---

## Document Structure & Organization

A professional style guide should be organized into the following hierarchical sections:

### 1. Foundations (Design Tokens & Core Values)
### 2. Visual Identity (Brand, Color, Typography)
### 3. Spacing & Layout Systems
### 4. Component Library
### 5. Patterns & Templates
### 6. Accessibility Guidelines
### 7. Content & Voice Guidelines
### 8. Implementation Notes

---

## 1. Foundations: Design Tokens

Design tokens are the atomic building blocks of a design system—platform-agnostic key-value pairs representing design decisions.

### Token Categories

```
├── Color Tokens
│   ├── Primitive (raw values): --color-blue-500: #3B82F6
│   └── Semantic (purpose-based): --color-primary: var(--color-blue-500)
├── Typography Tokens
│   ├── Font Family: --font-family-base, --font-family-heading
│   ├── Font Size: --font-size-xs through --font-size-4xl
│   ├── Font Weight: --font-weight-regular, --font-weight-bold
│   └── Line Height: --line-height-tight, --line-height-normal, --line-height-relaxed
├── Spacing Tokens
│   └── Scale: --space-1 (4px) through --space-16 (64px)
├── Border Tokens
│   ├── Radius: --radius-sm, --radius-md, --radius-lg, --radius-full
│   └── Width: --border-width-thin, --border-width-thick
├── Shadow Tokens
│   └── Elevation: --shadow-sm, --shadow-md, --shadow-lg, --shadow-xl
└── Animation Tokens
    ├── Duration: --duration-fast, --duration-normal, --duration-slow
    └── Easing: --ease-in, --ease-out, --ease-in-out
```

### Token Naming Convention

Use a consistent structure: `{category}-{property}-{variant}-{state}`

```css
/* Examples */
--color-background-primary-default
--color-background-primary-hover
--color-text-secondary-disabled
--button-background-primary-active
```

### Token Implementation (CSS Variables)

```css
:root {
  /* Primitive Tokens */
  --color-blue-50: #EFF6FF;
  --color-blue-500: #3B82F6;
  --color-blue-700: #1D4ED8;
  --color-gray-50: #F9FAFB;
  --color-gray-900: #111827;
  
  /* Semantic Tokens */
  --color-primary: var(--color-blue-500);
  --color-primary-hover: var(--color-blue-700);
  --color-background: var(--color-gray-50);
  --color-text: var(--color-gray-900);
  
  /* Component Tokens */
  --button-bg-primary: var(--color-primary);
  --button-bg-primary-hover: var(--color-primary-hover);
}
```

---

## 2. Color System

### Color Palette Structure

#### Primary Colors
- **Brand color**: Main identifying color (1-2 colors maximum)
- Used for: Primary buttons, links, key UI accents, focus states

#### Secondary Colors  
- **Accent colors**: Complement primary palette
- Used for: Secondary buttons, highlights, promotional elements

#### Semantic Colors
| Purpose | Token Name | Typical Hue | Usage |
|---------|------------|-------------|-------|
| Success | `--color-success` | Green | Confirmations, completed states |
| Warning | `--color-warning` | Yellow/Amber | Alerts, caution states |
| Error | `--color-error` | Red | Errors, destructive actions |
| Info | `--color-info` | Blue | Informational messages |

#### Neutral Colors
- **Grayscale palette**: 9-11 shades from near-white to near-black
- Used for: Text, backgrounds, borders, disabled states

```css
/* Neutral Scale Example */
--color-neutral-50: #FAFAFA;   /* Lightest background */
--color-neutral-100: #F5F5F5;
--color-neutral-200: #E5E5E5;
--color-neutral-300: #D4D4D4;
--color-neutral-400: #A3A3A3;
--color-neutral-500: #737373;  /* Placeholder text */
--color-neutral-600: #525252;
--color-neutral-700: #404040;  /* Secondary text */
--color-neutral-800: #262626;
--color-neutral-900: #171717;  /* Primary text */
```

### Color Accessibility Requirements

| Contrast Requirement | Ratio | WCAG Level |
|---------------------|-------|------------|
| Normal text (< 18pt) | 4.5:1 | AA |
| Large text (≥ 18pt or 14pt bold) | 3:1 | AA |
| UI components & graphics | 3:1 | AA |
| Enhanced contrast | 7:1 | AAA |

### Dark Mode Considerations

- Map semantic tokens to different primitives per theme
- Never invert colors directly; use purpose-designed dark palette
- Maintain contrast ratios in both modes

---

## 3. Typography System

### Type Scale

Use a consistent scale based on modular ratios or 4px increments:

| Token | Size | Line Height | Usage |
|-------|------|-------------|-------|
| `--font-size-xs` | 12px | 16px | Labels, captions |
| `--font-size-sm` | 14px | 20px | Secondary text |
| `--font-size-base` | 16px | 24px | Body text |
| `--font-size-lg` | 18px | 28px | Lead paragraphs |
| `--font-size-xl` | 20px | 28px | H4 headings |
| `--font-size-2xl` | 24px | 32px | H3 headings |
| `--font-size-3xl` | 30px | 36px | H2 headings |
| `--font-size-4xl` | 36px | 40px | H1 headings |
| `--font-size-5xl` | 48px | 48px | Display headings |

### Font Families

```css
:root {
  --font-family-sans: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
  --font-family-serif: 'Georgia', 'Times New Roman', serif;
  --font-family-mono: 'JetBrains Mono', 'Fira Code', 'Consolas', monospace;
}
```

### Font Weights

| Token | Weight | Usage |
|-------|--------|-------|
| `--font-weight-regular` | 400 | Body text |
| `--font-weight-medium` | 500 | Emphasis, labels |
| `--font-weight-semibold` | 600 | Subheadings |
| `--font-weight-bold` | 700 | Headings, strong emphasis |

### Typography Best Practices

- **Line height**: Use 1.5 (150%) for body text; tighter (1.2-1.3) for headings
- **Line length**: 45-75 characters optimal for readability
- **Paragraph spacing**: Use `margin-bottom` equal to line-height
- **Heading hierarchy**: Never skip heading levels (H1 → H2 → H3)

---

## 4. Spacing & Layout System

### 8px Grid System

The 8px grid is the industry standard for consistent spacing:

| Token | Value | Usage |
|-------|-------|-------|
| `--space-0` | 0px | Reset |
| `--space-1` | 4px | Tight spacing, icons |
| `--space-2` | 8px | Inline elements |
| `--space-3` | 12px | Related elements |
| `--space-4` | 16px | Standard gap |
| `--space-5` | 20px | Card padding |
| `--space-6` | 24px | Section spacing |
| `--space-8` | 32px | Large gaps |
| `--space-10` | 40px | Section margins |
| `--space-12` | 48px | Major sections |
| `--space-16` | 64px | Page sections |

### Spacing Principles

1. **Internal ≤ External Rule**: Space within components should be less than space between components (Gestalt proximity principle)
2. **Consistent increments**: Use only values from your spacing scale
3. **Typography alignment**: Ensure line heights are divisible by 4 for grid alignment

### Layout Grid

```css
/* 12-Column Grid System */
.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 var(--space-6);
}

.grid {
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  gap: var(--space-6); /* 24px gutter */
}
```

### Breakpoints

| Token | Width | Target |
|-------|-------|--------|
| `--breakpoint-sm` | 640px | Mobile landscape |
| `--breakpoint-md` | 768px | Tablet |
| `--breakpoint-lg` | 1024px | Desktop |
| `--breakpoint-xl` | 1280px | Large desktop |
| `--breakpoint-2xl` | 1536px | Wide screens |

---

## 5. Component Documentation

### Component Documentation Template

Each component should include:

```markdown
## Component Name

### Description
Brief explanation of purpose and when to use.

### Anatomy
Visual breakdown of component parts with labels.

### Variants
- Default
- Primary / Secondary / Tertiary
- Sizes (sm, md, lg)
- States (enabled, hover, focus, active, disabled, loading)

### Props / API
| Prop | Type | Default | Description |
|------|------|---------|-------------|
| variant | string | 'default' | Visual style variant |
| size | string | 'md' | Component size |
| disabled | boolean | false | Disable interaction |

### States
Document all interactive states with visual examples.

### Accessibility
- Keyboard navigation
- ARIA attributes
- Screen reader behavior

### Usage Guidelines
- Do's and Don'ts
- Best practices
- Common patterns

### Code Examples
```jsx
<Button variant="primary" size="md">
  Click me
</Button>
```
```

### Component States

Every interactive component must define these states:

| State | Description | Visual Treatment |
|-------|-------------|-----------------|
| **Default/Rest** | Initial appearance | Base styling |
| **Hover** | Mouse over (desktop only) | Subtle color shift, slight elevation |
| **Focus** | Keyboard navigation | Visible outline (2px+, 3:1 contrast) |
| **Active/Pressed** | During click/tap | Darker shade, slight depression |
| **Disabled** | Unavailable | Reduced opacity (40-50%), no pointer events |
| **Loading** | Processing action | Spinner, disabled interaction |
| **Selected** | Chosen option | Checkmark, filled background |
| **Error** | Invalid state | Red border, error message |

### Common Components Checklist

- [ ] Button (primary, secondary, tertiary, icon, ghost)
- [ ] Input (text, number, password, search, textarea)
- [ ] Select / Dropdown
- [ ] Checkbox / Radio / Toggle
- [ ] Card
- [ ] Modal / Dialog
- [ ] Toast / Notification
- [ ] Navigation (navbar, sidebar, tabs, breadcrumbs)
- [ ] Table
- [ ] Pagination
- [ ] Tooltip
- [ ] Avatar
- [ ] Badge / Tag
- [ ] Progress indicators (bar, spinner)
- [ ] Accordion
- [ ] Alert / Banner

---

## 6. Accessibility Requirements

### WCAG 2.2 Compliance Checklist

#### Perceivable
- [ ] Color contrast meets 4.5:1 for text, 3:1 for UI
- [ ] Text can be resized up to 200% without loss
- [ ] Images have meaningful alt text
- [ ] Videos have captions/transcripts

#### Operable  
- [ ] All functionality available via keyboard
- [ ] Focus indicators visible (3:1 contrast, 2px minimum)
- [ ] No keyboard traps
- [ ] Skip links provided
- [ ] Target size minimum 24x24 CSS pixels

#### Understandable
- [ ] Language of page specified
- [ ] Navigation consistent across pages
- [ ] Error messages descriptive and helpful

#### Robust
- [ ] Valid HTML structure
- [ ] ARIA used correctly when needed
- [ ] Compatible with assistive technologies

### Focus State Requirements

```css
/* Minimum focus indicator */
:focus-visible {
  outline: 2px solid var(--color-primary);
  outline-offset: 2px;
}

/* Never remove focus without replacement */
:focus {
  outline: none; /* ❌ NEVER do this alone */
}
```

### ARIA Best Practices

```html
<!-- Accessible button -->
<button 
  type="button"
  aria-pressed="false"
  aria-label="Toggle dark mode"
>
  <svg aria-hidden="true">...</svg>
</button>

<!-- Accessible form -->
<label for="email">Email address</label>
<input 
  id="email" 
  type="email" 
  aria-required="true"
  aria-describedby="email-hint email-error"
/>
<span id="email-hint">We'll never share your email.</span>
<span id="email-error" role="alert" aria-live="polite"></span>
```

---

## 7. Content Guidelines

### Voice & Tone

| Attribute | Definition | Example |
|-----------|------------|---------|
| Clear | Avoid jargon, be direct | "Save changes" not "Persist modifications" |
| Concise | Use minimum words needed | "Email required" not "Please enter your email address" |
| Helpful | Guide users to success | Include what to do, not just what went wrong |
| Human | Conversational but professional | "Something went wrong" not "Error 500" |

### Microcopy Standards

| Element | Guidelines | Example |
|---------|------------|---------|
| Buttons | Action verbs, 1-3 words | "Save", "Create account", "Delete" |
| Labels | Noun or short phrase | "Email address", "Password" |
| Placeholders | Example format only | "name@example.com" |
| Error messages | Explain + solve | "Password must be 8+ characters. Add numbers or symbols." |
| Empty states | Helpful, guide next action | "No results found. Try adjusting your search terms." |

---

## 8. Implementation Notes

### CSS Architecture

Recommended structure:
```
styles/
├── tokens/
│   ├── colors.css
│   ├── typography.css
│   ├── spacing.css
│   └── index.css
├── base/
│   ├── reset.css
│   └── global.css
├── components/
│   ├── button.css
│   ├── input.css
│   └── ...
├── layouts/
│   └── grid.css
└── utilities/
    └── helpers.css
```

### Naming Convention: BEM + Tokens

```css
/* Block__Element--Modifier pattern */
.button { }
.button--primary { }
.button--disabled { }
.button__icon { }
.button__label { }

/* Token-based values */
.button {
  padding: var(--space-2) var(--space-4);
  font-size: var(--font-size-sm);
  border-radius: var(--radius-md);
  background: var(--button-bg-primary);
}
```

### Version Control & Change Management

- Document breaking changes
- Use semantic versioning
- Maintain changelog
- Deprecation notices for removed features

---

## Quick Reference: Token Naming Cheatsheet

```
Category        Examples
─────────────────────────────────────────
Colors          --color-{name}-{shade}
                --color-{semantic}-{variant}
Typography      --font-{property}-{value}
Spacing         --space-{scale-number}
Borders         --border-{property}-{value}
                --radius-{size}
Shadows         --shadow-{size}
Transitions     --duration-{speed}
                --ease-{type}
Z-index         --z-{layer-name}
Components      --{component}-{property}-{variant}-{state}
```

---

## Resources & References

- Material Design 3: https://m3.material.io
- IBM Carbon Design System: https://carbondesignsystem.com
- Atlassian Design System: https://atlassian.design
- US Web Design System: https://designsystem.digital.gov
- WCAG 2.2 Guidelines: https://www.w3.org/WAI/standards-guidelines/wcag/
- Design Tokens Format: https://design-tokens.github.io/community-group/format/

---

*This reference document synthesizes best practices from industry-leading design systems to guide the creation of comprehensive, maintainable, and accessible frontend style guides.*
