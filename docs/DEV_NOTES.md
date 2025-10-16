Loader Roadmap
---------------
- Consolidate asset descriptors into typed structures (e.g. `enum abstract AssetType` with associated data records) to remove `Dynamic`.
- Evaluate migrating to `openfl.utils.Assets` / `AssetLibrary` to leverage platform-aware caches while keeping the custom API as a thin wrapper.
- Introduce async primitives (`Future`, `Promise`) so callers can await batches instead of relying on `startDownload` side-effects.
- Add grouped volume/mute controls and reference counting to allow unloading / reloading assets cleanly.
- Harden error handling with retries, per-file callbacks, and logging hooks instead of throwing immediately.

Scene & Sprite Architecture Notes
---------------------------------
- `Scene`/`Popup` now share `ViewBase`, which owns layers, entities, mask, and asset queuing; scenes only wire camera/effect layers.
- `GlueContext` travels with every view so resize and stage info stay in sync without global lookups.
- Sprites use `Tilemap`/`Tileset` data emitted by `Loader.getSpritesheet`, eliminating the custom frame copier.

Manual Validation Checklist
---------------------------
- Launch the demo scene; confirm loader progress bar advances and scenes swap after assets finish.
- Trigger a missing asset to ensure Loader reports the failure gracefully and recovers without breaking the queue.
- Play, loop, mute, and stop sounds (including invalid IDs) to verify the new guard clauses and loop semantics.
- Exercise `Button` hover/down/out paths and verify no runtime errors occur when the pointer leaves the hit region.
- Toggle `isDebug`, `showBounds`, and `showStats` flags to check overlays, bounds rendering, and resize behaviour.
- Resize the application window (desktop) or browser (HTML5) and observe that canvas dimensions, masks, and camera positioning update correctly.
