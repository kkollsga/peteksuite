# Gallery

The [viewer](../tutorials/visualization.md) on a **synthetic** asset — every image
below is rendered from `ps.synth_asset` data through `model.save_view(...)`. No
confidential data appears anywhere.

## Map — areal structure

![Map tab: areal depth raster with outline, contact subcrop masks and well markers](../assets/gallery/01-map.png){ loading=lazy }

The Map tab defaults to the top-horizon depth raster, clipped to the outline, with
per-kind contact subcrop masks and well markers.

## Intersection — coloured by property

![Intersection tab: a cross-section filled by the property colormap](../assets/gallery/02-intersection-property.png){ loading=lazy }

A vertical cross-section, each cell a dipping trapezoid following the zone edges,
filled by the property colormap with horizon and contact traces overlaid.

## Intersection — coloured by zone

![Intersection tab: the same section coloured by categorical zone identity](../assets/gallery/03-intersection-zone.png){ loading=lazy }

The **Color by: zone** select swaps the fill to the fixed categorical zone
identity — the same colour a zone wears in the Volume and Wells tabs.

## Volume — the corner-point shell

![Volume tab: the corner-point exterior shell shaded by property in three.js](../assets/gallery/04-volume.png){ loading=lazy }

The corner-point cell exterior shell, flat-shaded per cell, with threshold and
z-exaggeration sliders and per-zone toggles.

## Wells — TVD correlation

![Wells tab: multi-well log correlation on an absolute TVD depth axis](../assets/gallery/05-wells-tvd.png){ loading=lazy }

Multi-well log correlation on a shared absolute-TVD axis — raw and upscaled curves
per bore, tops as cross-track lines, zones shaded in identity colour.

## Wells — flattened on a pick

![Wells tab: the same wells flattened so a chosen horizon aligns at zero](../assets/gallery/06-wells-flattened.png){ loading=lazy }

The **flatten-on-pick** mode shifts every well so a chosen horizon aligns at
Δ = 0 — the correlation transform, viewer-side.

## Charts — analytics

![Charts tab: tornado and distribution analytics marks](../assets/gallery/07-charts.png){ loading=lazy }

The Charts tab renders pre-computed analytics — tornado sensitivity, the STOIIP
distribution (histogram + exceedance CDF with P90/P50/P10 markers), crossplots.

## Dark mode — map

![Map tab in dark mode with a separately-chosen palette](../assets/gallery/08-dark-map.png){ loading=lazy }

Dark mode is **selected, not auto-flipped** — a separately-chosen, CVD- and
contrast-validated palette.

## Dark mode — volume

![Volume tab in dark mode](../assets/gallery/09-dark-volume.png){ loading=lazy }

The volume shell in dark mode; categorical identity colours are preserved across
the theme flip.

## Volume — graceful auto-degrade

![Volume tab auto-degraded to a decimated preview with a loud banner](../assets/gallery/10-volume-degraded.png){ loading=lazy }

Past the triangle budget the viewer **auto-degrades** to a decimated preview and
says so in a loud banner — it never crashes, OOMs, or blanks silently.
