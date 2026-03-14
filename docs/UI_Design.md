# BEST SOLO - UI/UX Design Document

## 1. Design System Overview

### 1.1 Brand Identity

| Element | Value |
|---------|-------|
| Brand Name | BEST SOLO |
| Tagline | Elegant Fashion, Exceptional Style |
| Industry | Boutique Fashion E-Commerce |
| Target Audience | Fashion-conscious individuals aged 18-45 |
| Brand Personality | Modern, Elegant, Trustworthy, Premium |

---

## 2. Color Palette

### 2.1 Primary Colors

| Color Name | Hex Code | RGB | Usage |
|------------|----------|-----|-------|
| Primary Green | #1FAF5A | 31, 175, 90 | Primary buttons, links, accents |
| Primary Dark | #158045 | 21, 128, 69 | Button hover, active states |
| Primary Light | #E8F5EA | 232, 245, 234 | Backgrounds, highlights |

### 2.2 Neutral Colors

| Color Name | Hex Code | RGB | Usage |
|------------|----------|-----|-------|
| White | #FFFFFF | 255, 255, 255 | Background, cards |
| Black | #000000 | 0, 0, 0 | Primary text |
| Dark Gray | #333333 | 51, 51, 51 | Headings, emphasis |
| Medium Gray | #666666 | 102, 102, 102 | Secondary text |
| Light Gray | #F5F5F5 | 245, 245, 245 | Backgrounds, borders |
| Border Gray | #E0E0E0 | 224, 224, 224 | Borders, dividers |
| Disabled Gray | #BDBDBD | 189, 189, 189 | Disabled states |

### 2.3 Semantic Colors

| Color Name | Hex Code | Usage |
|------------|----------|-------|
| Success Green | #4CAF50 | Success messages, in-stock |
| Warning Yellow | #FFC107 | Low stock, warnings |
| Error Red | #F44336 | Errors, out of stock |
| Info Blue | #2196F3 | Information, links |

### 2.4 Color Usage Guidelines

```
┌─────────────────────────────────────────────────────────────────┐
│                        COLOR USAGE MAP                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Primary Actions    →  #1FAF5A (Primary Green)                  │
│  Secondary Actions →  #F5F5F5 (Light Gray)                      │
│  Text Primary      →  #000000 (Black)                          │
│  Text Secondary    →  #666666 (Medium Gray)                     │
│  Background        →  #FFFFFF (White)                          │
│  Borders           →  #E0E0E0 (Border Gray)                     │
│  Error States      →  #F44336 (Error Red)                      │
│  Success States    →  #4CAF50 (Success Green)                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 3. Typography

### 3.1 Font Families

| Font | Purpose | Weights |
|------|---------|---------|
| Poppins | Headings, Titles, Logo | 400, 500, 600, 700 |
| Inter | Body text, UI elements | 400, 500, 600 |

### 3.2 Font Sizes

| Style | Font | Size | Line Height | Letter Spacing |
|-------|------|------|-------------|-----------------|
| Display 1 | Poppins | 48px | 1.2 | -0.5px |
| Display 2 | Poppins | 36px | 1.25 | -0.25px |
| H1 | Poppins | 32px | 1.3 | 0 |
| H2 | Poppins | 28px | 1.35 | 0 |
| H3 | Poppins | 24px | 1.4 | 0 |
| H4 | Poppins | 20px | 1.4 | 0 |
| H5 | Poppins | 18px | 1.4 | 0 |
| H6 | Poppins | 16px | 1.4 | 0 |
| Body Large | Inter | 18px | 1.6 | 0.15px |
| Body | Inter | 16px | 1.6 | 0.15px |
| Body Small | Inter | 14px | 1.5 | 0.1px |
| Caption | Inter | 12px | 1.4 | 0.4px |
| Button | Inter | 14px | 1 | 0.5px |

### 3.3 Typography Scale

```css
/* Display Styles */
.display-1 {
  font-family: 'Poppins', sans-serif;
  font-size: 48px;
  font-weight: 700;
  line-height: 1.2;
  letter-spacing: -0.5px;
}

.display-2 {
  font-family: 'Poppins', sans-serif;
  font-size: 36px;
  font-weight: 600;
  line-height: 1.25;
  letter-spacing: -0.25px;
}

/* Heading Styles */
h1 {
  font-family: 'Poppins', sans-serif;
  font-size: 32px;
  font-weight: 600;
  line-height: 1.3;
}

h2 {
  font-family: 'Poppins', sans-serif;
  font-size: 28px;
  font-weight: 600;
  line-height: 1.35;
}

h3 {
  font-family: 'Poppins', sans-serif;
  font-size: 24px;
  font-weight: 500;
  line-height: 1.4;
}

h4 {
  font-family: 'Poppins', sans-serif;
  font-size: 20px;
  font-weight: 500;
  line-height: 1.4;
}

/* Body Styles */
body-large {
  font-family: 'Inter', sans-serif;
  font-size: 18px;
  font-weight: 400;
  line-height: 1.6;
}

body {
  font-family: 'Inter', sans-serif;
  font-size: 16px;
  font-weight: 400;
  line-height: 1.6;
}

body-small {
  font-family: 'Inter', sans-serif;
  font-size: 14px;
  font-weight: 400;
  line-height: 1.5;
}

caption {
  font-family: 'Inter', sans-serif;
  font-size: 12px;
  font-weight: 400;
  line-height: 1.4;
}
```

---

## 4. Spacing System

### 4.1 Base Unit
- **Base unit**: 4px
- **Scale**: 4, 8, 12, 16, 20, 24, 32, 40, 48, 64, 80, 96, 128

### 4.2 Spacing Scale

| Token | Value | Usage |
|-------|-------|-------|
| xs | 4px | Tight spacing, icon gaps |
| sm | 8px | Compact elements |
| md | 16px | Standard padding |
| lg | 24px | Section spacing |
| xl | 32px | Large gaps |
| 2xl | 48px | Section separators |
| 3xl | 64px | Major sections |
| 4xl | 96px | Page spacing |

### 4.3 Layout Spacing

| Context | Padding | Margin |
|---------|---------|--------|
| Container max-width | 1440px | - |
| Container padding | 24px (mobile), 48px (desktop) | - |
| Card padding | 16px | - |
| Section spacing | - | 64px |
| Grid gap | 24px | - |

---

## 5. Responsive Breakpoints

### 5.1 Breakpoints

| Name | Width | Target |
|------|-------|--------|
| xs | 0-479px | Small mobile |
| sm | 480-767px | Mobile |
| md | 768-1023px | Tablet |
| lg | 1024-1279px | Small desktop |
| xl | 1280-1535px | Desktop |
| 2xl | 1536px+ | Large desktop |

### 5.2 Layout Containers

```dart
// Container widths by breakpoint
const containerWidths = {
  'xs': 100%,        // Full width on mobile
  'sm': 480px,       // Small devices
  'md': 720px,       // Tablets
  'lg': 960px,       // Small laptops
  'xl': 1140px,      // Standard desktops
  '2xl': 1320px,     // Large desktops
};
```

---

## 6. Components

### 6.1 Buttons

#### Primary Button
```
Height: 48px (default), 40px (small), 56px (large)
Padding: 24px horizontal
Border Radius: 8px
Background: #1FAF5A
Text: #FFFFFF, Inter, 14px, 600 weight
Hover: Background #158045
Active: Background #126e3a
Disabled: Background #BDBDBD, Text #666666
```

#### Secondary Button
```
Height: 48px
Padding: 24px horizontal
Border Radius: 8px
Background: #F5F5F5
Border: 1px solid #E0E0E0
Text: #333333, Inter, 14px, 600 weight
Hover: Background #E0E0E0
```

#### Outline Button
```
Height: 48px
Padding: 24px horizontal
Border Radius: 8px
Background: transparent
Border: 2px solid #1FAF5A
Text: #1FAF5A, Inter, 14px, 600 weight
Hover: Background #1FAF5A, Text #FFFFFF
```

#### Text Button
```
Height: auto
Padding: 8px 16px
Background: transparent
Text: #1FAF5A, Inter, 14px, 600 weight
Hover: Underline
```

### 6.2 Input Fields

#### Text Input
```
Height: 48px
Padding: 12px 16px
Border Radius: 8px
Border: 1px solid #E0E0E0
Background: #FFFFFF
Text: #000000, Inter, 16px
Placeholder: #BDBDBD
Focus: Border #1FAF5A, Box Shadow 0 0 0 3px rgba(31, 175, 90, 0.1)
Error: Border #F44336
Disabled: Background #F5F5F5
```

### 6.3 Cards

#### Product Card
```
Border Radius: 12px
Background: #FFFFFF
Border: 1px solid #E0E0E0
Shadow: 0 2px 8px rgba(0, 0, 0, 0.04)
Hover Shadow: 0 8px 24px rgba(0, 0, 0, 0.08)
Transition: 300ms ease
Padding: 0 (image flush)
Content Padding: 16px
Image Aspect Ratio: 4:5
```

### 6.4 Navigation

#### Header (Desktop)
```
Height: 80px
Background: #FFFFFF
Border Bottom: 1px solid #E0E0E0
Logo: Left aligned
Nav Links: Center
Actions: Right (search, cart, account)
```

#### Mobile Navigation
```
Height: 64px
Background: #FFFFFF
Border Top: 1px solid #E0E0E0
Items: Home, Categories, Search, Cart, Account
Icon Size: 24px
Label: 12px
```

### 6.5 Badges

#### Stock Badge
```
Border Radius: 4px
Padding: 4px 8px
Font: Inter, 12px, 500 weight

Variants:
- In Stock: Background #E8F5EA, Text #4CAF50
- Low Stock: Background #FFF8E1, Text #FFC107
- Out of Stock: Background #FFEBEE, Text #F44336
```

#### Status Badge
```
Border Radius: 20px
Padding: 4px 12px

Variants:
- Pending: Background #FFF3E0, Text #FF9800
- Processing: Background #E3F2FD, Text #2196F3
- Shipped: Background #E8F5EA, Text #4CAF50
- Delivered: Background #E8F5EA, Text #1FAF5A
- Cancelled: Background #FFEBEE, Text #F44336
```

---

## 7. Customer Storefront Pages

### 7.1 Layout Structure

#### Home Page
```
┌─────────────────────────────────────────────────────────────────┐
│ HEADER                                                          │
│ ┌─────────────────────────────────────────────────────────────┐│
│ │ Logo │ Navigation │ Search │ Cart │ Account                 ││
│ └─────────────────────────────────────────────────────────────┘│
├─────────────────────────────────────────────────────────────────┤
│ HERO BANNER                                                     │
│ ┌─────────────────────────────────────────────────────────────┐│
│ │ Full-width image slider with CTA buttons                    ││
│ │ Height: 500px (desktop), 350px (mobile)                     ││
│ └─────────────────────────────────────────────────────────────┘│
├─────────────────────────────────────────────────────────────────┤
│ CATEGORIES                                                      │
│ ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐                           │
│ │   │ │   │ │   │ │   │ │   │ │   │  Category Cards          │
│ │ 1 │ │ 2 │ │ 3 │ │ 4 │ │ 5 │ │ 6 │  (scrollable on mobile) │
│ └───┘ └───┘ └───┘ └───┘ └───┘ └───┘                           │
├─────────────────────────────────────────────────────────────────┤
│ FEATURED PRODUCTS                                               │
│ ┌─────────────────────────────────────────────────────────────┐│
│ │ Section Title: "Featured Products"                         ││
│ │ Horizontal scrollable product grid                         ││
│ └─────────────────────────────────────────────────────────────┘│
├─────────────────────────────────────────────────────────────────┤
│ NEW ARRIVALS                                                    │
│ ┌─────────────────────────────────────────────────────────────┐│
│ │ Section Title: "New Arrivals"                              ││
│ │ 4-column grid (desktop), 2-column (mobile)                ││
│ └─────────────────────────────────────────────────────────────┘│
├─────────────────────────────────────────────────────────────────┤
│ FOOTER                                                          │
│ ┌─────────────────────────────────────────────────────────────┐│
│ │ About │ Categories │ Customer Service │ Newsletter          ││
│ │ Social Links │ Copyright                                    ││
│ └─────────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
```

### 7.2 Product Listing Page (PLP)

```
┌─────────────────────────────────────────────────────────────────┐
│ HEADER                                                          │
├─────────────────────────────────────────────────────────────────┤
│ BREADCRUMB                                                      │
│ Home > Category > Subcategory                                  │
├──────────────┬──────────────────────────────────────────────────┤
│ FILTERS       │ PRODUCTS                                        │
│               │                                                  │
│ Categories   │ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐      │
│ ├ Dresses     │ │        │ │        │ │        │ │        │      │
│ ├ Shoes       │ │  Card  │ │  Card  │ │  Card  │ │  Card  │      │
│ └ Bags        │ │        │ │        │ │        │ │        │      │
│               │ └────────┘ └────────┘ └────────┘ └────────┘      │
│ Price Range   │                                                  │
│ [====----]    │ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐      │
│               │ │        │ │        │ │        │ │        │      │
│ Colors        │ │  Card  │ │  Card  │ │  Card  │ │  Card  │      │
│ ○ ○ ○ ○       │ │        │ │        │ │        │ │        │      │
│               │ └────────┘ └────────┘ └────────┘ └────────┘      │
│ Sizes         │                                                  │
│ □ S □ M □ L   │ Sort: [Newest ▼]  Page 1 of 10  [< 1 2 3 >]    │
│               │                                                  │
├──────────────┴──────────────────────────────────────────────────┤
│ FOOTER                                                          │
└─────────────────────────────────────────────────────────────────┘
```

### 7.3 Product Detail Page (PDP)

```
┌─────────────────────────────────────────────────────────────────┐
│ HEADER                                                          │
├─────────────────────────────────────────────────────────────────┤
│ BREADCRUMB                                                      │
│ Home > Dresses > Evening Dresses > Product Name                 │
├──────────────────────────────┬──────────────────────────────────┤
│ IMAGE GALLERY                   │ PRODUCT INFO                   │
│ ┌────────────────────────────┐ │                                 │
│ │                            │ │ Product Name                   │
│ │     Main Image             │ │ ════════════════════════════   │
│ │     (zoomable)             │ │                                │
│ │                            │ │ ★★★★☆ (124 reviews)           │
│ └────────────────────────────┘ │                                │
│ ┌──┐ ┌──┐ ┌──┐ ┌──┐ ┌──┐     │ ₦25,000                        │
│ │  │ │  │ │  │ │  │ │  │     │                                │
│ │  │ │  │ │  │ │  │ │  │     │ ─────────────────────────────  │
│ └──┘ └──┘ └──┘ └──┘ └──┘     │                                │
│                              │ Select Size:                    │
│                              │ [S] [M] [L] [XL]                │
│                              │                                │
│                              │ Select Color:                  │
│                              │ [●] Black  [●] Red  [●] Blue   │
│                              │                                │
│                              │ Quantity: [-] 1 [+]            │
│                              │                                │
│                              │ ┌────────────────────────────┐ │
│                              │ │     ADD TO CART            │ │
│                              │ └────────────────────────────┘ │
│                              │ ┌────────────────────────────┐ │
│                              │ │     BUY NOW                 │ │
│                              │ └────────────────────────────┘ │
│                              │                                │
│                              │ Delivery: 5-7 days • ₦1,500  │
│                              │ Free delivery on orders > ₦50k │
└──────────────────────────────┴──────────────────────────────────┘

PRODUCT DETAILS
┌─────────────────────────────────────────────────────────────────┐
│ Description                                                     │
│ Lorem ipsum dolor sit amet, consectetur adipiscing elit...     │
│                                                                 │
│ Materials: 100% Cotton                                          │
│ Care: Hand wash cold, hang dry                                  │
│ ─────────────────────────────────────────────────────────────  │
│ SIZE GUIDE  [Open modal]                                        │
└─────────────────────────────────────────────────────────────────┘
```

### 7.4 Shopping Cart Page

```
┌─────────────────────────────────────────────────────────────────┐
│ HEADER                                                          │
├─────────────────────────────────────────────────────────────────┤
│ PAGE TITLE: Shopping Cart (3 items)                            │
├──────────────────────────────────┬──────────────────────────────┤
│ CART ITEMS                        │ ORDER SUMMARY                │
│                                   │                              │
│ ┌────────────────────────────────┐│ ┌──────────────────────────┐ │
│ │ [Image] Product Name          ││ │ Subtotal       ₦75,000   │ │
│ │ Size: M | Color: Black         ││ │                          │ │
│ │                    ₦25,000    ││ │ Delivery       ₦1,500    │ │
│ │ Quantity: [-] 1 [+]    [🗑]  ││ │                          │ │
│ └────────────────────────────────┘│ │ ─────────────────────     │ │
│                                   │ │ Total          ₦76,500   │ │
│ ┌────────────────────────────────┐│ │                          │ │
│ │ [Image] Product Name          ││ │                          │ │
│ │ Size: L | Color: Red           ││ │ ┌──────────────────────┐ │ │
│ │                    ₦25,000    ││ │ │   PROCEED TO         │ │ │
│ │ Quantity: [-] 2 [+]    [🗑]  ││ │ │      CHECKOUT         │ │ │
│ └────────────────────────────────┘│ │ └──────────────────────┘ │ │
│                                   │ │                          │ │
│ [← Continue Shopping]             │ │ Have a code?             │ │
│                                   │ │ [Enter code] [Apply]     │ │
└───────────────────────────────────┴──────────────────────────────┘
```

### 7.5 Checkout Page

```
┌─────────────────────────────────────────────────────────────────┐
│ HEADER                                                          │
├──────────────────────────────────┬──────────────────────────────┤
│ CHECKOUT FORM                     │ ORDER SUMMARY                │
│                                   │                              │
│ 1. SHIPPING ADDRESS               │ 2 items                      │
│ ┌────────────────────────────────┐│ ┌──────────────────────────┐ │
│ │ Full Name                      ││ │ Product 1    ₦25,000    │ │
│ │ [________________________]     ││ │ Product 2    ₦50,000    │ │
│ │                                ││ │                          │ │
│ │ Phone Number                   ││ │ Subtotal     ₦75,000    │ │
│ │ [________________________]     ││ │ Delivery     ₦1,500    │ │
│ │                                ││ │                          │ │
│ │ Address Line 1                ││ │ Total        ₦76,500   │ │
│ │ [________________________]     ││ └──────────────────────────┘ │
│ │                                ││                              │
│ │ City, State                    ││                              │
│ │ [________________________]     ││                              │
│ └────────────────────────────────┘│                              │
│                                   │                              │
│ 2. DELIVERY METHOD                │                              │
│ (•) Standard (₦1,500, 5-7 days)  │                              │
│ ( ) Express (₦3,000, 2-3 days)     │                              │
│ ( ) Same Day (₦5,000)              │                              │
│                                   │                              │
│ 3. PAYMENT METHOD                 │                              │
│ ( ) Pay with Monnify              │                              │
│   [Bank Transfer / Card / USSD]   │                              │
│ ( ) Cash on Delivery (+₦500)    │                              │
│                                   │                              │
│ [PLACE ORDER - ₦76,500]           │                              │
│                                   │                              │
└───────────────────────────────────┴──────────────────────────────┘
```

### 7.6 Account Pages

#### Order History
```
┌─────────────────────────────────────────────────────────────────┐
│ HEADER                                                          │
├─────────────────────────────────────────────────────────────────┤
│ MY ACCOUNT                                                      │
│ ┌─────────────────────────────────────────────────────────────┐│
│ │ Sidebar          │ Content                                  ││
│ │ ─────────────    │                                          ││
│ │ • Dashboard      │ ORDER HISTORY                            ││
│ │ • Orders         │                                          ││
│ │ • Addresses      │ ┌────────────────────────────────────┐  ││
│ │ • Wishlist       │ │ Order #BS2600001  │ Pending        │  ││
│ │ • Settings       │ │ Dec 15, 2025      │ ₦25,000        │  ││
│ │                  │ │ [View Details]                         │  ││
│ │                  │ └────────────────────────────────────┘  ││
│ │                  │                                          ││
│ │                  │ ┌────────────────────────────────────┐  ││
│ │                  │ │ Order #BS2600002  │ Delivered       │  ││
│ │                  │ │ Dec 10, 2025      │ ₦45,000        │  ││
│ │                  │ │ [View Details]                         │  ││
│ │                  │ └────────────────────────────────────┘  ││
│ └─────────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
```

---

## 8. Admin Dashboard Pages

### 8.1 Admin Layout

```
┌─────────────────────────────────────────────────────────────────┐
│ ADMIN HEADER                                                    │
│ Logo │ Search │ Notifications │ Profile                       │
├──────────┬──────────────────────────────────────────────────────┤
│ SIDEBAR  │ MAIN CONTENT                                         │
│          │                                                       │
│ Dashboard│ ┌────────────────────────────────────────────────┐  │
│          │ │ Page Title                                     │  │
│ Products│ │ ──────────────────────────────────────────────   │  │
│ ├ All   │ │                                                │  │
│ ├ Add   │ │                                                │  │
│        │ │                                                │  │
│ Orders │ │                                                │  │
│ ├ All   │ │                                                │  │
│ ├ Pending│ │                                                │  │
│        │ │                                                │  │
│ Customers│ │                                                │  │
│          │ │                                                │  │
│ Inventory│ │                                                │  │
│          │ └────────────────────────────────────────────────┘  │
│ Settings │                                                      │
└──────────┴──────────────────────────────────────────────────────┘
```

### 8.2 Dashboard Overview

```
┌─────────────────────────────────────────────────────────────────┐
│ ADMIN HEADER                                                    │
├──────────┬──────────────────────────────────────────────────────┤
│ SIDEBAR  │ MAIN CONTENT                                         │
│          │                                                       │
│          │ WELCOME BACK, ADMIN                                   │
│          │                                                       │
│          │ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ │
│          │ │ TODAY'S  │ │ MONTHLY  │ │ ORDERS   │ │ CUSTOMERS│ │
│          │ │ SALES    │ │ REVENUE  │ │ TODAY    │ │ TOTAL    │ │
│          │ │ ₦150,000 │ │ ₦2.5M    │ │ 25       │ │ 1,250    │ │
│          │ └──────────┘ └──────────┘ └──────────┘ └──────────┘ │
│          │                                                       │
│          │ RECENT ORDERS                         View All →    │
│          │ ┌────────────────────────────────────────────────┐ │
│          │ │ #BS2600001 │ John Doe │ ₦25,000 │ Pending    │ │
│          │ │ #BS2600002 │ Jane Doe │ ₦45,000 │ Shipped    │ │
│          │ └────────────────────────────────────────────────┘ │
│          │                                                       │
│          │ TOP PRODUCTS                         View All →    │
│          │ ┌────────────────────────────────────────────────┐ │
│          │ │ 1. Product A - 150 sold                        │ │
│          │ │ 2. Product B - 120 sold                        │ │
│          │ └────────────────────────────────────────────────┘ │
└──────────┴──────────────────────────────────────────────────────┘
```

### 8.3 Product Management

```
┌─────────────────────────────────────────────────────────────────┐
│ ADMIN HEADER                                                    │
├──────────┬──────────────────────────────────────────────────────┤
│ SIDEBAR  │ PRODUCTS                                              │
│          │                                                        │
│          │ [+ ADD PRODUCT]  [Export]                             │
│          │                                                        │
│          │ ┌────────────────────────────────────────────────┐  │
│          │ │ Filter: [Category ▼] [Status ▼] [Search...]    │  │
│          │ └────────────────────────────────────────────────┘  │
│          │                                                        │
│          │ ┌────┬────────────┬────────┬────────┬───────┬─────┐│
│          │ │ ☐  │ Product    │ Category│ Price │ Stock │ Act ││
│          │ ├────┼────────────┼────────┼────────┼───────┼─────┤│
│          │ │ ☐  │ Dress A    │ Dresses│ ₦25k  │ 50    │ ⋮   ││
│          │ │ ☐  │ Shoes B    │ Shoes  │ ₦35k  │ 30    │ ⋮   ││
│          │ └────┴────────────┴────────┴────────┴───────┴─────┘│
│          │                                                        │
│          │ Showing 1-20 of 150  [< 1 2 3 ... 8 >]               │
└──────────┴──────────────────────────────────────────────────────┘
```

---

## 9. Animations & Transitions

### 9.1 Animation Specifications

| Animation | Duration | Easing | Trigger |
|-----------|----------|--------|---------|
| Button hover | 200ms | ease-in-out | Mouse enter |
| Card hover | 300ms | ease-out | Mouse enter |
| Page transition | 300ms | ease-in-out | Route change |
| Modal open | 250ms | ease-out | Click |
| Modal close | 200ms | ease-in | Click |
| Loading spinner | 1000ms | linear | In progress |
| Toast notification | 300ms | ease-out | Trigger |

### 9.2 Micro-interactions

- **Button press**: Scale 0.98 on active
- **Input focus**: Border color transition 200ms
- **Checkbox**: Scale bounce on check
- **Cart add**: Badge pulse animation
- **Like/Wishlist**: Heart fill animation

---

## 10. Accessibility Requirements

### 10.1 WCAG 2.1 Level A Compliance

| Requirement | Implementation |
|-------------|---------------|
| Color contrast | Minimum 4.5:1 for text |
| Keyboard navigation | All interactive elements focusable |
| Focus indicators | Visible outline on focus |
| Alt text | All images have descriptive alt |
| Form labels | All inputs have associated labels |
| Error identification | Clear error messages |

### 10.2 Focus States

```css
/* Visible focus indicator */
*:focus-visible {
  outline: 2px solid #1FAF5A;
  outline-offset: 2px;
}
```

---

## 11. Loading States

### 11.1 Skeleton Loading

```
┌─────────────────────────────────────────────────────────────────┐
│ [Skeleton Card]     [Skeleton Card]     [Skeleton Card]       │
│ ┌──────────────┐   ┌──────────────┐   ┌──────────────┐         │
│ │ ████████████ │   │ ████████████ │   │ ████████████ │         │
│ │ ████████████ │   │ ████████████ │   │ ████████████ │         │
│ │              │   │              │   │              │         │
│ │ ████████     │   │ ████████     │   │ ████████     │         │
│ │ ██████       │   │ ██████       │   │ ██████       │         │
│ └──────────────┘   └──────────────┘   └──────────────┘         │
└─────────────────────────────────────────────────────────────────┘
```

---

## 12. Error States

### 12.1 Empty States

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│                         🛒               (icon)                 │
│                                                                 │
│              Your cart is empty                                 │
│                                                                 │
│    Looks like you haven't added anything to your cart yet.     │
│                                                                 │
│              [CONTINUE SHOPPING]                                │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 12.2 Error States

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│                         ⚠️               (icon)                │
│                                                                 │
│              Something went wrong                               │
│                                                                 │
│    We couldn't load this page. Please try again.              │
│                                                                 │
│              [RETRY]                                            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 13. Responsive Behavior

### 13.1 Mobile Adaptations

| Desktop Element | Mobile Adaptation |
|-----------------|-------------------|
| 4-column grid | 2-column grid |
| Horizontal nav | Hamburger menu |
| Sidebar filters | Modal filters |
| Full header | Compact header |
| Desktop tables | Horizontal scroll |

### 13.2 Touch Targets

| Element | Minimum Size |
|---------|--------------|
| Buttons | 44x44px |
| Form inputs | 44px height |
| Checkboxes | 24x24px |
| Menu items | 44px height |
