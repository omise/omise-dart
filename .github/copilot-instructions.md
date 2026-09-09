# Omise Dart SDK — Security & Code Review Instructions

## Code Review Checklist

When reviewing PRs or commits, Copilot should automatically flag:

### 1. Non-Production Omise Hosts (CRITICAL)

Flag any committed code containing Omise domains that do NOT match the official production domain pattern `*.omise.co`. This includes:

- Omise domains with any prefix other than `api`, `vault`, or other official production services
- Any `localhost` or `internal` patterns referencing Omise
- Any non-production environment hosts

## Critical Files Requiring Strict Review

These files contain Omise endpoint/host constants and require additional scrutiny:

### `lib/src/enums/environment.dart` — CRITICAL SECURITY FILE

This file defines the base URLs used throughout the Omise Dart SDK for API calls. It contains production and staging endpoint URLs.

**Changes to Block (Red Flag):**

- Any change introducing a non omise.co domain for production endpoints
- Hardcoding non-production Omise URLs in production code paths (regex: `https?://[a-zA-Z0-9.-]*omise[a-zA-Z0-9.-]*(?<!omise\.co)`)
- Changing `Environment.production` to return anything other than official omise.co domains:
  - `https://api.omise.co`
  - `https://vault.omise.co`

**Changes Requiring Manual Review (Yellow Flag):**

- Any modification to `getBaseUrl()` or `getBaseVaultUrl()` methods in version-bump or release commits
- Changes to how staging environment variables are sourced or validated
- Introduction of new environment types or URL patterns

**Allowed Modifications:**

- ✅ Adding new staging environment variables (if explicitly for test/non-production use)
- ✅ Adding new `Environment` enum values if they clearly separate staging from production
- ✅ Adding validation or documentation about URL formats
- ✅ Refactoring method structure without changing returned URLs
