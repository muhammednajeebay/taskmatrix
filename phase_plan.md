# Task Management App — 6-Phase Implementation Plan

---

## Phase 1: Project Setup & Architecture (Week 1)

**Goals:**
- Initialize Flutter project structure
- Setup Supabase backend (Dev environment first)
- Configure feature-specific BLoCs / Cubits
- Setup GoRouter nested routes
- Implement Light + Dark theme support

**Deliverables:**
- Skeleton Flutter project with folder structure
- Auth, Task, Points, Notification, and User BLoCs initialized
- Supabase project with tables and RLS policies created
- GoRouter routes mapped (Dashboard, Tasks, Leaderboard, Settings)
- Basic theme toggling in the app

---

## Phase 2: Authentication & Organization Management (Week 2)

**Goals:**
- Implement login/signup with domain key validation
- Org creation & editing (name, logo)
- Role management (Member, Manager, Admin)
- Email invites for new users
- User profile creation

**Deliverables:**
- AuthBloc fully functional
- Org management screens (Settings → Org)
- Role assignment & invite functionality
- RLS policies tested for Org access

---

## Phase 3: Task Module (Week 3)

**Goals:**
- CRUD tasks with optional due date, difficulty, priority
- Soft-delete & archiving after 2 years
- Task comments functionality
- Task assignment to users with real-time updates

**Deliverables:**
- TaskBloc integrated with Supabase
- Task screens (list, detail, create/edit)
- Comments functionality working
- Soft-deleted tasks hidden from members, visible for admins
- Realtime updates via Supabase Realtime channels

---

## Phase 4: Points Engine & Leaderboard (Week 4)

**Goals:**
- Implement points calculation formulas (A/B/C)
- PointsBloc tracks cached points & leaderboard
- Visual indicators: progress bars, badges
- Full points history maintained in `points_log`

**Deliverables:**
- Edge function for task completion points
- Leaderboard UI: top 50 + current user highlight
- Visual points indicators integrated across tasks & dashboard
- PointsBloc connected to Supabase Realtime

---

## Phase 5: Notifications & Admin Dashboard (Week 5)

**Goals:**
- Push notifications for task assignment & completion
- NotificationBloc integration
- Admin analytics: charts & tables
- Audit logging for all critical actions

**Deliverables:**
- Edge functions for notifications (FCM/APNs)
- Notification table updates & in-app display
- Admin dashboard screens showing analytics
- Audit log UI with filtering & sorting

---

## Phase 6: Testing, QA & Deployment (Week 6)

**Goals:**
- Unit, widget, and integration tests
- CI/CD setup with automated test runs
- Staging → Production deployment
- Final UI/UX polish

**Deliverables:**
- Fully tested BLoCs, screens, and Supabase integrations
- CI/CD pipelines configured for PRs
- Production-ready app deployed
- Light + Dark theme polished across all screens
- Documentation updated for MVP features

