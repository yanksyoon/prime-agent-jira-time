# Jira and Prime Agent timing tutorial

This tutorial shows how to opt into Jira time tracking, inspect local progress, log external work, and combine Jira entries with detailed Prime Agent timing.

## 1. Install and verify

Install the extension package or use the built-in Prime Agent integration. The existing Atlassian MCP server is required for Jira search, issue creation, and worklog submission.

```text
/mcp login atlassian
/reload
/jira-time doctor
```

`/jira-time doctor` checks that `mcpServers.atlassian` is enabled. It also reminds you to verify the Jira search, create-issue, and add-worklog tools.

The extension never stores Jira credentials.

## 2. Start a tracked session

At startup and after `/new`, Prime Agent shows a native prompt:

```text
Track this session with a Jira story or ticket?
```

Choose **Yes** to opt in. Choose **No** to leave the session untracked.

After opting in, associate the session explicitly:

```text
/jira-time start PFE-123
```

You can also associate an existing session later:

```text
/jira-time associate PFE-123
```

Tracking is host-side and does not require the model to estimate time. Active intervals are capped at 15 minutes of idle time, then rounded to five minutes for Jira.

## 3. Find or create an issue

To find an existing issue, ask the agent to search Jira or run:

```text
/jira-time find
```

The agent uses the existing Atlassian MCP integration. Review the suggestions; the extension never silently selects one.

If suggestions are rejected, select **Create new issue** or run:

```text
/jira-time create
```

Creating a Jira Story requires confirmation before the MCP create-issue operation is called.

## 4. Check progress during work

Show the current tracked session:

```text
/jira-time status
```

Show pending local Jira entries:

```text
/jira-time pending
```

Show the combined adapter summary:

```text
/jira-time report
```

Show detailed Prime Agent work categories from the existing timing extension:

```text
/timing today
/timing 9h
/timing 2026-08-16
```

The Jira and timing totals are deliberately shown separately. Adding them together would double-count the same work.

## 5. Stop and submit a Jira worklog

When finished:

```text
/jira-time stop
```

The extension calculates the local duration and displays a final confirmation. Nothing is sent to Jira until you approve it.

After approval, the agent submits the entry with the existing Atlassian MCP `addWorklogToJiraIssue` tool. If Jira is unavailable, the entry remains local and pending.

## 6. Log external work

For work performed outside Prime Agent, use the model-visible tool `jira_time_log_external`. For example, ask:

> Log 90 minutes of external work against PFE-123 for reviewing the deployment design.

The tool accepts:

```json
{
  "issue": "PFE-123",
  "duration_minutes": 90,
  "description": "Reviewed the deployment design",
  "started_at": "2026-08-16T09:00:00Z"
}
```

`issue` and `started_at` are optional. The entry is stored in the private local ledger first:

```text
~/.prime/agent/state/jira-time/sessions.json
```

Review it with:

```text
/jira-time pending
```

Then submit a selected entry:

```text
/jira-time log ENTRY_ID
```

The normal final Jira confirmation still applies.

## 7. Understand the reports

There are two complementary reports:

### Detailed work report

`prime-agent-timing` measures Prime Agent lifecycle and tool activity:

```text
/timing today
```

It reports categories such as testing, debugging, implementation, and deployment. Its logs are stored under:

```text
~/.local/share/prime-agent/timing/
```

### Jira association report

`prime-agent-jira-time` reports user-approved Jira durations and pending external entries:

```text
/jira-time report
```

It joins new records using the native Prime Agent session ID. Historical timing records created before native session IDs were adopted may not join.

## 8. Recover from failures

If a worklog submission fails, the local entry is retained. Check it with:

```text
/jira-time pending
```

Repair MCP authentication if necessary:

```text
/mcp login atlassian
```

Then retry:

```text
/jira-time log ENTRY_ID
```

## 9. Privacy and token usage

- Tracking is opt-in.
- Local records are stored with restrictive file permissions.
- Jira credentials remain managed by Atlassian MCP.
- Timing arithmetic and local reports do not require model calls.
- Jira search, issue creation, and worklog submission happen only when requested or confirmed.


## Terminal video demonstration

Replay the sanitized walkthrough recorded locally with [asciinema](https://asciinema.org/):

```bash
asciinema play docs/terminal-demo.cast
```

The recording demonstrates the complete flow with the placeholder issue `DEMO-123`. See [`terminal-demo.txt`](terminal-demo.txt) for an accessible transcript. It is intentionally output-only and does not contact Jira.

The cast was recorded with:

```bash
asciinema rec --command ./scripts/record-demo.sh docs/terminal-demo.cast
```
