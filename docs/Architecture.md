# BEST SOLO - Architecture Document

## 1. System Architecture Overview

### 1.1 Architecture Pattern
BEST SOLO follows a **Client-Server architecture** with a ** microservices-inspired approach** using serverless functions where appropriate. The application is deployed as a Progressive Web Application (PWA) on Flutter Web, communicating with a backend-as-a-service (BaaS) platform.

```
┌─────────────────────────────────────────────────────────────────┐
│                        CLIENT LAYER                              │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │                   Flutter Web Application                    ││
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────┐   ││
│  │  │Customer  │ │Admin     │ │Public    │ │PWA Service  │   ││
│  │  │Storefront│ │Dashboard │ │Pages     │ │Worker       │   ││
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────────┘   ││
│  └─────────────────────────────────────────────────────────────┘│
└──────────────────────────┬──────────────────────────────────────┘
                           │ HTTPS (TLS 1.3)
┌──────────────────────────▼──────────────────────────────────────┐
│                        API GATEWAY LAYER                         │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │              Supabase Edge Functions / API                   ││
│  │  ┌──────────────┐ ┌──────────────┐ ┌──────────────────────┐ ││
│  │  │Authentication│ │REST API     │ │GraphQL (optional)    │ ││
│  │  │Service      │ │Endpoints    │ │                      │ ││
│  │  └──────────────┘ └──────────────┘ └──────────────────────┘ ││
│  │  ┌──────────────┐ ┌──────────────┐ ┌──────────────────────┐ ││
│  │  │Rate Limiting │ │Validation   │ │CORS Management       │ ││
│  │  └──────────────┘ └──────────────┘ └──────────────────────┘ ││
│  └─────────────────────────────────────────────────────────────┘│
└──────────────────────────┬──────────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────────┐
│                      BACKEND SERVICES LAYER                      │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌───────────┐│
│  │  Supabase    │ │  Database    │ │  Cloudinary │ │ Monnify   ││
│  │  Auth        │ │  (PostgreSQL)│ │  (Images)   │ │ (Payments)││
│  │  Realtime    │ │              │ │              │ │           ││
│  └──────────────┘ └──────────────┘ └──────────────┘ └───────────┘│
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. Technology Stack

### 2.1 Frontend Technologies

| Layer | Technology | Version | Purpose |
|-------|------------|---------|---------|
| Framework | Flutter Web | 3.x | Core UI framework |
| State Management | flutter_bloc | ^8.x | BLoC pattern for state |
| HTTP Client | dio | ^5.x | API communication |
| Local Storage | shared_preferences | ^2.x | User preferences, cart |
| Image Handling | cached_network_image | ^3.x | Image caching |
| Forms | flutter_form_builder | ^9.x | Form management |
| Validation | form_builder_validators | ^9.x | Input validation |
| URL Routing | go_router | ^12.x | Navigation |
| Animations | flutter_animate | ^4.x | UI animations |

### 2.2 Backend Technologies

| Layer | Technology | Purpose |
|-------|------------|---------|
| BaaS | Supabase | Auth, Database, API, Realtime |
| Database | PostgreSQL | Primary data store |
| Edge Functions | Deno/TypeScript | Server-side logic |
| Image Storage | Cloudinary | Image upload, transformation |
| Payments | Monnify SDK | Payment processing |
| Hosting | Vercel | Frontend deployment |

### 2.3 Development Tools

| Tool | Purpose |
|------|---------|
| Git | Version control |
| GitHub | Code repository |
| GitHub Actions | CI/CD pipeline |
| VS Code | IDE |
| Flutter DevTools | Debugging |
| Postman | API testing |
| TablePlus | Database management |

---

## 3. Application Structure

### 3.1 Flutter Project Structure

```
best_solo/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── app.dart                     # MaterialApp configuration
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart      # Color definitions
│   │   │   ├── app_typography.dart # Font styles
│   │   │   ├── app_spacing.dart    # Spacing constants
│   │   │   └── api_constants.dart  # API endpoints
│   │   ├── theme/
│   │   │   └── app_theme.dart      # Theme configuration
│   │   ├── utils/
│   │   │   ├── extensions.dart     # Extension methods
│   │   │   ├── formatters.dart     # Data formatters
│   │   │   └── validators.dart     # Custom validators
│   │   └── error/
│   │       ├── exceptions.dart     # Custom exceptions
│   │       └── failures.dart       # Failure classes
│   ├── data/
│   │   ├── models/                 # Data models
│   │   ├── repositories/          # Repository implementations
│   │   ├── datasources/
│   │   │   ├── local/              # Local data sources
│   │   │   └── remote/             # Remote data sources
│   │   └── mappers/                # Model mappers
│   ├── domain/
│   │   ├── entities/               # Domain entities
│   │   ├── repositories/           # Repository interfaces
│   │   └── usecases/              # Business logic
│   ├── presentation/
│   │   ├── blocs/                  # BLoC state management
│   │   ├── pages/                  # Screen widgets
│   │   ├── widgets/                # Reusable widgets
│   │   └── routes/                 # Route definitions
│   └── injection.dart              # Dependency injection
├── assets/
│   ├── images/
│   └── icons/
├── test/
└── web/
```

### 3.2 Supabase Project Structure

```
supabase/
├── config/
│   └── config.toml                 # Supabase configuration
├── migrations/
│   └── 001_initial_schema.sql     # Database migrations
├── functions/
│   ├── _shared/                    # Shared code
│   ├── payment-webhook/           # Monnify webhook handler
│   ├── order-notifications/       # Order notification logic
│   └── image-upload-signature/    # Cloudinary signature
└── seed/
    └── seed.sql                    # Sample data
```

---

## 4. API Architecture

### 4.1 API Design Principles

1. **RESTful Conventions**: Resources as nouns, HTTP verbs for actions
2. **Versioning**: URL-based versioning (v1/)
3. **Stateless**: Each request contains all necessary information
4. **Consistent Response Format**: Standard envelope for all responses
5. **Pagination**: Cursor-based for large datasets
6. **Filtering**: Query parameters for resource filtering

### 4.2 API Response Format

#### Success Response
```json
{
  "success": true,
  "data": { },
  "message": "Operation successful",
  "meta": {
    "page": 1,
    "per_page": 20,
    "total": 100
  }
}
```

#### Error Response
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid email format",
    "details": []
  }
}
```

### 4.3 Public API Endpoints

#### Authentication
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /auth/register | Register new user |
| POST | /auth/login | User login |
| POST | /auth/logout | User logout |
| POST | /auth/reset-password | Password reset |
| GET | /auth/verify-email | Verify email token |

#### Products
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /products | List products |
| GET | /products/{id} | Get product details |
| GET | /products/search | Search products |
| GET | /categories | List categories |
| GET | /products/{id}/variants | Get product variants |

#### Cart
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /cart | Get user cart |
| POST | /cart/items | Add to cart |
| PUT | /cart/items/{id} | Update cart item |
| DELETE | /cart/items/{id} | Remove from cart |

#### Orders
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /orders | Create order |
| GET | /orders | List user orders |
| GET | /orders/{id} | Get order details |
| PUT | /orders/{id}/cancel | Cancel order |

#### Checkout
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /checkout/initialize | Initialize payment |
| POST | /checkout/verify | Verify payment |
| POST | /checkout/cod | Create COD order |

### 4.4 Admin API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /admin/auth/login | Admin login |
| GET | /admin/dashboard/stats | Dashboard statistics |
| CRUD | /admin/products | Product management |
| CRUD | /admin/categories | Category management |
| CRUD | /admin/orders | Order management |
| CRUD | /admin/customers | Customer management |
| GET | /admin/inventory | Inventory overview |

---

## 5. Database Schema Architecture

### 5.1 Database Design Principles

1. **Normalization**: Third normal form (3NF)
2. **Relationships**: Proper foreign keys with referential integrity
3. **Indexes**: Strategic indexing for query optimization
4. **Soft Deletes**: Using deleted_at for data retention
5. **Timestamps**: Created_at and updated_at on all tables

### 5.2 Database Schema Overview

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   users     │     │  products   │     │ categories  │
├─────────────┤     ├─────────────┤     ├─────────────┤
│ id (PK)     │     │ id (PK)     │     │ id (PK)     │
│ email       │────▶│ category_id │     │ name        │
│ password_hash│    │ name        │     │ slug        │
│ full_name   │     │ description │     │ image_url   │
│ phone       │     │ price       │     │ parent_id   │
│ role        │     │ images      │     │ created_at  │
│ is_verified │     │ is_active   │     └─────────────┘
│ created_at  │     │ created_at  │
└─────────────┘     └──────┬──────┘
                           │
                    ┌──────▼──────┐
                    │  variants   │
                    ├─────────────┤
                    │ id (PK)     │
                    │ product_id  │
                    │ size        │
                    │ color       │
                    │ price       │
                    │ stock       │
                    │ sku         │
                    └─────────────┘
                           │
          ┌────────────────┼────────────────┐
          ▼                ▼                ▼
┌─────────────┐   ┌─────────────┐   ┌─────────────┐
│    orders   │   │ order_items │   │  addresses  │
├─────────────┤   ├─────────────┤   ├─────────────┤
│ id (PK)     │◀──│ order_id    │   │ id (PK)     │
│ user_id     │   │ variant_id  │   │ user_id     │
│ status      │   │ quantity    │   │ name        │
│ total       │   │ price       │   │ phone       │
│ payment_id  │   └─────────────┘   │ address     │
│ shipping_id │                     │ city        │
│ created_at  │                     │ state       │
└─────────────┘                     │ is_default  │
                                    └─────────────┘
```

---

## 6. Security Architecture

### 6.1 Authentication Flow

```
┌──────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────┐
│  User    │───▶│   Flutter    │───▶│  Supabase    │───▶│ Database │
│ Action   │    │   App        │    │   Auth       │    │          │
└──────────┘    └──────┬───────┘    └──────────────┘    └──────────┘
                       │
              ┌────────▼────────┐
              │ JWT Token       │
              │ (Access/Refresh)│
              └─────────────────┘
```

### 6.2 Security Measures

| Layer | Measure | Implementation |
|-------|---------|----------------|
| Transport | TLS 1.3 | HTTPS enforced |
| Authentication | JWT | Access + Refresh tokens |
| Authorization | RBAC | Role-based policies |
| API | Rate limiting | 100 req/min per user |
| Database | Row-level security | Supabase RLS policies |
| Input | Validation | Server + Client side |
| XSS | Sanitization | Flutter built-in |
| CSRF | Token validation | Supabase handles |
| Secrets | Environment vars | Vercel env vars |

### 6.3 Role-Based Access Control (RBAC)

| Role | Permissions |
|------|-------------|
| Customer | Read products, manage cart, manage orders, manage own profile |
| Staff | All customer permissions + manage products, manage orders, view customers |
| Owner | Full access including staff management, analytics, settings |

---

## 7. Payment Architecture

### 7.1 Monnify Integration Flow

```
┌──────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────┐
│ Customer │───▶│   Flutter    │───▶│   Monnify    │───▶│   Bank   │
│ Checkout │    │   App        │    │   API        │    │          │
└──────────┘    └──────┬───────┘    └──────┬───────┘    └──────────┘
                       │                   │
              ┌────────▼────────┐   ┌────────▼────────┐
              │ Create Payment │   │ Payment Webhook  │
              │ Reservation     │   │ (Edge Function) │
              └─────────────────┘   └────────┬─────────┘
                                             │
                                      ┌──────▼──────┐
                                      │  Update     │
                                      │  Order      │
                                      │  Status     │
                                      └─────────────┘
```

### 7.2 Payment States

| State | Description | Next State |
|-------|-------------|-------------|
| PENDING | Payment initiated | PAID / EXPIRED |
| PAID | Payment confirmed | PROCESSING / FAILED |
| PROCESSING | Order being prepared | SHIPPED / CANCELLED |
| SHIPPED | Order dispatched | DELIVERED |
| DELIVERED | Order received | COMPLETED |
| CANCELLED | Order cancelled | - |
| REFUNDED | Payment refunded | - |

---

## 8. Image Management Architecture

### 8.1 Cloudinary Integration

```
┌──────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────┐
│  Admin   │───▶│   Flutter    │───▶│  Cloudinary  │───▶│  CDN     │
│  Upload  │    │   App        │    │   API        │    │          │
└──────────┘    └──────┬───────┘    └──────────────┘    └──────────┘
                       │
              ┌────────▼────────┐
              │ Image Transform  │
              │ (on-the-fly)      │
              └─────────────────┘
```

### 8.2 Image Transformation Rules

| Context | Transformation |
|---------|----------------|
| Thumbnail | w_150,h_150,c_fill,q_auto,f_auto |
| Card | w_400,h_400,c_fill,q_auto,f_auto |
| Detail | w_800,h_800,c_limit,q_auto,f_auto |
| Original | c_limit,q_90,f_auto |

---

## 9. Deployment Architecture

### 9.1 Vercel Deployment

```
┌─────────────────────────────────────────────────────────────────┐
│                        VERCEL PLATFORM                          │
│  ┌─────────────────┐  ┌─────────────────┐  ┌───────────────┐  │
│  │   Production    │  │   Preview       │  │  Development  │  │
│  │   bestsolo.com  │  │   PR-specific   │  │  Local        │  │
│  └────────┬────────┘  └────────┬────────┘  └───────────────┘  │
│           │                     │                                 │
│           ▼                     ▼                                 │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │              Global CDN (Edge Network)                       ││
│  └─────────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
```

### 9.2 Environment Configuration

| Environment | URL | Purpose |
|-------------|-----|---------|
| Development | localhost:3000 | Local development |
| Staging | staging.bestsolo.com | Pre-production testing |
| Production | bestsolo.com | Live production |

---

## 10. Caching Strategy

### 10.1 Cache Layers

| Layer | Technology | TTL | Invalidation |
|-------|------------|-----|--------------|
| Browser | Service Worker | 1 hour | Manual |
| CDN | Vercel Edge | 1 year | On deploy |
| API | Supabase | 1 minute | On data change |
| Images | Cloudinary | 1 year | Manual |

### 10.2 Cache Invalidation Strategy

- **Products**: Purge on create/update/delete
- **Categories**: Purge on create/update/delete
- **Static Assets**: Auto-invalidate on deploy

---

## 11. Monitoring & Analytics

### 11.1 Application Monitoring

| Tool | Purpose |
|------|---------|
| Vercel Analytics | Performance monitoring |
| Sentry | Error tracking |
| Supabase Logs | Backend debugging |

### 11.2 Business Analytics

| Metric | Source |
|--------|--------|
| Page Views | Vercel Analytics |
| Conversion Rate | Custom events |
| Revenue | Database |
| User Behavior | Mixpanel (Future) |

---

## 12. Scalability Considerations

### 12.1 Horizontal Scaling
- Vercel automatically scales with traffic
- Supabase handles database scaling
- Cloud CDN for static assets

### 12.2 Vertical Scaling
- Database optimization with indexes
- Query optimization
- Image optimization

### 12.3 Future Scaling
- Read replicas for database
- Redis caching layer
- CDN for dynamic content

---

## 13. Disaster Recovery

### 13.1 Backup Strategy

| Data | Frequency | Retention |
|------|-----------|-----------|
| Database | Daily | 30 days |
| Images | Real-time | Indefinite |
| Config | On change | 30 days |

### 13.2 Recovery Procedures

1. **Database Recovery**: Restore from Supabase backup
2. **Image Recovery**: Re-upload from source files
3. **Code Recovery**: Deploy from Git history

---

## 14. Third-Party Integrations Summary

| Service | Purpose | Integration Method |
|---------|---------|-------------------|
| Supabase | Backend | SDK |
| Cloudinary | Images | REST API |
| Monnify | Payments | REST API |
| Vercel | Hosting | Git integration |
