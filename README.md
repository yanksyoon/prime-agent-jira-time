# Prime Agent Jira Time

Opt-in, local-first session timing for Prime Agent with Jira association. This extension uses native Prime Agent lifecycle events and the existing Atlassian MCP integration for Jira search, issue creation, and worklog submission.

## Install

```bash
prime-agent package install git:https://github.com/PrimeIntellect-ai/prime-agent-jira-time@main
```

Installation requires the Atlassian MCP server. Verify it with `/jira-time doctor`; if authentication is missing, run `/mcp login atlassian`. The extension never stores Jira credentials.

At each new session a native prompt asks whether to track. Tracking is opt-in. Use `/jira-time start PFE-123`, `/jira-time status`, `/jira-time stop`, `/jira-time find`, `/jira-time create`, and `/jira-time pending`. Active intervals are capped at 15 minutes of idle time and rounded to five minutes for Jira. Entries are stored mode 0600 under `~/.prime/agent/state/jira-time/`.

When an existing-issue suggestion is rejected, the flow explicitly offers creating a new Jira Story. Creation and every worklog submission require confirmation. Jira operations are delegated to the existing Atlassian MCP tools by the agent; no alternate Jira client or credential store is used.
