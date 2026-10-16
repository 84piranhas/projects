# Paper Soccer Online

Two-device version of [Paper Soccer](../papersoccer-by-claude/) (the hot-seat version stays separate and unchanged).
One player creates a game and shares a 4-letter code or link; the other joins, and moves appear live on both screens.

Everything is in `index.html`. Moves travel through a **Supabase Realtime broadcast channel**: no database tables and no server code.

## One-time setup (about 5 minutes)

1. Create a free account at [supabase.com](https://supabase.com) and click **New project** (any name; pick a region near you).
2. In the project, open **Project Settings → API Keys** and copy:
   - the **Project URL** (`https://xxxxxxxx.supabase.co`, also under *Data API*)
   - the **anon / publishable** key (not the `service_role` / secret key)
3. Paste both at the top of the `ui` script in `index.html`:
   ```js
   const SUPABASE_URL = 'https://xxxxxxxx.supabase.co';
   const SUPABASE_ANON_KEY = 'eyJ...';
   ```
4. Check **Realtime → Settings**: public channels must be allowed (they are by default).
5. Commit and push. With GitHub Pages enabled on the repo, the game is at
   `https://84piranhas.github.io/projects/papersoccer-online/`.

The anon key is designed to be public, so it's safe to commit. The app only uses broadcast messages and stores nothing in Supabase.
Free Supabase projects are paused after a week without activity; you can resume yours from the dashboard.

## Testing without Supabase

While the keys are empty, or with `?local` in the URL, the page runs in **local test mode**: two tabs of the same browser
talk through `BroadcastChannel`. Serve the folder over http (not `file://`), create a game in one tab and open the invite link in another.

## How it works

- A game is its starting player plus the list of move directions. Each device replays moves through the same pure game logic as
  the hot-seat version, so an illegal or out-of-order move is rejected and triggers a resync.
- On connect, devices exchange snapshots (`hello`); the more advanced game (game number, then moves played) wins.
  This also restores a game after a page reload or a dropped connection (identity is kept per tab in `sessionStorage`).
- Seats: the creator is P1, the joiner P2. A third device is refused while both players are online; if a player has been
  offline for a while, a new device can take over their seat (for example, switching from phone to laptop).
- Each player sees their own goal at the bottom. Keyboard directions are relative to the screen.
- Undo asks the opponent for permission. Resign ends the game. "Play again" starts the next game for both, and the starting player alternates.
- The chess clock (2:00 + 4 s per turn) runs on both devices, is synced with every move, and pauses while a player is offline.

Messages: `hello`, `ping`, `bye`, `move`, `name`, `resign`, `timeout`, `new`, `settings`, `undoReq`, `undoOk`, `undoNo`, `full`.
