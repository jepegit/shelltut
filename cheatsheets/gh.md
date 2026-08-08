# GitHub CLI (`gh`) cheatsheet

Docs: [cli.github.com](https://cli.github.com/) · `gh help` · `gh help formatting`

## Auth & context

| Command | Purpose |
|---------|---------|
| `gh auth login` | Log in (browser or token) |
| `gh auth status` | Who am I / which host |
| `gh status` | Cross-repo issues, PRs, notifications |
| `gh browse` | Open repo in browser |
| `gh browse --no-browser` | Print URL only |

`gh` usually infers the repo from the current git remote.

## Repos

```bash
gh repo view
gh repo view OWNER/REPO
gh repo list [OWNER] --limit 20
gh repo clone OWNER/REPO
gh repo create NAME --public --source=. --remote=origin --push
```

## Issues & PRs

```bash
gh issue list
gh issue create --title T --body B
gh issue view N
gh issue close N

gh pr list
gh pr status
gh pr create --title T --body B [--draft]
gh pr checkout N
gh pr diff
gh pr view
gh pr merge
gh pr close [--delete-branch]
```

`gh co` is an alias for `gh pr checkout`.

## Search

```bash
gh search repos QUERY --limit 10
gh search issues QUERY --repo OWNER/REPO
gh search code QUERY --limit 10
```

## API & JSON

```bash
gh api user
gh api repos/OWNER/REPO --jq '.default_branch'
gh issue list --json number,title,state
gh repo view --json name,url -q '.url'
```

See `gh help formatting` for `--json`, `--jq`, and `-q`.

## Actions (when the repo has workflows)

```bash
gh workflow list
gh run list
gh run view <id>
gh run watch
```

## Helpful extras

```bash
gh release list
gh gist create FILE -d "description"
gh alias list
gh completion -s zsh   # bash|fish|powershell
gh extension list
```
