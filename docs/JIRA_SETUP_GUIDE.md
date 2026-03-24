# Jira Setup Guide for SaaS Project

This guide tells you exactly how to **remove the existing Jira project**, **create the new one**, and **use Jira** for this Flutter SaaS **website**. All choices below are decided for you—just follow the steps.

---

## Fresh start (do this once)

To **remove the old setup** and get a **new project** with all Epics and Stories created for you:

**1. In Jira (in your browser)**  
- Open project **S1** → **Project settings** (gear) → **Archive project** → confirm.  
- **Projects** → **Create project** → **Software** → **Scrum** → Name: **SaaS Website**, Key: **SAAS** → **Create**.

**2. In this repo**  
- Copy `.env.example` to `.env`:  
  `cp .env.example .env`  
- Edit `.env`: set `JIRA_EMAIL` and `JIRA_API_TOKEN` (get a token from [Atlassian API tokens](https://id.atlassian.com/manage-profile/security/api-tokens)).  
- Keep `JIRA_DOMAIN=niroopk.atlassian.net` (or your Jira domain).  
- Set `JIRA_PROJECT_KEY` to your existing SaaS project’s key (e.g. **S1** for “SaaS #1”).

**3. Create all tickets**  
From the repo root run:

```bash
node scripts/create-jira-tickets.mjs
```

Then open your **SaaS** project in Jira (e.g. **S1**) → **Backlog** or **Board**. You should see 6 Epics and 13 Stories. Link any Story to its Epic in Jira if needed (edit Story → Epic link).

---

## Company-level setup (new project + UI vs Functionality)

Use this when you want a **new Jira project** and a **full company-style breakdown**: UI work first, then functionality, with labels and Epics.

**What you get**

- **New project**: **SaaS Website** (key **SAAS**), Scrum.
- **6 Epics**: Authentication, Dashboard, User & account, Subscriptions & billing, Notifications & reminders, Reports & analytics.
- **25 Stories** split by:
  - **[UI]** – screens and layout (e.g. “[UI] Login screen – email & password fields, submit, validation”).
  - **[Functionality]** – API, flows, backend (e.g. “[Functionality] Login API integration & session”).
- **Labels** on every story: `ui` or `functionality`, plus area (`auth`, `dashboard`, `settings`, `billing`, `notifications`, `reports`) for filtering.

**Steps**

1. **Create the new project in Jira** (if you don’t have it yet)  
   **Projects** → **Create project** → **Software** → **Scrum** → Name: **SaaS Website**, Key: **SAAS** → **Create**.  
   *(If your Jira user is admin, you can instead set `JIRA_CREATE_PROJECT=true` in `.env` and the script will try to create the project.)*

2. **Point the script at the new project**  
   In `.env`: set `JIRA_PROJECT_KEY=SAAS`.

3. **Run the full setup**  
   From the repo root:
   ```bash
   node scripts/setup-jira-full.mjs
   ```

4. **In Jira**  
   Open project **SAAS** → **Backlog** or **Board**. Use filters/labels: `ui`, `functionality`, `auth`, `dashboard`, etc. Do UI stories first, then functionality.

Data and script: **`scripts/jira-full-structure.json`** (edit to add/change stories), **`scripts/setup-jira-full.mjs`**.

---

## Structured tickets with small tasks (UI + Functionality)

For **Epics → Stories → small task Subtasks** (UI and functionality split, with granular tasks):

1. **Create project** in Jira: **SaaS Website**, key **SAAS**, Scrum (if you don’t have it).
2. In **`.env`**: set **`JIRA_PROJECT_KEY=SAAS`**.
3. Run:
   ```bash
   node scripts/setup-jira-with-tasks.mjs
   ```
4. In Jira (**SAAS**): you get **6 Epics**, **25 Stories** (with `ui` / `functionality` labels), and **~80 Subtasks** (small tasks under each story). Filter by **ui** or **functionality** and work through tasks in order.

---

## Decisions (already made)

| Choice | Decision | Why |
|--------|-----------|-----|
| **Template** | **Scrum** | Sprints give clear iterations, a backlog, and velocity; fits feature-based work. |
| **Project name** | **SaaS Website** | Clear and short. |
| **Project key** | **SAAS** | Short, uppercase; issue keys will be SAAS-1, SAAS-2, … |
| **Old project S1** | **Archive** (don’t delete) | Keeps history; you can restore from Archived projects if needed. |
| **Workflow** | To Do → In Progress → In Review → Done | In Review supports code review before marking done. |
| **Issue types** | Use Jira defaults | Epic, Story, Task, Bug, Subtask—no need to add more at the start. |
| **Labels** | Use the set below | For filtering (auth, dashboard, flutter, api, ui, web). |

---

## Part 1: Remove the Existing Jira Setup

You have project **S1** (“SaaS #1”) with 14 issues and board “S1 board”.

**Do this:** Archive it (do not delete).

1. Open project **S1**.
2. Go to **Project settings** (gear next to the project name).
3. In the left sidebar: **Features** or **General** → find **Archive project**.
4. Click **Archive project** and confirm.
5. The project disappears from the list; you can find it later under **Archived projects** if needed.

Then create the new project as in Part 2.

---

## Part 2: Create the New Jira Project

### 2.1 Create the project

1. **Projects** → **Create project**.
2. Choose **Software**.
3. Select **Scrum**.
4. Click **Use template** (or **Next**).
5. Set:
   - **Project name**: `SaaS Website`
   - **Project key**: `SAAS`
   - **Lead**: you or the project owner
6. Click **Create**.

A backlog and a Scrum board are created automatically.

### 2.2 Board and workflow

- **Board**: Open **Board** from the project sidebar. Columns will match the workflow (e.g. To Do, In Progress, In Review, Done).
- If your template only has To Do / In Progress / Done, you can add **In Review** later in **Project settings** → **Workflows** (company-managed) or the equivalent in team-managed projects.
- **Backlog**: All work lives here until you add it to a sprint. Use **Backlog** in the sidebar.

### 2.3 Sprints

- In **Backlog**, click **Create sprint** (or **Start sprint** when you have one).
- Use a fixed length (e.g. **2 weeks**). Set it in **Board** → **Board settings** (cog) → **Sprint length**.
- Each sprint: move issues from Backlog into the sprint, start the sprint, then move cards across the board as you work. When the sprint ends, start the next one.

---

## Part 3: How to Use Jira for This Project

### 3.1 Hierarchy

- **Epic** = big area (e.g. Authentication, Dashboard).
- **Story** = one user-facing outcome (e.g. “User can reset password via email”).
- **Task** = concrete piece of work; **Subtask** = under a Story or Task.
- **Bug** = something broken.

Link Stories to Epics with the **Epic link** (or Parent) field.

### 3.2 Workflow

- **To Do** – not started.
- **In Progress** – someone is working on it.
- **In Review** – implemented, awaiting review (optional column).
- **Done** – finished.

Move cards on the board when status changes. Assign the **Assignee** so ownership is clear.

### 3.3 Habits

- One issue = one deliverable (one story or one task).
- Write a short **Summary** and **Description**; for Stories, add **Acceptance criteria**.
- Use **Labels** and **Components** so you can filter (e.g. by `auth`, `dashboard`).
- Plan work in the **Backlog**, then pull into the current **Sprint**; run a short retrospective at the end of each sprint.

---

## Part 4: Structure for This SaaS Website

Use this structure in the new **SAAS** project.

### Epics (create these first)

| Epic name | Description |
|-----------|-------------|
| Authentication | Login, OTP, forgot/reset password, session handling |
| Dashboard | Main site home, navigation, base layout |
| User & account | Profile, settings, members |
| Subscriptions & billing | Plans, renewals, payment |
| Notifications & reminders | Browser/email, on-site reminders |
| Reports & analytics | Reporting screens |

### Stories (create under each Epic)

**Authentication**

- User can log in with email and password.
- User can request password reset and set a new password via email.
- User can sign in with OTP (if you support it).
- Session persists when user returns to the site (e.g. across tabs or refreshes).

**Dashboard**

- User sees the dashboard/home page with [your main sections].
- User can navigate to [main areas] from the dashboard.

**User & account**

- User can update profile and settings.
- Admin can manage members (if applicable).

**Subscriptions & billing** (adjust to what you build)

- User can view current plan and subscription.
- User can see renewal date and history (if applicable).

**Notifications & reminders**

- User receives browser/email notifications (if applicable).
- User can manage reminders or alerts on the site (if applicable).

**Reports & analytics**

- User (or admin) can view [reports you plan] on the site (if applicable).

Under each Story, add **Tasks** or **Subtasks** for the actual work (e.g. “Connect forgot-password page to Supabase”, “Add loading state on login”).

### Labels to use

Use these so you can filter and report:

`auth` · `dashboard` · `settings` · `api` · `ui` · `flutter` · `web`

Optional: **Components** such as `login`, `dashboard`, `settings` (in Project settings → Components).

### First steps in the new project

1. Create the **Epics** (table above).
2. Create the **Stories** under each Epic.
3. Add **Tasks/Subtasks** for the next 1–2 sprints.
4. Put everything else in the **Backlog** and pull into sprints as you go.

---

## Part 5: Quick Reference

| Goal | Where |
|------|--------|
| Create issue | **+ Create** (top) or from Backlog/Board |
| Backlog | Project → **Backlog** |
| Board | Project → **Board** |
| Create / start sprint | **Backlog** → Create sprint / Start sprint |
| Project settings | Gear next to project name |
| Archive project | Project settings → **Archive project** |
| Workflows | Project settings → **Workflows** |

---

## Summary

1. **Archive** project **S1** (Project settings → Archive project).
2. **Create** project: Software → **Scrum** → name **SaaS Website**, key **SAAS**.
3. **Use** Epics → Stories → Tasks/Subtasks; Backlog + Sprints + Board; workflow To Do → In Progress → In Review → Done.
4. **Populate** with the Epics and Stories in Part 4, then break work into Tasks and run 2-week sprints.

Follow this and your Jira is set up the right way for this project.

---

## Apply this guide (checklist)

Do these in order in Jira. Tick when done.

**Clean up**

- [ ] Open project **S1** → **Project settings** (gear) → **Archive project** → confirm.

**Create project**

- [ ] **Projects** → **Create project** → **Software** → **Scrum** → **Use template**.
- [ ] Name: **SaaS Website**, Key: **SAAS**, Lead: (you). **Create**.

**Create Epics** (Backlog → Create → Epic; link Stories to Epic later)

- [ ] Epic: **Authentication** — Login, OTP, forgot/reset password, session handling.
- [ ] Epic: **Dashboard** — Main site home, navigation, base layout.
- [ ] Epic: **User & account** — Profile, settings, members.
- [ ] Epic: **Subscriptions & billing** — Plans, renewals, payment.
- [ ] Epic: **Notifications & reminders** — Browser/email, on-site reminders.
- [ ] Epic: **Reports & analytics** — Reporting screens.

**Create Stories** (Create → Story; set Epic link to the Epic above)

- [ ] **Authentication:** User can log in with email and password.
- [ ] **Authentication:** User can request password reset and set new password via email.
- [ ] **Authentication:** User can sign in with OTP (if you support it).
- [ ] **Authentication:** Session persists when user returns to the site.
- [ ] **Dashboard:** User sees dashboard/home page with main sections.
- [ ] **Dashboard:** User can navigate to main areas from the dashboard.
- [ ] **User & account:** User can update profile and settings.
- [ ] **User & account:** Admin can manage members (if applicable).
- [ ] **Subscriptions & billing:** User can view current plan and subscription.
- [ ] **Subscriptions & billing:** User can see renewal date and history (if applicable).
- [ ] **Notifications & reminders:** User receives browser/email notifications (if applicable).
- [ ] **Notifications & reminders:** User can manage reminders/alerts on the site (if applicable).
- [ ] **Reports & analytics:** User/admin can view reports on the site (if applicable).

**Ongoing**

- [ ] Add **Tasks/Subtasks** under Stories for current work.
- [ ] Add labels: `auth`, `dashboard`, `settings`, `api`, `ui`, `flutter`, `web`.
- [ ] Set **Board** sprint length to 2 weeks; create first sprint and pull in work.

---

## Create tickets automatically (script)

To create all **Epics** and **Stories** from this guide in one go, use the script in the repo.

**1. Get a Jira API token**

- Go to [Atlassian API tokens](https://id.atlassian.com/manage-profile/security/api-tokens).
- Click **Create API token**, name it (e.g. “Script”), copy the token.

**2. Set environment variables**

```bash
export JIRA_DOMAIN=niroopk.atlassian.net
export JIRA_EMAIL=your-email@example.com
export JIRA_API_TOKEN=your-api-token
```

Use your real Jira domain (from the Jira URL) and the email you use to log in.

**3. Run the script**

```bash
node scripts/create-jira-tickets.mjs
```

- By default the script uses project **S1** (your existing “SaaS #1” project). Set `JIRA_PROJECT_KEY` in `.env` to your project key if different.

**4. Check Jira**

Open your project (**S1** or **SAAS**) → **Backlog** or **Board**. You should see 6 Epics and 13 Stories. If your project is “next-gen”, Stories might not be linked to Epics automatically; link them in Jira (edit Story → set Epic link / parent).
