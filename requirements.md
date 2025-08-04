Kentra MVP Mobile App
Features Document (2025)

1. Global App Structure
Architecture & Core Components

Entry Point

main.dart → Launches app with MaterialApp, routes, and theming.

Core System

app.dart → Main application shell (theme, navigation, routing).

routes.dart → Manages navigation between all screens.

theme.dart → Light/Dark mode with adaptive color schemes.

constants.dart → Centralized definitions for icons, colors, and spacing.

Widgets

Bottom Navigation Bar (5 main sections).

Floating Quick Create Button (+).

Drawer Menu (Notifications + Settings).

Streak & Badge Gamification Components.

Services Layer

Firebase → Authentication, Firestore, Push Notifications.

Notification Service → Smart reminders, streak nudges, task deadlines.

AI Service → Contextual AI Co-Pilot (basic GPT for Free Plan).

State Providers

Authentication

Mind (journal, goals, streaks)

Calendar (tasks, automation)

Work (management, contracts)

AI (chat, persona modes)

2. Navigation & Layout
Bottom Navigation (Persistent)

Home 🏠 → Dashboard + Quick Highlights

Mind 🧠 → Journal, Mood, Identity Graph Lite

Calendar 📆 → Task Planner, Kanban, Analytics

Work 📂 → Management Tools (Gantt, SWOT, CPM, etc.)

AI Chat 🤖 → WhatsApp-style AI Co-Pilot

Floating Action Button (+)

Opens Quick Create Modal (Document, Table, Flow, Checklist, Pomodoro, etc.)

Drawer Menu (Right Swipe)

Notifications

Settings & Personalization

3. Core Features
3.1 Home Dashboard
Personalized Welcome Message

Mindspace Highlight Card → Daily Goals, Journal %, Progress

Quick Create Bar (horizontal scroll):
Document | Table | Flow | Checklist | Pomodoro | Mindmap | Chart | Brain Dump

Recent Projects Section → Swipeable project cards

CTA Buttons → Create Project / Create Workspace

Motivational & Achievement Banners → Micro-achievement badges

3.2 Mindspace Module
Journal → Rich Text, Mood Selector, Tags, Image Upload

Mind Dump → Idea Cards (Pin, Archive, Trash)

Personality Log → Daily Reflection, MBTI Timeline

Progress Tracker → Scrollable Line Chart, Category Filters

Identity Graph Lite → Weekly/Monthly Mood + MBTI Trends

3.3 Workspace & Project System
Workspace Creation Modal

Upload Icon/Header

Name, Description, Role Tags

Workspace Dashboard

Add Widgets (Checklist, Calendar, Kanban, Progress Bar)

Folder & Project Management

Nested folders with swipe-expand

Project Editor

Pinch-to-Zoom Canvas

Floating Panel (+) for adding files/nodes

Bottom Toolbar: Export | Share | Save

3.4 Calendar Module
Modes

Grid | Kanban | Priority Matrix | Focus Planner | Analytics | Automation

Features

Drag & Drop Scheduling

Daily/Weekly/Monthly/Yearly Toggle

Task Modal → Title | Date/Time | Recurring | File Upload | Notifications

Analytics: Heatmap, Stats Cards, Progress Rings

Automation: Rule Builder + Swipeable Templates

3.5 Work Management Tools
Categories & Tools

Project Tools → Gantt, WBS, Agile, CPM

Quality Tools → Flowchart, Pareto, Fishbone

Risk Tools → SWOT, Impact Matrix

Team Tools → Delegation Matrix, Feedback Board

Decision Tools → Stakeholder Analysis, Decision Tree, Scrum

3.6 AI Chat Co-Pilot
WhatsApp-style interface

Role Modes → Mentor | Friend | Strategist

Context Selector → Workspace/Folder link

Slash Commands → /task, /note, #focus

File/Voice/Image Upload

Inline AI → Highlight text → “Ask AI”

Decision Support Lite → Nudges & Reminders

3.7 Personalization & Retention
AI Mood & Habit Suggestions

Personality Evolution Cards

Habit Trackers (Sleep, Study, Workouts)

Motivational Popups + Prediction Nudges

Humane Gamification

Streak Shields, XP Bar, Confetti, Level Badges

4. Global Features
Push Notifications → Tasks, Reminders, Nudge Alerts

Offline Mode Lite → Cache last 7 days of Mind, Calendar, Work

Monetization (Phased)

Free Plan

Access to all modules with capped usage

AI Chat (basic GPT, no persona creation)

Read-only data retention on downgrade

Pro Student Plan ($19/month)

Full AI Co-Pilot, persona toggles, automation

Higher task/project/workspace quotas

Kentra Coin multipliers & advanced analytics

Advanced Plan ($29/month)

For heavy usage (freelancers & power users)

Unlimited AI credits, automation rules, premium widgets

5. Suggested Build Order
Authentication + Onboarding

Bottom Navigation + Drawer

Home Dashboard + Quick Create

Mindspace Core (Journal, Goals, Progress)

Calendar Core + Task Modal

Management Tools (Work Module)

AI Chat Co-Pilot

Workspace + Project Editor

Text Editor + Canvas Tools

Gamification & Rewards Layer