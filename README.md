# Prime Agent Jira Time

Opt-in, local-first session timing for Prime Agent with Jira association. This extension uses native Prime Agent lifecycle events and the existing Atlassian MCP integration for Jira search, issue creation, and worklog submission.

## Install

```bash
prime-agent package install git:https://github.com/PrimeIntellect-ai/prime-agent-jira-time@main
```

Installation requires the Atlassian MCP server. Verify it with `/jira-time doctor`; if authentication is missing, run `/mcp login atlassian`. The extension never stores Jira credentials.

At each new session a native prompt asks whether to track. Tracking is opt-in. Use `/jira-time start PFE-123`, `/jira-time status`, `/jira-time stop`, `/jira-time find`, `/jira-time create`, and `/jira-time pending`. Active intervals are capped at 15 minutes of idle time and rounded to five minutes for Jira. Entries are stored mode 0600 under `~/.prime/agent/state/jira-time/`.

When an existing-issue suggestion is rejected, the flow explicitly offers creating a new Jira Story. Creation and every worklog submission require confirmation. Jira operations are delegated to the existing Atlassian MCP tools by the agent; no alternate Jira client or credential store is used.

## Existing local timing extension

`/home/ubuntu/prime-agent-timing` is a separate lifecycle/tool timing extension. Keep both if you need detailed tool-duration analytics, but do not sum its session duration with this extension's active duration: that double-counts work. The recommended integration is to let this extension own opt-in Jira sessions and worklogs, while `prime-agent-timing` remains the analytics source. A future adapter can join records on the native Prime Agent session ID and Jira issue key.

Installation preflight is intentionally explicit: run `/jira-time doctor`; it checks the local Atlassian MCP configuration and reports the required authentication/tool verification steps.
