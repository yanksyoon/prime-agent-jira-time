# Prime Agent Jira Time

Opt-in, local-first session timing for Prime Agent with Jira association. This extension uses native Prime Agent lifecycle events and the existing Atlassian MCP integration for Jira search, issue creation, and worklog submission.

## Install

```bash
prime-agent package install git:https://github.com/yanksyoon/prime-agent-jira-time@main
```

Jira search, issue creation, and worklog submission require the Atlassian MCP server. Verify it with `/jira-time doctor`; if authentication is missing, run `/mcp login atlassian`. The extension never stores Jira credentials.

After installation, Prime Agent prompts at startup and when creating a new session. Tracking is opt-in. Use `/jira-time start PFE-123`, `/jira-time status`, `/jira-time stop`, `/jira-time find`, `/jira-time create`, and `/jira-time pending`. Active intervals are capped at 15 minutes of idle time and rounded to five minutes for Jira. Entries are stored mode 0600 under `~/.prime/agent/state/jira-time/`.

When an existing-issue suggestion is rejected, the flow explicitly offers creating a new Jira Story. Creation and every worklog submission require confirmation. Jira operations are delegated to the existing Atlassian MCP tools by the agent; no alternate Jira client or credential store is used.

## Existing local timing extension

[`prime-agent-timing`](https://github.com/yanksyoon/prime-agent-timing) is a separate lifecycle/tool timing extension. Keep both if you need detailed tool-duration analytics, but do not sum its session duration with this extension's active duration: that double-counts work. The adapter report joins Jira session rows to timing session rows by the native Prime Agent session ID; the Jira issue key is retained as the association label.

Installation preflight is intentionally explicit: run `/jira-time doctor`; it checks the local Atlassian MCP configuration and reports the required authentication/tool verification steps.

## External work and adapter

The `jira_time_log_external` model tool accepts `issue`, `duration_minutes`, `description`, and optional `started_at` for work performed outside Prime Agent. It writes a private pending ledger entry; `/jira-time pending` lists entries and `/jira-time log ENTRY_ID` presents the normal final confirmation before delegating the worklog to Atlassian MCP. `/jira-time report` joins the Jira ledger with session-duration rows from the existing `prime-agent-timing` logs without adding the two totals together.


## Tutorial

See [`docs/tutorial.md`](docs/tutorial.md) for the complete usage guide, including session tracking, issue discovery and creation, reports, external work logging, and recovery.


## Terminal video demonstration

![Jira time tracking terminal demonstration](assets/terminal-demo.gif)

An MP4 version is available at [`assets/terminal-demo.mp4`](assets/terminal-demo.mp4). The asciinema source recording remains available at [`docs/terminal-demo.cast`](docs/terminal-demo.cast).


A sanitized terminal recording captured with `asciinema rec` is available at [`docs/terminal-demo.cast`](docs/terminal-demo.cast). Replay it locally with:

```bash
asciinema play docs/terminal-demo.cast
```

The transcript is in [`docs/terminal-demo.txt`](docs/terminal-demo.txt). It uses the placeholder issue `DEMO-123` and contains no private Jira data.

The recording was generated locally with `scripts/record-demo.sh`; it is a scripted, output-only demonstration and does not contact Jira.


The extension smoke-test transcript is available at [`docs/actual-extension-transcript.txt`](docs/actual-extension-transcript.txt).
