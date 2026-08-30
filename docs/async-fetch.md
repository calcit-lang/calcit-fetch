---
title: "Asynchronous native Fetch"
summary: "Issue cancellable native HTTP requests, handle typed Result values with match, and bound callback backpressure"
scope: "module"
kind: "guide"
category: "ecosystem"
aliases:
  - "calcit fetch"
  - "HTTP client"
  - "fetch Result"
  - "async request"
  - "request cancellation"
  - "fetch callback"
entry_for:
  - "fetch.core/fetch"
  - "Result Ok Err"
---

# Asynchronous native Fetch

`fetch.core/fetch` performs a native HTTP request, returns a typed `FfiTask`, and invokes a callback with `Result<String, String>`. Use native `match` so success and failure stay explicit and statically visible.

```cirru.no-check
let
    task $ fetch.core/fetch |https://calcit-lang.org
      {} (:timeout-ms 30000)
      fn (result)
        match result
          (:ok text) (println text)
          (:err message) (eprintln message)
  task.cancel-with :superseded
```

Options support method, headers, query pairs, body, and bounded timeout. Validate or encode application structures before crossing this boundary.

## Lifecycle and backpressure

Result and terminal events use bounded host-queue delivery. A saturated queue becomes one explicit failure terminal after a bounded deadline rather than retaining a worker forever.

The request runs as an async `reqwest` future selected against the task's registered cancellation signal. `.cancel` / `.cancel-with` drops the active network future, suppresses stale result delivery, and then acknowledges cleanup with one terminal event. `:timeout-ms` defaults to 30000 and accepts bounded integer values from 1 through 300000.

## Application guidance

- Convert the callback Result into an application operation before updating state.
- Keep request callbacks out of pure updaters and render functions.
- Add application-level timeout, request id, and stale-response checks when newer requests supersede older ones.
- Retain and cancel the returned task when the owning view, route, or request generation becomes obsolete.
- For retries, classify transport failures and make mutation requests idempotent.
- Do not use `unwrap` on network results; handle both variants with `match` or Result methods.
