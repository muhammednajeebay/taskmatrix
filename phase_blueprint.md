# Task Management App — MVP Blueprint

---

## 1. Architecture Overview

**Frontend (Flutter)**

- **State Management:** Feature-specific BLoCs / Cubits
  - `AuthBloc` → login, signup, domain key validation
  - `TaskBloc` → task CRUD, comments
  - `PointsBloc` → points calculation, leaderboard
  - `NotificationBloc` → push notifications
  - `UserBloc` → user management, OrgAdmin actions
- **Routing:** Nested `GoRouter` structure
- **Themes:** Light + Dark mode
- **Visual Indicators:** Progress bars & badges for points & leaderboard

**Backend (Supabase)**

- **Auth:** Email/password + domain key
- **Database:** Postgres tables with Row-Level Security (RLS)
- **Storage:** Org logos only
- **Edge Functions:** Points calculation & push notifications
- **Materialized Views:** Analytics & charts
- **Audit Logging:** All critical actions

**Realtime**

- Supabase Realtime for task updates, points updates, notifications

**Deployment**

- Separate environments: Dev / Staging / Production
- CI/CD pipeline with automated tests

---

## 2. Database Entities (Tables)

| Table | Key Fields | Notes |
|-------|------------|------|
| organizations | id, name, domain_key, logo_url, created_at | Org info; domain key used for login |
| users | id, org_id, email, name, role, points, created_at | Minimal profile + cached points |
| tasks | id, org_id, title, description, assignee_id, status, difficulty, priority, due_date, is_deleted, archived_at, created_at, updated_at | Optional due date, difficulty, priority; archived after 2 years |
| task_comments | id, task_id, user_id, comment, created_at | Comments; no notifications in MVP |
| points_log | id, org_id, user_id, task_id, points, awarded_by, created_at | Full points history; drives leaderboard |
| audit_log | id, org_id, user_id, entity_type, entity_id, action, old_value, new_value, created_at | Full audit trail |
| org_points_config | org_id, mode (A/B/C), parameters (JSONB) | Per-org points formula & parameters |
| notifications | id, user_id, type, message, read, created_at | Task assignment/completion notifications |

**Relationships & Constraints**

- `users.org_id → organizations.id`
- `tasks.org_id → organizations.id`
- `tasks.assignee_id → users.id`
- `task_comments.task_id → tasks.id`
- `task_comments.user_id → users.id`
- `points_log.user_id → users.id`
- `points_log.task_id → tasks.id`
- `audit_log.org_id → organizations.id`
- `audit_log.user_id → users.id`
- `org_points_config.org_id → organizations.id`
- `notifications.user_id → users.id`

**RLS Policies**

- Members → see only their assigned tasks
- Admins/Managers → full org access
- Exclude `is_deleted = TRUE` & `archived_at IS NOT NULL`

---

## 3. Points Engine (MVP)

- Configurable per org in `org_points_config.parameters`
- Supports formulas A/B/C
  - Formula B: difficulty multipliers + optional timeliness bonus
- Triggered on task completion via Supabase Edge Function
- Updates `points_log` → updates cached points → updates leaderboard & visual indicators

---

## 4. Notifications

- Only for task assignment & completion
- Includes: task title + assigned by + due date
- Delivered via Supabase Edge Function → FCM/APNs
- Inserts row in `notifications` table for in-app display
- Realtime updates handled by `NotificationBloc`

---

## 5. Admin Features

- Edit org name & upload logo
- Configure points formula & parameters
- Invite/remove users via email invite link
- Assign roles: Member / Manager / Admin
- Analytics dashboard: charts & tables
- View-only archive of soft-deleted tasks
- Audit log view

---

## 6. UI / UX Decisions

- Nested `GoRouter` routes:
  - `Dashboard → Tasks → Task Detail`
  - `Leaderboard`, `Notifications`
  - `Settings → Org / Users / Points Config`
- Minimal user profile: name, role, points
- Tasks: title, description, difficulty, priority, optional due date, comments
- Visual indicators: progress bars for tasks & points, leaderboard badges
- Leaderboard: top 50 + current user highlighted
- Light + Dark mode

---

## 7. BLoC / State Management

| Feature | BLoC / Cubit |
|---------|---------------|
| Authentication | AuthBloc |
| Tasks | TaskBloc |
| Points / Leaderboard | PointsBloc |
| Notifications | NotificationBloc |
| Users / OrgAdmin | UserBloc |
| Theme | ThemeCubit |

- Modular, feature-specific BLoCs
- Subscribe to Supabase Realtime channels per feature
- Efficient UI rebuilds & separation of concerns

---

## 8. Automated Testing

- **Unit Tests:** BLoCs, points engine, audit logging
- **Widget Tests:** key screens (login, dashboard, tasks, task detail, leaderboard, admin settings)
- **Integration Tests:** Supabase task creation → points → notifications
- CI/CD runs automated tests on PRs

---

## 9. MVP Timeline (4–6 Weeks)

| Week | Focus |
|------|-------|
| 1 | Project setup, Flutter + Supabase environments, BLoC skeleton, GoRouter nested routes |
| 2 | Auth & Org management, login + domain key, Org creation, roles, email invites |
| 3 | Task module: CRUD, comments, difficulty, priority, optional due date, soft-delete, archiving |
| 4 | Points engine, leaderboard, visual indicators, full points history |
| 5 | Notifications, Admin analytics dashboard (charts + tables) |
| 6 | Testing, polish, QA, staging → production deployment |

---

## 10. Supabase Edge Function Flow

**Task Completion Trigger:**

1. Reads task + assignee + org config
2. Calculates points → inserts in `points_log`
3. Updates cached points in `users` table
4. Sends push notification
5. Updates relevant BLoCs via Realtime

**Task Assignment Trigger:**

- Sends push notification
- Inserts row in `notifications` table

---

✅ **Summary**

- Multi-tenant, domain-key-based login
- Roles: OrgAdmin, Manager, Member
- Tasks: CRUD, comments, difficulty, priority, optional due date, soft-delete, archiving after 2 years
- Points engine with visual indicators & full history
- Org-level leaderboard (top 50 + current user)
- Push notifications: task assigned/completed
- Analytics dashboard: charts & tables
- Light + Dark mode
- Feature-specific BLoCs, nested GoRouter structure
- Automated tests, separate environments, CI/CD

