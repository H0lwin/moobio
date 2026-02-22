# IMPLEMENTATION CHECKLIST

### Club Management System

_Full-Stack Build Guide · Django + React Native + ESP_
**How to use this checklist**
Work phase by phase, top to bottom. Each ☐ is one concrete, testable task. Blue arrows (→) are
implementation hints. Do not skip phases — later phases depend on earlier foundations.
6 Phases · ~80 Sections · 200+ Tasks · Estimated 6–8 months · Stack: Django, React, React
Native, PostgreSQL, Redis, ESP


## 01

### Environment Setup & Backend Foundation

```
Weeks 1–3 · Django, PostgreSQL, Redis, JWT, All Core Models
```
#### 1.1 Repository & Project Structure

```
☐ Create a monorepo with three top-level folders: /backend, /admin-panel, /mobile-app
☐ Initialize Git; define branch strategy: main, develop, feature/*, hotfix/*
☐ Add .gitignore covering Python virtualenv, Node modules, .env files, and IDE settings
☐ Create .env.example listing every required environment variable key with no values — commit
this, never the real .env
☐ Write a top-level README.md with project overview, local setup steps for each sub-project, and
links to further docs
```
#### 1.2 Python & Django Environment

```
☐ Install Python 3.11+ on all dev machines; document the required version in .python-version
☐ Create a virtualenv inside /backend: python -m venv .venv; add .venv/ to .gitignore
☐ Install core packages: Django 4.2, djangorestframework, psycopg2-binary,
djangorestframework-simplejwt, celery, redis, channels, channels-redis, django-cors-headers,
python-decouple, Pillow, django-filter
☐ Freeze dependencies: pip freeze > requirements.txt
☐ Run: django-admin startproject config. inside /backend
☐ Split settings into config/settings/base.py, dev.py, prod.py; set DJANGO_SETTINGS_MODULE via
environment variable
☐ Load all secrets from environment using python-decouple; confirm no hardcoded values anywhere
in settings
☐ Set LANGUAGE_CODE, TIME_ZONE=UTC, USE_TZ=True; confirm all datetime handling is
timezone-aware
```
#### 1.3 Database: PostgreSQL

```
☐ Install PostgreSQL 15+ locally; create database clubms_db and user clubms_user with a strong
password
☐ Add DATABASE_URL to .env following the dj-database-url format
☐ Run: python manage.py check --database default — confirm connection succeeds with zero errors
☐ Enable the uuid-ossp extension: CREATE EXTENSION IF NOT EXISTS "uuid-ossp"; in
PostgreSQL
```
#### 1.4 Redis & Celery

```
☐ Install and start Redis server (default port 6379 for dev)
☐ Create config/celery.py: configure broker and result backend pointing to Redis via REDIS_URL
env var
```

```
☐ Import and initialize Celery in config/__init__.py so it auto-discovers tasks in all apps
☐ Add CELERY_BEAT_SCHEDULER = 'django_celery_beat.schedulers:DatabaseScheduler' and
install django-celery-beat for persistent periodic tasks
☐ Run a Celery worker in a separate terminal; confirm it starts and shows all registered tasks
☐ Write a smoke-test task @app.task that logs a message; call it with .delay(); verify it executes in
the worker
```
#### 1.5 Django Channels (WebSocket)

```
☐ Add channels and channels-redis to INSTALLED_APPS; configure ASGI_APPLICATION in
settings
☐ Write config/asgi.py: ProtocolTypeRouter routing HTTP to Django and WebSocket to
AuthMiddlewareStack wrapping URLRouter
☐ Set CHANNEL_LAYERS to use RedisChannelLayer with the REDIS_URL from env
☐ Replace runserver with Daphne for development: daphne -p 8000 config.asgi:application
→ In production, Nginx will proxy /ws/ to Daphne and /api/ to Gunicorn on separate ports
```
#### 1.6 Create All Django Apps

```
☐ python manage.py startapp accounts
☐ python manage.py startapp clubs
☐ python manage.py startapp members
☐ python manage.py startapp subscriptions
☐ python manage.py startapp attendance
☐ python manage.py startapp workouts
☐ python manage.py startapp finance
☐ python manage.py startapp notifications
☐ python manage.py startapp ai_agent
☐ Register all nine apps in INSTALLED_APPS; confirm python manage.py check passes
```
#### 1.7 Database Models

**accounts**
☐ CustomUser: id (UUIDField, primary_key), email (unique), phone, full_name, role (choices:
SUPER_ADMIN/ADMIN/RECEPTION/TRAINER/MEMBER), club (FK to Club, nullable),
is_active, date_joined
☐ Set AUTH_USER_MODEL = 'accounts.CustomUser' in settings BEFORE first migration
☐ CustomUserManager: override create_user() requiring email as username field; implement
create_superuser()
**clubs**
☐ Club: id (UUID), name, address, phone, email, logo (ImageField), timezone, working_hours
(JSONField: {mon:{open,close}, ...}), is_active, created_at
☐ ClubSettings: club (OneToOneField), qr_rotation_minutes (default 120), expiry_alert_days
(JSONField, default [7,3,1]), sms_enabled, fcm_enabled


**members**
☐ MemberProfile: user (OneToOneField to CustomUser), club (FK), date_of_birth, gender,
height_cm, weight_kg, training_level (BEGINNER/INTERMEDIATE/ADVANCED), injuries
(TextField), profile_photo, notes, status (ACTIVE/EXPIRED/FROZEN/SUSPENDED)
**subscriptions**
☐ Plan: id, club (FK), name, plan_type (MONTHLY/SESSION/ANNUAL/VIP/TRIAL), price,
duration_days, session_count (nullable), is_active
☐ Subscription: id, member (FK), plan (FK), start_date, end_date, sessions_total, sessions_used,
status, created_by (FK to User), created_at
☐ SubscriptionLog: subscription (FK), action
(CREATED/RENEWED/FROZEN/SUSPENDED/RESUMED/CANCELLED), performed_by,
timestamp, notes
**attendance**
☐ AttendanceLog: id, member (FK), club (FK), check_in_time (DateTimeField), date (DateField),
login_method (QR/MANUAL), device_identifier, sessions_remaining_snapshot (IntegerField),
subscription_status_snapshot, qr_token_hash
☐ QRToken: id, club (FK), token_hash (256-char, unique), created_at, expires_at, is_active
**finance**
☐ Payment: id, member (FK), club (FK), amount, payment_method (CASH/CARD/ONLINE),
reference_number, subscription (FK, nullable), recorded_by (FK), created_at
☐ Debt: member (FK), club (FK), amount_owed, due_date, is_settled, settled_at
**workouts**
☐ Exercise: id, name, muscle_group, description, video_url (nullable), difficulty, is_active
☐ WorkoutSession: id, member (FK), date, notes, is_completed, created_at
☐ WorkoutExercise: session (FK), exercise (FK), target_sets, target_reps, target_weight_kg,
actual_sets, actual_reps, actual_weight_kg, is_done, order
☐ Goal: member (FK), goal_type (FAT_LOSS/MUSCLE_GAIN/FITNESS/ENDURANCE),
target_value, target_unit, target_date, current_value, is_active, created_at
☐ BodyMetric: member (FK), date, weight_kg, notes
**notifications**
☐ Notification: recipient (FK), club (FK), title, body, notification_type, is_read, created_at,
deep_link_url (nullable)
☐ DeviceToken: user (FK), token (TextField), platform (IOS/ANDROID/WEB), created_at,
updated_at
☐ SMSLog: recipient_phone, message_body, status (SENT/FAILED), provider_response, sent_at
☐ Run: python manage.py makemigrations — all nine apps should generate initial migration files
☐ Run: python manage.py migrate — all tables should be created with zero errors
☐ Open psql and run \dt to confirm all expected tables exist

#### 1.8 Authentication: JWT

```
☐ Configure REST_FRAMEWORK: DEFAULT_AUTHENTICATION_CLASSES to
JWTAuthentication, DEFAULT_PERMISSION_CLASSES to IsAuthenticated
```

```
☐ Set SIMPLE_JWT: ACCESS_TOKEN_LIFETIME=15 minutes, REFRESH_TOKEN_LIFETIME=
days, ROTATE_REFRESH_TOKENS=True, BLACKLIST_AFTER_ROTATION=True
☐ Add 'rest_framework_simplejwt.token_blacklist' to INSTALLED_APPS and migrate
☐ Create accounts/views.py: LoginView (POST /api/v1/auth/login/), TokenRefreshView, LogoutView
(blacklists refresh token)
☐ Test with curl or Postman: obtain tokens, access a protected endpoint, refresh, logout, confirm
blacklisted token is rejected
```
#### 1.9 RBAC Permission Classes

```
☐ Create accounts/permissions.py with: IsClubAdmin, IsReception, IsTrainer, IsMember,
IsAdminOrReception — each checks request.user.role
☐ Apply the appropriate permission class to every ViewSet and APIView — never leave a view with
AllowAny unless it is intentionally public
☐ Write unit tests for each role attempting access to at least one restricted endpoint; all unauthorized
access must return 403
```
#### 1.10 URL Routing & API Structure

```
☐ Configure config/urls.py to include all app routers under /api/v1/
☐ Use DRF DefaultRouter in each app's urls.py for standard CRUD endpoints
☐ Standardize response envelope: {success: bool, data: {...}, message: str, errors: [...]}
☐ Enable django-cors-headers; set CORS_ALLOWED_ORIGINS from env; confirm preflight
OPTIONS requests work
```
#### 1.11 Core Tests

```
☐ Write model tests: test __str__, field defaults, and at least one validator per model in all nine apps
☐ Write API tests for auth: login with valid credentials, login with wrong password, access protected
route, refresh token, logout
☐ Confirm python manage.py test runs with zero failures before moving to Phase 2
→ Aim for 70%+ coverage on the accounts, clubs, members, and subscriptions apps before Phase 2
```

## 02

### Smart QR Attendance System

```
Weeks 3–5 · Dynamic Token, ESP32 Firmware, WebSocket Live Feed
```
#### 2.1 QR Token Service

```
☐ Create attendance/services.py; implement QRTokenService class
☐ generate_token(club_id): build payload {club_id, iat, exp}; sign with HMAC-SHA256 using a secret
key from env; hash the signed token; deactivate all previous QRToken records for this club;
insert new QRToken record with is_active=True
☐ validate_token(raw_token, club_id): verify HMAC signature; check exp timestamp against current
UTC time; look up token hash in QRToken table and confirm is_active=True and club_id
matches; return (is_valid: bool, reason: str)
→ Store only the hash in the database — never the raw signed token — to prevent leakage
☐ Create a Celery task rotate_club_qr_tokens: queries all active clubs, calls generate_token for
each
☐ Register the task in CELERY_BEAT_SCHEDULE with an interval read from
ClubSettings.qr_rotation_minutes
☐ Write tests: valid token passes, expired token fails, wrong club fails, tampered signature fails
```
#### 2.2 Attendance API Endpoints

```
☐ GET /api/v1/qr/current/{club_id}/ — authentication via device API key header (X-Device-Key);
returns {token_string, qr_image_base64, expires_at}; rate-limited to 1 request per minute per
device
☐ POST /api/v1/attendance/checkin/ — member JWT auth; body {qr_token, device_info}; full
validation chain; returns {success, member_name, photo_url, subscription_status,
sessions_remaining, message}
☐ POST /api/v1/attendance/manual/ — IsAdminOrReception; body {member_id, notes}; creates
AttendanceLog with login_method=MANUAL
☐ GET /api/v1/attendance/history/{member_id}/ — member or admin; paginated, filterable by date
range
☐ GET /api/v1/attendance/today/{club_id}/ — admin/reception; returns today's check-ins ordered by
time desc
```
#### 2.3 Check-In Business Logic

```
☐ In the checkin view, execute all 7 validation checks in this exact order — abort and return on first
failure:
→ (1) Token HMAC signature is valid
→ (2) Token has not expired (exp > now)
→ (3) Token club_id matches the URL or member's assigned club
→ (4) Member exists, is_active=True, and belongs to this club
→ (5) Subscription status is ACTIVE
→ (6) If session-based plan: sessions_used < sessions_total
→ (7) Rate limit: no AttendanceLog for this member within the last 30 minutes
```

```
☐ Wrap all DB writes in a single atomic transaction: create AttendanceLog, if session-plan increment
sessions_used, save snapshots
☐ After successful commit, fire WebSocket event to club channel (outside the transaction to avoid
blocking)
☐ Return a descriptive error code string for every failure reason (e.g., TOKEN_EXPIRED,
NO_SESSIONS, RATE_LIMITED)
```
#### 2.4 WebSocket Live Feed

```
☐ Create attendance/consumers.py: class AttendanceFeedConsumer(AsyncWebsocketConsumer)
☐ on connect: extract and validate JWT from query string; confirm user is ADMIN or RECEPTION
for the requested club_id; accept; add channel to group club_{club_id}_feed
☐ on disconnect: remove channel from group
☐ Create a helper function push_checkin_event(club_id, payload): calls channel_layer.group_send
to the club group
☐ Call push_checkin_event from the checkin view after a successful transaction
☐ Event payload: {type:'checkin.new', member_name, photo_url, check_in_time,
subscription_status, sessions_remaining}
☐ Register consumer in attendance/routing.py; add websocket route ws/attendance/{club_id}/feed/
in config/asgi.py
☐ Test with wscat or browser WebSocket: open socket, trigger check-in via API, confirm event
arrives within 1 second
```
#### 2.5 ESP32 Firmware

```
☐ Set up Arduino IDE with ESP32 board support package; install libraries: WiFi, HTTPClient,
ArduinoJson, GxEPD2 (E-Ink), qrcodegen
☐ Implement NVS (non-volatile storage) configuration: store WIFI_SSID, WIFI_PASSWORD,
SERVER_URL, CLUB_ID, DEVICE_API_KEY on first flash via serial config mode
☐ Implement Wi-Fi connection with auto-reconnect; blink onboard LED while connecting
☐ Implement HTTPS GET to /api/v1/qr/current/{club_id}/ with X-Device-Key header; parse JSON
response
☐ Generate QR code image from token_string using qrcodegen library
☐ Render QR to E-Ink display: center QR image, print club name and expiry time as text below
☐ Implement polling timer: every 5 minutes check if token has changed (compare new token_hash
to stored); only redraw if changed (E-Ink redraws are slow and visible)
☐ Implement offline indicator: if HTTP request fails 3 times consecutively, display a small 'Offline'
text in corner of screen
☐ Flash firmware to device; connect to test Wi-Fi; confirm display shows QR; trigger token rotation
on server; confirm display updates within next polling cycle
→ Provision one device per club. Factory-program each with its specific club_id and device_api_key
before deployment
```
#### 2.6 Anti-Fraud Tests

```
☐ Replay expired token → expect TOKEN_EXPIRED error
```

☐ Submit token with wrong club_id → expect CLUB_MISMATCH error
☐ Submit same valid token twice within 30 minutes → second returns RATE_LIMITED
☐ Submit valid token for member with expired subscription → expect SUBSCRIPTION_EXPIRED
☐ Submit valid token for member with 0 sessions → expect NO_SESSIONS_REMAINING
☐ Modify token payload bytes and submit → expect INVALID_SIGNATURE
☐ All six tests pass with correct HTTP status codes and error_code fields


## 03

### Club Admin Panel (Web)

```
Weeks 5–8 · React Dashboard, All Management Modules, Finance, Reports
```
#### 3.1 Project Bootstrap

```
☐ Initialize with Vite: npm create vite@latest admin-panel -- --template react inside /admin-panel
☐ Install: axios, react-router-dom v6, zustand, @tanstack/react-query, recharts,
@tanstack/react-table, date-fns, react-hot-toast, tailwindcss, react-hook-form, zod
☐ Configure Tailwind with brand color palette defined as custom CSS variables
☐ Create services/api.js: axios instance with base URL from env, request interceptor to attach
Bearer token, response interceptor to catch 401 and trigger token refresh
☐ Create store/authStore.js (Zustand): stores access_token, refresh_token, user object; actions:
login, logout, refreshToken
☐ Create hooks/useAuth.js: exposes auth state and actions; reads initial state from localStorage on
mount
```
#### 3.2 Auth & Shell

```
☐ Build LoginPage: controlled form, calls /api/v1/auth/login/, stores tokens, navigates to /dashboard
☐ Build AppShell: left sidebar with nav links (icons + labels), top bar with club logo and user avatar
dropdown, main scrollable content area
☐ Implement role-aware sidebar: compute visible nav items from user.role; hide Finance from
RECEPTION, hide all management from TRAINER
☐ Build ProtectedRoute wrapper component: if no token redirect to /login; if insufficient role show
403 page
☐ Implement auto token refresh: on 401 response, call /api/v1/auth/refresh/, update store, replay
original request — transparent to all other code
```
#### 3.3 Live Attendance Feed

```
☐ Build hooks/useAttendanceFeed.js: opens WebSocket, reconnects on close with exponential
backoff (max 30s), exposes a messages array (last 20 items)
☐ Build LiveFeedCard component: member photo (40px circle), name (bold), check-in time, status
badge (green=active, amber=last session, red=expired)
☐ Mount LiveFeedPanel on the Dashboard page — always visible; new cards slide in from top with a
CSS animation
☐ Show a connection status indicator (green dot = connected, red dot = reconnecting)
```
#### 3.4 Member Management

```
☐ Build MemberListPage: TanStack Table with columns photo, name, plan, status, expiry, sessions
remaining, actions; default sort by expiry ascending
☐ Build filter bar: status multi-select, plan type select, text search (debounced 300ms); state in URL
search params for shareability
```

```
☐ Build Add Member slide-over form: all MemberProfile fields, plan assignment, initial payment
recording; client-side validation with Zod
☐ Build MemberProfilePage with tabs: Overview, Attendance, Workouts, Payments
☐ Overview tab: personal details, active subscription card with progress bar, quick action buttons
(Renew, Freeze, Suspend, Manual Check-In)
☐ Attendance tab: paginated check-in list, monthly calendar heatmap
☐ Payments tab: payment history list, record payment button
☐ Build RenewModal: plan picker dropdown, price display, payment method radio buttons, confirm
button; on submit POST /api/v1/subscriptions/renew/
☐ Build FreezeModal: resume date picker, notes field; on submit PATCH
/api/v1/subscriptions/{id}/freeze/
☐ Implement Export: button calls GET /api/v1/members/export/?format=csv; browser downloads file
```
#### 3.5 Plan Management

```
☐ Build PlanListPage: table with all plans; active/inactive toggle switches directly in table
☐ Build PlanForm (add/edit): all Plan model fields with inline validation
☐ Show plan usage stats: number of active subscriptions per plan
```
#### 3.6 Finance Module

```
☐ Build PaymentListPage: paginated table; filter by date range, payment method, member name;
summary totals at top
☐ Build RecordPaymentModal: member async-search dropdown, amount input, method radio,
optional note; on submit POST /api/v1/finance/payments/
☐ Build DebtListPage: members with amount_owed > 0; quick Settle Debt button
☐ Build DailyReportPage: date picker, income breakdown card per payment method, transaction list
☐ Build MonthlyReportPage: year picker, recharts BarChart of monthly revenue, summary table
☐ Implement Excel export on both report pages: GET
/api/v1/finance/reports/export/?type=daily&date=...
```
#### 3.7 Dashboard

```
☐ Build six KPI cards with icons and trend arrow: Active Members, Expiring This Week, Today's
Revenue, Monthly Revenue, Attendance Today, Avg Sessions/Member
☐ Build PeakHoursHeatmap: 7-column (days) x 24-row (hours) grid, cells colored by attendance
density
☐ Build MembershipTrendChart: recharts LineChart, 12 months of active member counts
☐ Build RevenueBarChart: recharts BarChart, current year monthly revenue
☐ Build ExpiringMembersTable: members with expiry <= 7 days, one-click Renew button per row
☐ All data fetched with react-query; stale time 5 minutes; show skeleton loaders while loading
```
#### 3.8 Personnel & Audit


```
☐ Build StaffListPage: table of all staff with role badge, last login, status toggle
☐ Build StaffForm: email, name, role select, club assignment multi-select
☐ Build AuditLogPage: table of all admin panel actions (fetched from server); columns: staff user,
action, affected record, timestamp, IP; filterable by date and user
```
#### 3.9 Notifications

```
☐ Build SendMessagePage: recipient type toggle (Individual/Group/Segment); message composer
with character counter for SMS; preview panel; send button
☐ Build AutomationSettings: toggle cards for each automated alert (expiry SMS, expiry push, streak
reminder); configure threshold values
☐ Build NotificationHistoryPage: log of all sent notifications with status and recipient count
```
#### 3.10 Club Settings

```
☐ Build ClubSettingsPage: club name, logo upload with preview, address, phone, per-day
open/close time pickers
☐ Build SystemSettingsPage: QR rotation interval slider (30–240 min), expiry alert days multi-select,
backup configuration
☐ Implement logo upload: multipart POST; show preview immediately on selection before upload
```

## 04

### Member Mobile Application

```
Weeks 7–11 · React Native, QR Scanner, Workout Tracker, Gamification, PWA
```
#### 4.1 Project Setup

```
☐ Initialize: npx react-native init ClubApp --template react-native-template-typescript in /mobile-app
☐ Install navigation: @react-navigation/native, @react-navigation/bottom-tabs,
@react-navigation/native-stack
☐ Install: axios, zustand, @tanstack/react-query, react-native-vision-camera (QR scanning),
@notifee/react-native, @react-native-async-storage/async-storage, react-native-charts-wrapper,
react-native-vector-icons, date-fns, react-native-video
☐ Configure Metro bundler for TypeScript; ensure both Android emulator and iOS simulator launch
without errors
☐ Create folder structure: /src/screens, /src/components, /src/hooks, /src/services, /src/store,
/src/navigation, /src/utils, /src/types
☐ Create src/services/api.ts: Axios instance, JWT attach interceptor, 401 auto-refresh interceptor,
error normalization
☐ Create src/store/authStore.ts (Zustand): tokens, user, login(), logout(), refreshToken()
```
#### 4.2 Authentication Screens

```
☐ Build SplashScreen: reads token from AsyncStorage; if valid navigate to MainTabs, else navigate
to Login
☐ Build LoginScreen: phone/email + password; POST /api/v1/auth/login/; store tokens; navigate to
Home or ProfileSetup if first login
☐ Build ProfileSetupScreen: height, weight, training level picker, injuries multi-select, primary goal
picker; POST /api/v1/members/profile/setup/
```
#### 4.3 Bottom Navigation & Home

```
☐ Build bottom tab navigator with 4 tabs: Home, Workout, Progress, Profile; each with icon and label
☐ Build HomeScreen: greeting with member name, subscription status card (colored by urgency),
today's workout summary card, streak counter, AI weekly review card (Mon only), reminders list
☐ Subscription card: if days <= 7 or sessions <= 3, show amber/red color with 'Renew Now' button
deep-linking to renewal flow
```
#### 4.4 QR Check-In Screen

```
☐ Build CheckInScreen: full-screen VisionCamera viewfinder; overlay with targeting reticle and
instructional text
☐ Request CAMERA permission on first open with a clear, friendly explanation of why it is needed
☐ On QR frame detected: extract decoded string; immediately call POST
/api/v1/attendance/checkin/; disable scanner to prevent double submission
```

```
☐ On API success: show full-screen success overlay — green check animation, member name,
sessions remaining; auto-dismiss after 3 seconds
☐ On API failure: show error screen with human-readable message mapped from error_code;
include 'Need Help?' button
☐ Add 'Can’t Scan?' link that opens a contact form or displays a member ID for manual lookup by
staff
```
#### 4.5 Profile Screen

```
☐ Build ProfileScreen: member photo (tappable to change), name, member ID number
☐ Subscription card: plan name, status badge, expiry date, circular progress chart of sessions
used/total
☐ Personal QR card: display a static QR encoding the member's user ID; staff can scan this for
manual check-in lookup
☐ Attendance History tab: FlatList of past check-ins; monthly calendar view toggle (highlight
attended days in green)
☐ Edit Profile button: opens slide-up form for name, photo, height/weight, injuries; PATCH
/api/v1/members/profile/
```
#### 4.6 Workout Screen (Daily Core Feature)

```
☐ Build WorkoutScreen: queries today's WorkoutSession; if none exists, show 'Start Today’s
Workout' button
☐ 'Start' button: POST /api/v1/workouts/sessions/ to create today's session; then show exercise list
☐ Exercise list: FlatList of WorkoutExercise records for the session; each row shows exercise name,
target sets×reps @ weight, and a checkbox
☐ Tapping a row opens SetLoggerBottomSheet: number inputs for actual sets, reps, weight; Done
button PATCHes the WorkoutExercise record
☐ Checking the exercise checkbox marks it is_done=True; animate checkmark; update progress bar
at top of screen
☐ When all exercises checked: show completion celebration screen with session volume total and a
streak update message
☐ 'Copy Last Week' button at screen top: GET /api/v1/workouts/sessions/last-week/; POST to create
today's session with same exercises
☐ Build WorkoutHistoryScreen: list of past sessions by date; tap to expand and see exercises
performed
☐ Build ExerciseLibraryScreen: searchable FlatList with muscle group filter tabs; tap exercise to see
description and video
```
#### 4.7 Goal & Progress Screens

```
☐ Build GoalScreen: display active goal card (type, target, deadline, progress bar); 'Set New Goal'
button at top
☐ SetGoalForm: goal type picker, target value input, target date picker; POST
/api/v1/workouts/goals/
☐ AI assessment widget below goal: shows coach's evaluation of whether the goal pace is realistic
(fetched from /api/v1/agent/goal-assessment/)
```

```
☐ Build ProgressScreen with tabs: Body, Volume, Consistency
☐ Body tab: weight entry form; LineChart of weight over time (last 90 days)
☐ Volume tab: BarChart of weekly total volume (kg lifted) for last 8 weeks; personal records list
☐ Consistency tab: monthly calendar grid (green = trained, gray = rest, red = missed target); weekly
session count vs. goal
```
#### 4.8 Gamification

```
☐ Build StreakWidget (shown on HomeScreen and ProfileScreen): flame icon, number of
consecutive days, best streak record
☐ Build BadgesScreen: grid layout; awarded badges shown in full color with earned date; locked
badges shown as gray silhouettes with achievement description
☐ Define all badge triggers in backend (attendance/badges.py): FirstCheckin, Week1, Week4,
Sessions100, GoalSet, FirstWorkoutCompleted, ConsistencyMonster (20 sessions/month)
☐ Create Celery task check_badge_eligibility(member_id): called after every check-in and every
workout completion; awards new badges; pushes a push notification and in-app notification for
each new badge
☐ Build LeaderboardScreen: monthly ranking by check-in count; only show if club has
leaderboard_enabled=True in ClubSettings
☐ Build MonthlyChallengeCard on HomeScreen: progress bar toward current month's challenge
target with days remaining
```
#### 4.9 Push Notifications

```
☐ Configure Firebase project; download google-services.json for Android and
GoogleService-Info.plist for iOS; add to respective platform directories
☐ On successful login: POST /api/v1/notifications/register-device/ with {token, platform}; update if
token changes
☐ Build Celery task daily_workout_reminder: 7 PM daily, find members who have a scheduled
workout today but no check-in yet; send push via FCM
☐ Build Celery task subscription_expiry_alerts: 9 AM daily, find members expiring in 7, 3, 1 days;
send push notification and optionally SMS
☐ Build Celery task streak_risk_alert: 8 PM daily, find members with 3+ day streaks who haven't
trained today; send motivational push
☐ Build NotificationsScreen: FlatList of received in-app notifications; tap to mark read; unread count
badge on Profile tab icon
```
#### 4.10 Tutorial Library

```
☐ Build TutorialScreen: category cards (Chest, Back, Legs, etc.) as a 2-column grid
☐ Build TutorialListScreen per category: cards with thumbnail, title, duration badge
☐ Build VideoPlayerScreen: react-native-video player in fullscreen; show title and tips below
☐ Add 'Coach Picks' section on HomeScreen: 2–3 videos recommended by the AI Agent based on
current workout program
```

#### 4.11 Android APK

```
☐ Generate release keystore: keytool -genkeypair -v -storetype PKCS12 -keystore release.keystore
-alias clubapp
☐ Configure signing in android/app/build.gradle reading keystore path, alias, and passwords from
environment variables
☐ Run: cd android && ./gradlew bundleRelease (AAB) or assembleRelease (APK)
☐ Install APK on a physical Android device; run through full end-to-end flow to confirm all screens
work
☐ Host APK file at a stable HTTPS URL on your server; create a simple download landing page
```
#### 4.12 iOS PWA

```
☐ Build a responsive React web app (using the same design language as the native app) in
/mobile-app/web
☐ Create /public/manifest.json: name='Club App', short_name, icons at 192 and 512px,
display='standalone', start_url='/', background_color, theme_color
☐ Add to index.html: <link rel='manifest'>, apple-touch-icon meta tags,
apple-mobile-web-app-capable, theme-color
☐ Implement service worker (Workbox) caching: cache all static assets and the last loaded workout
data for offline use
☐ Test on physical iPhone in Safari: tap Share → Add to Home Screen; confirm app launches
without browser chrome and feels native
☐ Ensure all interactions work correctly with iOS tap targets (minimum 44x44pt) and safe area insets
```

## 05

### AI Agent — Smart Trainer

```
Weeks 10–13 · Context Engine, LLM Integration, Personalized Outputs, Attrition
Detection
```
#### 5.1 Context Assembly Engine

```
☐ Create ai_agent/context_builder.py with function build_member_context(member_id: UUID) -> dict
☐ Section 1 — Personal Profile: fetch age (from date_of_birth), gender, height_cm, weight_kg,
training_level, injuries
☐ Section 2 — Active Goal: goal_type, target_value, target_unit, target_date, current_value,
days_remaining, percent_complete
☐ Section 3 — Training History (last 30 days): list of WorkoutSessions; for each: date, is_completed,
list of exercises with actual_sets/reps/weight
☐ Section 4 — Attendance History (last 30 days): list of check-in dates; derive
training_days_last_30, avg_weekly_sessions, current_streak, longest_streak_in_period
☐ Section 5 — Subscription Status: plan_type, status, sessions_remaining, days_to_expiry
☐ Section 6 — Computed Metrics: total_volume_last_7_days (sum of sets*reps*weight),
consistency_score (trained_days / 30 * 100), is_increasing_volume (compare last 2 weeks),
recent_rest_days (count of days with no training in last 7)
☐ Serialize the complete context to a compact JSON string; confirm it is under 4000 tokens to stay
within LLM context limits
```
#### 5.2 LLM Integration

```
☐ Choose provider (OpenAI GPT-4o or Anthropic Claude API); store API key in env as
LLM_API_KEY
☐ Create ai_agent/llm_client.py: async function call_llm(system_prompt: str, user_message: str,
max_tokens: int = 800) -> str
☐ Implement retry logic: on HTTP 429 (rate limit), wait with exponential backoff up to 3 retries; on
5xx server errors, raise immediately
☐ Implement Redis-based response caching: key = SHA256(system_prompt + user_message); TTL
= 30 minutes; skip cache for personalized one-off messages
☐ Log all LLM calls in a model AIRequestLog: member, prompt_hash, tokens_used,
response_time_ms, created_at — for cost monitoring
```
#### 5.3 Prompt Templates

```
☐ Create ai_agent/prompts.py with a PromptLibrary class
☐ SYSTEM_BASE: establishes role (personal trainer), enforces data-driven responses, forbids
generic internet advice, instructs to respond in the member's language
☐ WORKOUT_RECOMMENDATION: include context JSON block; instruct to generate a specific
workout for today based on last week's sessions, recovery status, and goals; output as a
structured JSON list of {exercise_name, sets, reps, weight_kg, notes}
☐ GOAL_ASSESSMENT: include context; instruct to assess whether current pace will meet the goal
by the target date; if not, provide a revised plan
```

```
☐ WEEKLY_REVIEW: include context; instruct to write a 3-paragraph personal summary of last
week (what was good, what to improve, what to focus on this week)
☐ CHAT_ASSISTANT: general chat; include context; answer questions using only the provided data
☐ RE_ENGAGEMENT: include context of a dormant member; write a short, warm, specific message
referencing their last workout and their goal to encourage return
☐ Test each template with 3 different member contexts; verify outputs are specific, not generic, and
reference real data from the context
```
#### 5.4 Agent API Endpoints

```
☐ POST /api/v1/agent/chat/ — member auth; body {message}; builds context, calls
CHAT_ASSISTANT prompt; returns {response: str}
☐ GET /api/v1/agent/workout-recommendation/ — member auth; builds context, calls
WORKOUT_RECOMMENDATION prompt; returns {exercises: [...]}
→ Cache workout recommendation per member per day — no need to regenerate if context hasn't
changed
☐ GET /api/v1/agent/goal-assessment/ — member auth; calls GOAL_ASSESSMENT prompt;
returns {assessment: str, on_track: bool, adjusted_plan: str}
☐ GET /api/v1/agent/weekly-review/ — member auth; calls WEEKLY_REVIEW prompt; cache per
member per day (invalidate Monday morning); returns {review: str}
```
#### 5.5 Mobile App AI Screens

```
☐ Build AgentChatScreen: chat bubble UI; user messages right-aligned (blue), agent messages
left-aligned (gray); typing indicator (animated dots) while awaiting response; send button
☐ Build WorkoutSuggestionBanner on WorkoutScreen: shows AI plan for today when no session
exists; 'Use This Plan' button creates session with the AI's exercises pre-populated
☐ Build GoalAssessmentWidget on GoalScreen: coach bubble with assessment text and on_track
boolean indicator (green checkmark or amber warning)
☐ Build WeeklyReviewCard on HomeScreen: shown every Monday; expandable card with full review
text; 'Dismiss' button
```
#### 5.6 Attrition Detection

```
☐ Create Celery task detect_at_risk_members(): runs daily at 9 AM
☐ Query logic: member has checked in at least 8 times in the prior 30 days (showing engagement
history), but has not checked in at all in the last 10 days
☐ For each at-risk member: build context, call RE_ENGAGEMENT prompt, create a Notification
record and send a push notification
☐ Set MemberProfile.last_attrition_nudge = today; skip members nudged within the last 7 days to
prevent notification fatigue
☐ Add 'At Risk Members' widget to admin dashboard: count of flagged members, list with last
check-in date and link to profile
☐ Add an admin action on MemberProfilePage: 'Send Re-engagement Message' to manually trigger
the AI message for any member
```

## 06

### Production Infrastructure & Launch

```
Weeks 12–14 · Docker, Nginx, SSL, CI/CD, Security, QA, Go-Live
```
#### 6.1 Containerization

```
☐ Write Dockerfile for Django: python:3.11-slim base; install dependencies from requirements.txt;
copy source; run collectstatic; CMD gunicorn config.wsgi --bind 0.0.0.0:
☐ Write Dockerfile for Daphne (ASGI/WebSocket): same base; CMD daphne -b 0.0.0.0 -p 8001
config.asgi:application
☐ Write Dockerfile for Celery worker: same base; CMD celery -A config worker --loglevel=info
☐ Write Dockerfile for Celery beat: same base; CMD celery -A config beat --scheduler
django_celery_beat.schedulers:DatabaseScheduler
☐ Write docker-compose.yml: services: db (postgres:15 with health check), redis (redis:7-alpine),
web (Django), daphne, celery_worker, celery_beat, nginx; all backend services depend_on db
and redis health checks
☐ Write nginx/nginx.conf: listen 80; upstream gunicorn port 8000; upstream daphne port 8001; serve
/static/ and /media/ from mapped volumes; proxy /api/ and /django-admin/ to gunicorn; proxy /ws/
to daphne with WebSocket upgrade headers
☐ Run docker-compose up locally; confirm all services start, migrations run, and you can reach the
API at localhost
```
#### 6.2 Production Server

```
☐ Provision VPS: minimum 4 vCPU, 8 GB RAM, 100 GB SSD, Ubuntu 22.04 LTS
☐ Create non-root deploy user; add to docker group; disable root SSH login; enforce SSH key-only
authentication
☐ Install Docker CE and Docker Compose Plugin
☐ Point domain DNS A record to server IP; confirm with dig
☐ Install Certbot: apt install certbot python3-certbot-nginx; obtain certificate for your domain
☐ Nginx configuration: redirect HTTP → HTTPS; serve SSL certificate
☐ UFW firewall: ufw allow 22/tcp (SSH); ufw allow 80/tcp; ufw allow 443/tcp; ufw enable
```
#### 6.3 Environment & First Deploy

```
☐ Create /etc/clubms/.env on the server with all production values; chmod 600; chown deploy_user
☐ Required env vars: SECRET_KEY, DEBUG=False, ALLOWED_HOSTS, DATABASE_URL,
REDIS_URL, CORS_ALLOWED_ORIGINS, EMAIL_HOST/USER/PASSWORD,
SMS_PROVIDER_KEY, LLM_API_KEY, FCM_SERVER_KEY, DEVICE_API_KEY
☐ Clone the repository to /home/deploy/clubms
☐ Run docker-compose -f docker-compose.yml -f docker-compose.prod.yml up --build -d
☐ Run migrations: docker exec clubms_web python manage.py migrate
☐ Create superuser: docker exec -it clubms_web python manage.py createsuperuser
☐ Confirm admin panel is reachable at https://yourdomain.com/django-admin/ and API at
https://yourdomain.com/api/v1/health/
```

#### 6.4 CI/CD Pipeline

```
☐ Create .github/workflows/ci.yml: trigger on push to any branch; steps: checkout, setup Python,
install dependencies, run flake8, run pytest, upload coverage to Codecov
☐ Create .github/workflows/deploy.yml: trigger on push to main; steps: SSH to server, git pull,
docker-compose build, docker-compose up -d, run migrate
☐ Store SSH_PRIVATE_KEY, SERVER_HOST, SERVER_USER, and all production secrets as
GitHub Actions encrypted secrets
☐ Add branch protection rule on main: require CI to pass, require at least one code review approval
```
#### 6.5 Monitoring

```
☐ Add sentry-sdk to requirements.txt; configure DSN from env in Django settings; add
SentryAsgiMiddleware
☐ Add Sentry to React admin panel: @sentry/react; wrap App with ErrorBoundary
☐ Add Sentry to React Native app: @sentry/react-native; initialize in App.tsx
☐ Create GET /api/v1/health/ endpoint: checks DB connection, Redis ping, and Celery worker
heartbeat; returns {status, db, redis, celery}
☐ Set up UptimeRobot (free tier) monitoring the /health/ endpoint; configure email alert on downtime
☐ Configure log rotation for Django, Nginx, and Docker logs: logrotate config with daily rotation and
14-day retention
```
#### 6.6 Database Backups

```
☐ Write backup script: pg_dump -Fc clubms_db > backup_$(date +%Y%m%d_%H%M%S).dump
☐ Set up cron job on server: 0 3 * * * /home/deploy/scripts/backup.sh (daily at 3 AM)
☐ Configure S3 bucket (or equivalent) for backup storage; install aws-cli; upload after each dump
☐ Test full restore: copy latest dump to a staging database, restore with pg_restore, verify data
integrity
☐ Document the complete restore procedure in /docs/runbook.md and commit to repository
```
#### 6.7 Security Hardening

```
☐ Confirm DEBUG=False; run python manage.py check --deploy; fix all warnings
☐ Ensure all Django security headers are set: SECURE_SSL_REDIRECT,
SECURE_HSTS_SECONDS, SESSION_COOKIE_SECURE, CSRF_COOKIE_SECURE,
X_FRAME_OPTIONS='DENY'
☐ Apply DRF throttling: 10 requests/minute on login endpoint per IP; 5 requests/minute on QR
check-in per user
☐ Implement account lockout: after 5 failed login attempts, lock account for 15 minutes; log lockout
events
☐ Audit every API endpoint: confirm no endpoint leaks data across club boundaries; write a test that
verifies Club A admin cannot access Club B data
```

```
☐ Confirm all file upload endpoints validate file type (whitelist) and file size (max 5 MB); store in
/media/ directory, never /static/
☐ Run OWASP ZAP automated scan against staging environment; remediate all High and Medium
severity findings before go-live
```
#### 6.8 End-to-End QA

```
Complete these full end-to-end scenarios before go-live:
☐ E2E 1: New member joins → admin assigns plan → member checks in via QR → admin
live feed shows the check-in → member views attendance history in app
☐ E2E 2: Subscription expires → member attempts check-in → rejected with correct error →
admin renews and records payment → member checks in successfully
☐ E2E 3: Admin records partial payment → debt appears in Finance → admin settles debt
→ debt resolved
☐ E2E 4: Member logs one full week of workouts → progress charts update → AI weekly
review appears Monday → AI workout suggestion displayed
☐ E2E 5: ESP32 powers on → connects to Wi-Fi → fetches QR → displays on E-Ink →
token rotates → display updates
☐ E2E 6: Member earns a badge → receives push notification → badge appears on Badges
screen
☐ E2E 7: Member goes inactive 10 days → Celery attrition task runs → re-engagement
push is received → message appears in app notifications
☐ Load test: simulate 50 concurrent QR check-ins; confirm all succeed within 3 seconds; confirm
WebSocket fan-out delivers to connected admin panels
☐ Test push notifications on a physical Android device (via APK) and a physical iOS device (via
PWA)
☐ Test SMS delivery for a subscription expiry alert end-to-end
☐ Verify GDPR compliance: confirm member data export works; confirm account deletion removes
PII
☐ Conduct a 2-week soft launch with one real club before full rollout
```
#### 6.9 Launch

```
☐ Train club admin staff: 30-minute guided walkthrough of the admin panel
☐ Train reception staff: 10-minute quick-reference session on check-in, renewal, and member lookup
☐ Create an in-app onboarding walkthrough for new members: 4-step tooltip tour highlighting QR
scan, workout log, goal setting, and AI chat
☐ Set up a support channel (WhatsApp or Intercom) for club staff to report issues post-launch
☐ Deploy production release; confirm all systems green on the monitoring dashboard
☐ Tag release: git tag -a v1.0.0 -m 'Initial production release' && git push origin v1.0.
☐ Announce go-live to club staff and members
```

**Club Management System · Implementation Checklist v1.0**
_Each_ ☐ _is a single concrete, deliverable, testable task._


