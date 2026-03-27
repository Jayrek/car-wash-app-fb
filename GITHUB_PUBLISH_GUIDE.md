# Publish a Flutter Project to GitHub from VS Code

This guide shows two ways to publish a Flutter project to GitHub using VS Code:

- **Method 1:** VS Code GUI (best for most new projects)
- **Method 2:** Integrated terminal (more control)

## Prerequisites

Before you start, make sure you have:

- **Git installed** and configured (`git --version`)
- A **GitHub account**
- **Flutter** and **Dart** extensions installed in VS Code
- Signed in to **GitHub in VS Code** (you are usually prompted automatically)

---

## Method 1: VS Code GUI (Recommended)

1. **Open your Flutter project** in VS Code.
2. **Initialize a Git repository**
   - Open Command Palette:
     - macOS: `Cmd + Shift + P`
     - Windows/Linux: `Ctrl + Shift + P`
   - Run: `Git: Initialize Repository`
   - Select your current project folder.
3. **Commit your project files**
   - Open **Source Control**:
     - Sidebar icon (branch/Y-shaped icon), or
     - Shortcut:
       - macOS: `Ctrl + Shift + G` (or open from sidebar)
       - Windows/Linux: `Ctrl + Shift + G`
   - Stage files by clicking the `+` next to **Changes** (or stage all).
   - Enter a commit message, for example: `Initial commit`
   - Click **Commit**.
4. **Publish to GitHub**
   - Open Command Palette again.
   - Run: `Publish to GitHub`
   - Choose **Public** or **Private**
   - Set repository name and confirm prompts.

VS Code will create the repository on GitHub and push your local commit automatically.

---

## Method 2: Integrated Terminal (More Control)

1. **Open your Flutter project** in VS Code.
2. Open terminal: **View > Terminal**
3. **Initialize Git locally** (if needed):

```bash
git init
```

4. **Stage and commit your files**:

```bash
git add .
git commit -m "Initial commit"
```

5. **Create a new empty GitHub repository** on [github.com](https://github.com)
   - Copy the repository URL (example: `https://github.com/username/repo-name.git`)
   - Do **not** add a README, `.gitignore`, or license during repo creation if your project already has these.

6. **Connect local repo to GitHub remote**:

```bash
git remote add origin <URL>
```

Example:

```bash
git remote add origin https://github.com/username/repo-name.git
```

7. **Verify remote** (optional):

```bash
git remote -v
```

8. **Push to GitHub**:

```bash
git push -u origin master
```

> Note: Many repositories now use `main` instead of `master`. If needed:
>
> ```bash
> git branch -M main
> git push -u origin main
> ```

---

## Quick Troubleshooting

- **Authentication errors**: sign in to GitHub in VS Code or use a personal access token (PAT) if prompted.
- **Remote already exists**: run `git remote set-url origin <URL>` instead of `git remote add origin <URL>`.
- **Nothing to commit**: check status with `git status` and make sure files are saved.

---

## Verify Success

After push completes:

1. Open your repository on GitHub.
2. Confirm Flutter project files are visible.
3. Check that the latest commit message appears in the commit history.
