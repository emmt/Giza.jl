* fix `giza_query_device`

* avoid pixel interpolation in `giza_draw_pixels`

* make  `GIZA_MAX_DEVICES` dynamic

* use prefix `_giza_` for `Dev`, `id`, `Sets`, etc. to avoid collisions

* have the /xw driver run in a separate thread so that
  it can respond to the X events, to refresh on resize, redraw, etc.

* implement auto-zoom on resize for the /xw driver
