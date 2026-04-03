# saas

A Flutter SaaS website (web).

## Docs

- **[Jira setup](docs/JIRA_SETUP_GUIDE.md)** — Company-style: new project, Epics, and **UI vs Functionality** breakdown. Run `node scripts/setup-jira-full.mjs` (see guide for new project **SAAS** or use existing S1).

## Getting Started

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter documentation](https://docs.flutter.dev/)

---

## Deploying the web app (so you see the app, not this README)

GitHub Pages will show your **Flutter app** only if the site is built and deployed by the workflow. Do this **once**:

### 1. Set Pages source to GitHub Actions

1. Open your repo on GitHub.
2. Go to **Settings** → **Pages** (left sidebar).
3. Under **Build and deployment**, next to **Source**, open the dropdown.
4. Choose **GitHub Actions** (not "Deploy from a branch").
5. Do **not** choose "main" or any branch — that shows the repo (README). Choose **GitHub Actions**.

### 2. Run the deploy workflow

- Go to the **Actions** tab → **Deploy to GitHub Pages** → **Run workflow** → **Run workflow**.
- Wait until the run finishes with a green check.

### 3. Open your app

Your app is at (use your GitHub username and repo name, **with trailing slash**):

**`https://<your-username>.github.io/saas/`**

Example: if your username is `vishal` and the repo is `saas`, open:

**https://vishal.github.io/saas/**

---

### Still seeing README?

- **You must use Source: GitHub Actions.**  
  If Source is "Deploy from a branch" and the branch is main (or anything else), GitHub serves the **repo** (README). Change it to **GitHub Actions** in Settings → Pages.

- **Use the app URL, not the repo URL.**  
  Repo: `https://github.com/username/saas` → shows README.  
  App: `https://username.github.io/saas/` → shows your Flutter app (with trailing slash).

- **Wait 1–2 minutes** after the workflow succeeds; then refresh the app URL.
