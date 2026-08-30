---
title: "Asynchronous native Fetch"
summary: "Issue native HTTP requests, handle typed Result values with match, and understand callback backpressure and cancellation limits"
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

`fetch.core/fetch` performs a native HTTP request and invokes a callback with `Result<String, String>`. Use native `match` so success and failure stay explicit and statically visible.

```cirru.no-check
fetch.core/fetch |https://calcit-lang.org nil $ fn (result)
  match result
    (:ok text) (println text)
    (:err message) (eprintln message)
```

Options support method, headers, query pairs, and body. Validate or encode application structures before crossing this boundary.

## Lifecycle and backpressure

Result and terminal events use bounded host-queue delivery. A saturated queue fails after a bounded deadline rather than retaining a worker forever. The current request execution itself is blocking and has no cancel hook; bounded callback delivery does not mean the network request is cancellable.

## Application guidance

- Convert the callback Result into an application operation before updating state.
- Keep request callbacks out of pure updaters and render functions.
- Add application-level timeout, request id, and stale-response checks when newer requests supersede older ones.
- For retries, classify transport failures and make mutation requests idempotent.
- Do not use `unwrap` on network results; handle both variants with `match` or Result methods.
