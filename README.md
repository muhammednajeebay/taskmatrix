# 🧩 Task Matrix – Multi-Tenant Task & Performance Manager

**Task Matrix** is a multi-organization task management system built with **Flutter** and **Supabase**, designed to help teams manage tasks, track performance, and improve productivity through **role-based control** and **gamified point scoring**.

It’s built for scalability, real-time collaboration, and clean architecture — powered by **BLoC** state management and **GoRouter** for structured navigation.

---

## 🚀 Overview

Task Matrix enables organizations (called **MasterEntities**) to create and manage their own workspace, define groups, assign admins, and track user performance through tasks and points.

Each organization operates independently with **multi-tenant architecture**, ensuring secure and isolated data access.

---

## 👥 User Roles

| Role | Description | Capabilities |
|------|--------------|---------------|
| **MasterEntity** | Organization owner | Create groups, manage users, assign admins, approve points, view all dashboards |
| **GroupAdmin** | Manager of a specific group | Assign tasks, approve user-created tasks, track group performance |
| **User** | Regular member | View and complete tasks, request approval for self-created tasks, track personal performance |

---

## 🧠 Core Features

### 🔐 Authentication & Access Control
- Supabase Auth integration with **email-password login**
- Multi-tenant user management — each organization manages its own users
- Role-based access control (RBAC) with **Row-Level Security (RLS)**
- MasterEntity controls user creation, password reset, and account management

---

### 🗂️ Group & Task Management
- MasterEntity can create **groups** and assign **GroupAdmins**
- GroupAdmins and MasterEntity can:
  - Assign tasks with **point values**
  - Define deadlines (future feature)
  - Approve or reject self-created tasks
- Users can create **self-tasks** that require admin approval

---

### 🧮 Points & Performance Scoring
- Each task is assigned **points** representing effort or importance
- Users earn points upon approved task completion
- Task points can be weighted by difficulty, priority, or deadline
- Performance metrics include:
  - Completion rate = (Completed Points / Assigned Points) × 100
  - Leaderboards for motivation and transparency
- Gamified system with visible point progress and rankings

---

### 🪄 Real-Time Features
- **Supabase Realtime** for instant updates:
  - New task assignments
  - Status changes and approvals
  - New comments or mentions
- Optional push notifications using Supabase Edge Functions and FCM

---

### 💬 Collaboration & Communication
- Threaded **comments under tasks**
- Mention system for targeted updates (future)
- Planned: Task reminders and due date notifications

---

### 📊 Dashboards
| Role | Dashboard Scope | Data Shown |
|------|------------------|------------|
| **MasterEntity** | All groups & users | Organization-wide analytics, performance charts, pending approvals |
| **GroupAdmin** | Assigned group(s) only | Group performance, pending tasks, approval requests |
| **User** | Personal only | Assigned tasks, completed tasks, performance summary |

---

### 🕵️ Audit & History Tracking
- Full **audit logs** via database triggers:
  - Task creation, edits, deletions
  - Point approvals and changes
- Transparent activity history for accountability

---

### 📦 Reporting & Export (Future Scope)
- Export task lists and performance reports as **CSV, Excel, or PDF**
- Filtered reports by group, user, or date range
- Visual analytics with charts and summary insights

---

## 🧱 Architecture Overview

| Layer | Description |
|-------|-------------|
| **UI Layer** | Flutter screens with GoRouter navigation structure |
| **State Management** | BLoC pattern for predictable, testable state handling |
| **Data Layer** | Supabase integration for Auth, Database, Realtime, and Storage |
| **Domain Layer** | Use-cases for business logic and data manipulation |
| **Core Layer** | Common utilities, models, and constants shared across the app |

---

## 🧩 Tech Stack

| Component | Technology |
|------------|-------------|
| **Frontend** | Flutter (Dart) |
| **Backend** | Supabase (PostgreSQL + Auth + Realtime + Storage) |
| **State Management** | Flutter_BLoC |
| **Navigation** | GoRouter |
| **Auth & Roles** | Supabase Auth + RLS policies |
| **Notifications** | Supabase Edge Functions + Firebase Cloud Messaging |
| **Reports (Future)** | Server-generated CSV, Excel, PDF exports |

---

## 🌐 Multi-Tenant Architecture

Each organization (MasterEntity) acts as a separate **tenant**:
- Every record is tagged with a `tenant_id`
- **RLS (Row-Level Security)** ensures users access only their own organization’s data
- Supabase handles secure filtering at the database level
- Shared schema, but isolated data for scalability and simplicity

---

## 🔮 Future Enhancements

- 📅 Task scheduling and smart reminders  
- 🧾 Advanced analytics dashboards  
- 📬 In-app notifications & message threads  
- 🏅 Achievement badges and user levels  
- 🧰 Admin tools for report exports and insights  

---

## ⚙️ Development Philosophy

Task Matrix follows **Clean Architecture** principles:
- **Separation of Concerns** — independent UI, logic, and data layers
- **Predictable State** — managed entirely through BLoC
- **Scalable Navigation** — with GoRouter for nested, parameterized routing
- **Real-Time Experience** — powered by Supabase Realtime events

---

## 🏁 Scope

Task Matrix aims to:
1. Provide a **structured workspace** for multi-organization task tracking.
2. Encourage productivity through **performance-based points**.
3. Offer transparency with **real-time dashboards** and activity tracking.
4. Scale easily for organizations of any size with Supabase’s modern backend.

---

## 📘 License

This project is under the MIT License — feel free to use, modify, and contribute responsibly.

---

> “Built to manage tasks, motivate teams, and measure progress — the right way.”
