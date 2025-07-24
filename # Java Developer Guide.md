# Java Developer Guide  
_Release 2025.01 • Security Status ✅_

This guide serves two purposes:

1. **Security Posture** – A transparent record of all resolved vulnerabilities in the project (and how to keep them resolved).  
2. **Engineering Preferences** – Opinionated defaults for build, quality-gate, testing, and workflow settings that every new Java module should inherit.

---

## 1  🔒 Security Status

| Area | CVEs Resolved | Latest Secure Version | Verification Command |
|------|---------------|-----------------------|----------------------|
| Next.js / Node Front-End | 9 | `next 14.2.30` | `npm audit` ⇒ _0 vulns_ |
| Java / Maven Back-End | 2 | `okhttp 4.12.0`, `okio 3.4.0` | `mvn dependency:tree | grep okio` |
| Python Dependencies | 0 | — | `pip-audit` ⇒ _0 vulns_ |

> **Current state**: _100 % of known CVEs resolved_ (see Appendix A for full CVE list).  
> **Policy**: Nightly Dependabot + monthly manual audit.

### 1.1 Critical & High Fixes (snapshot)

| CVE | Component | Fixed In | Impact | Action |
|-----|-----------|----------|--------|--------|
| **CVE-2025-29927** | `next` | 14.2.30 | Auth bypass | Upgrade |
| **CVE-2024-21538** | `cross-spawn` | 7.0.6 | ReDoS | Upgrade |
| **CVE-2023-3635** | `okio` | 3.4.0 | DoS on gzip | Override transitive dep |

**Verification steps**

```bash
# 1. Node / Next.js
cd financial-data-analyst
npm ci
npm audit --production

# 2. Java
mvn -q dependency:tree | grep -E 'okhttp|okio'   # ensure patched versions

# 3. Run full test suites
mvn verify
npm test
pytest
```

---

## 2  🎯 Engineering Preferences (Java-First)

These are the defaults every new Java sub-module **must** adopt unless there is a documented exception.

| Theme | Mandatory Setting | Rationale |
|-------|-------------------|-----------|
| **Java Version** | 21 (or ≥ 21 LTS) | Preview features + virtual threads |
| **Build Tool** | Maven ≥ 3.9.x | Ecosystem, CI ubiquity |
| **Version Pinning** | All dependency versions in `<properties>` | Central control |
| **Plugin Layout** | Separate `<pluginManagement>`; default goal `clean verify` | Consistency |
| **Profiles** | `dev`, `ci`, `release`, `perf` | Least-surprise builds |

### 2.1 Quality Gates

| Tool | Rule of Thumb |
|------|---------------|
| **Spotless** | Google Java Format on every commit |
| **Checkstyle** | Custom rules; block on errors |
| **PMD** | High-impact rules only |
| **SpotBugs** | Must run in CI; no HIGH bugs allowed |
| **JaCoCo** | ≥ 80 % line coverage (unit + integration) |

> Treat static analysis as a compile failure; never push “yellow” builds to `main`.

### 2.2 Project Structure

```text
src/
 ├─ main/
 │   └─ java/com/acme/…             # domain code
 ├─ test/
 │   ├─ java/…                      # *Test.java
 │   └─ resources/                  # test fixtures
 └─ it/                             # *IT.java (failsafe)
```

* Prefer **Builder** or **Factory** patterns over telescoping constructors.  
* Domain objects (`ValidationResult`, etc.) are **immutable**; use records where possible.  
* Generics > raw types; avoid `Optional.get()` without guard.

### 2.3 Testing Strategy

| Level | Framework | Profile | Naming |
|-------|-----------|---------|--------|
| Unit  | JUnit 5 + Mockito + AssertJ | `dev` | `*Test.java` |
| Integration | Failsafe + Testcontainers | `ci` | `*IT.java` |
| Architecture | ArchUnit | `ci` | n/a |
| Performance | JMH | `perf` | `*Bench.java` |

> Run `magic run full-build` to execute **clean → compile → unit tests → it tests → docs** in one shot.

### 2.4 Security Practices

* **OWASP Dependency-Check** on every Maven build.  
* `.gitignore` templates include patterns for _all_ known secret formats.  
* Throw **custom exceptions** carrying error codes; never leak stack traces over the wire.  
* Central `Validation` utility + Builder-based `ValidationResult` for fail-fast checks.

### 2.5 Docs & Reporting

* **README** at root + each significant module.  
* JavaDoc with `-Xdoclint:none` (warnings off in CI).  
* Maven Site for coverage, dependency trees, and quality metrics.  
* Architecture Decision Records (`docs/adr/0001-…`).  

---

## 3  🚀 Performance & Monitoring

| Feature | Setting |
|---------|---------|
| **JMH** | Bench suites in `/perf` profile |
| **GC** | `-XX:+UseG1GC` (default), tune via `/perf` |
| **Virtual Threads** | Prefer Loom (`Executors.newVirtualThreadPerTaskExecutor()`) for I/O |

---

## 4  🔧 Magic & Pixi Integration

`pixi.toml` drives environment parity:

```toml
[dependencies]
openjdk = ">=21"
maven   = ">=3.9"

[tasks]
build          = "mvn clean verify"
test           = "mvn test"
security-scan  = "mvn org.owasp:dependency-check-maven:check"
```

Run tasks with:

```bash
magic run build
magic run security-scan
```

---

## 5  📑 Appendix A – CVE Ledger (Resolved)

| # | CVE | Component | Severity | Fixed In |
|---|-----|-----------|----------|----------|
| 1 | CVE-2025-29927 | next | Critical | 14.2.30 |
| 2 | CVE-2024-21538 | cross-spawn | High | 7.0.6 |
| 3 | CVE-2025-27789 | @babel/runtime | Moderate | 7.27.6 |
| 4 | CVE-2024-55565 | nanoid | Moderate | 3.3.11 |
| 5 | CVE-2023-3635 | okio | Moderate | 3.4.0 |
| 6 | CVE-2024-56332 | next | Low | 14.2.30 |
| 7 | CVE-2025-48068 | next | Low | 14.2.30 |
| 8 | CVE-2025-32421 | next | Low | 14.2.30 |
| 9 | CVE-2025-5889 | brace-expansion | Low | 2.0.2 |

---

### How to Contribute

1. Fork → Branch `feature/…`  
2. `magic run dev-setup`  
3. Ensure `mvn verify` and `npm audit` pass.  
4. Open PR with changelog entry.

*Questions?*  Open an issue or ping `@security-team`.

---

_© 2025 Acme AI • Licensed MIT unless stated otherwise._