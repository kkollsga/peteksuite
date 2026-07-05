# Licensing

The suite is **split by layer**. The horizontal toolkit and the data layer are
permissively licensed; the geomodel and simulation layers ship under a
source-available license that converts to Apache-2.0 on a schedule.

| Library | License |
|---|---|
| **petekTools** | Apache-2.0 |
| **petekIO** | Apache-2.0 |
| **petekStatic** | Business Source License 1.1 (converts to Apache-2.0) |
| **petekSim** | Business Source License 1.1 (converts to Apache-2.0) |

## What the BSL means for you

The **Business Source License 1.1** is source-available, not closed. In three
sentences:

1. You may **read, modify, and use** petekStatic and petekSim freely for any
   **non-production** purpose — evaluation, research, development, teaching — and
   for production use too, *except* offering the library's own functionality as a
   competing commercial "as-a-service" product.
2. Each **released version** carries a Change Date; four years after that version
   is first published, it **automatically converts to Apache-2.0** — so every
   release becomes fully open on a fixed, predictable schedule.
3. The permissively-licensed layers (**petekTools**, **petekIO**) are **Apache-2.0
   today** with no restriction — build on them freely, including commercially.

!!! note "The authoritative terms"
    This page is a plain-language summary, not the license. Each library's own
    `LICENSE` and `NOTICE` files carry the authoritative, version-stamped terms
    (the `{VERSION}` and Change Date parameters are filled in at each release
    cut). For alternative licensing of the BSL layers, contact the maintainer.

## Why the split

The Apache-2.0 layers are the **substrate** — the toolkit's numeric kernels and
the data layer's ingest path are infrastructure the whole community can build on
without friction. The BSL layers are the **differentiated modelling and appraisal
value**; source-available with a guaranteed open-source conversion balances open
development against sustaining the work, and every release is on a clock to full
Apache-2.0.
