# CLAUDE.md — Frontend

Vite + React 19 SPA + Tailwind CSS. **No Next.js.** Vite proxies `/api` to server.

## Structure

- **State**: Zustand stores in `src/stores/` — `authStore` (with `menuSections`, `fetchMenuSections`), `chatStore`, `settingsStore`, `licenseStore` (fetches `/api/license/info`, provides `LicenseInfo` with `features` map and `tier`), `toastStore`, `themeStore`
- **Hooks**: `useChat` (SSE streaming chat with abort, chat rename, message delete support), `useFeature` (boolean license feature gating), `useFeatureLimit` (numeric license limit, e.g. `max_workspaces`), `useLicenseTier` (returns `"community"` or `"enterprise"`)
- **Components**: React components in `src/components/`. No strict component library — Tailwind + CSS variables. Key components: `ChatPanel` (chat + sidebar + citations), `ChatSidebar` (chat list with rename/delete, 30s polling), `SettingsPage` (7 tabs including Roles & Permissions, Embed Widget), `SettingsRoles` (role CRUD with permissions + menu sections), `SettingsEmbed` (iframe/script embed code generator with live preview)
- **Routing**: `react-router-dom` v7. App component renders sidebar + routed panels.

## Key Rules

### Theme & CSS
- CSS custom properties (`--bg`, `--surface`, `--text`, etc.) defined in `:root` / `.dark` selectors in `index.css`.
- Tailwind `darkMode: "class"` with `.dark` on `<html>`.
- Use `bg-[var(--surface)]` not `bg-white`. Use `text-[var(--text-muted)]` not `text-gray-500`.
- Zustand `themeStore` persists to localStorage.

### i18n
- `react-i18next` with JSON files in `src/i18n/{en,it,ru}/translation.json`. Languages: en, it, ru.

### Auth & Session
- JWT tokens stored in localStorage.
- `fetchMe()` only clears token on 401/403. On 429/500/network errors, the session is preserved to avoid logging users out during transient failures.

### Chat Streaming
- `useChat` hook (`src/hooks/useChat.ts`) connects to `/api/workspaces/:id/chat/stream` SSE endpoint.
- Uses `@microsoft/fetch-event-source` for SSE.
- Events: `token`, `status`, `citations`, `done`, `error`.
- Supports abort via `AbortController`.

### ChatSidebar Polling
- Uses `useToastStore((s) => s.addToast)` selector (stable reference), NOT `useToast()` (new object per render).
- Using `useToast()` causes `fetchChats` useCallback to recreate on every render, triggering API flooding.
- Polling interval: 30s.

### Vite Proxy
- Dev server proxies `/api` to `http://localhost:3000`. If backend is down, you get ECONNREFUSED on frontend API calls.

### Settings
- After saving settings (`fetchSettings()`), always refetch to reflect actual state since PUT `/api/system/settings` may partially reject some keys.

### License & Feature Gating
- `licenseStore` fetches license info on app load. The `license.features` map contains both boolean flags and numeric limits.
- `useFeature(flag)` returns `boolean` — use to conditionally render enterprise UI (e.g. `<UpgradePrompt feature="webhooks" />`).
- `useFeatureLimit(flag)` returns `number` (0 if not loaded) — use to check numeric limits like `max_workspaces`.
- `useLicenseTier()` returns `"community"` or `"enterprise"`.
- `UpgradePrompt` component renders a locked-state card with feature label and upgrade CTA. Supports all 9 `FeatureFlag` values.