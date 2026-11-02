---
name: reference_unity_asset_store_graphql
description: "Read any Unity Asset Store package's real file list, price and pipeline without a login or a browser - the store's public GraphQL and page state"
metadata: 
  node_type: memory
  type: reference
  originSessionId: a9d749d6-e8d8-4e42-a989-0109d2b18d09
  modified: 2026-09-13T00:24:49.357Z
---

Established in R142 (2026-09-13). The in-app browser HANGS on assetstore.unity.com, but plain
HTTP works. No login and no credentials.

**Product record:** GET `https://assetstore.unity.com/packages/package/<id>`. It redirects to the
slug. The HTML carries `__component__.ReactDOMrender({...})`, which you bracket-match and json-parse.
The fields are at `data.ENTITY.Product["<id>"]`: `originalPrice {originalPrice, finalPrice,
discount}` (EUR), `downloadSize`, `assetCount`, `supportedUnityVersions`, `srps` (`standard` =
Built-in, `lightweight` = URP, `hd` = HDRP), `customLicense`, `licenseText`, `description`,
`images`. Refs such as `publisher`/`category`/`currentVersion` resolve through
`data.ENTITY.<Type>["<id>"]`. JS bundles come back gzip; use `curl --compressed`.

**Package content (the file list):** POST `https://assetstore.unity.com/api/graphql` with the
cookies from the page GET and header `X-CSRF-Token` = the `_csrf` cookie.
`query PreviewAssets($id: ID!, $page: Int) { product(id: $id) { id name assets(page: $page) { guid assetId: asset_id label level type } } }`
Loop `page` until no new rows. `level` gives the folder depth.

**A publisher's catalogue with prices:**
`query Publisher($id: ID!) { publisher(id: $id) { name packages(page: 1, size: 100) { total results { ... on ProductQ { id name category price { price originPrice } } } } } }`
(Mixall is 19049, 397 packages.) `SearchResultsEasy` ignores `q`, so find ids through the publisher.

Bundles: compare file names against the parts to prove containment (R142 did so for Mixall 396548).
Store copy can be pasted from another pack. Mixall 142273 carries 127334's description, so trust
the file list. Related: [[feedback_search_for_the_thing_not_the_category]].

**2026-09-13: the GraphQL POST now needs `"operationName"` in the body plus
`Accept: application/json` and `X-Requested-With: XMLHttpRequest`**, or it 302s to
`/errors/unexpected`. A `$page` variable errors - write the page number into the query text.
Mixall (19049) lists 379 packages, 16 free; none is built like 20 Fighters (the free Gang
members pack is multi-material full PBR). The standard EULA (updated 2024-12-04) licenses use in
any "electronic application or digital media" (2.2.1(a)) and forbids AI/ML training on assets
(2.2.1.1(g)).
