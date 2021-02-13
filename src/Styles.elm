module Styles exposing (stylusString)


stylusString =
    """
// ===== SVG =====
svg.vectual
  display inline-block

.vectual_background
  fill rgb(50, 50, 50)

.vectual_title
  font-size 20px
  font-family Arial, sans-serif
  fill white


// ===== Inline =====
svg.vectual_inline
  display inline-block

.vectual_inline_sparkline
  fill none
  stroke rgb(200, 200, 200)
  stroke-width 0.8

.vectual_inline_sparkline_min
  fill red

.vectual_inline_sparkline_max
  fill green


// ===== Pie =====
.vectual_pie_sector_path
  stroke white

.vectual_pie_text
  font-family Arial, sans-serif
  font-weight 100

.vectual_pie_text_single
  stroke black
  fill white


// ===== Coordinate =====
.vectual_coordinate_axis_x
  stroke white
  stroke-width 2

.vectual_coordinate_labels_x
  font-size 10px
  line-height 12px
  font-family Arial, sans-serif
  font-weight 100
  fill white

.vectual_coordinate_lines_x
  stroke grey
  stroke-width 1

.vectual_coordinate_axis_y
  stroke white
  stroke-width 2

.vectual_coordinate_labels_y
  fill white
  font-family Arial, sans-serif
  font-size 10px
  font-weight 100
  line-height 12px
  text-anchor end

.vectual_coordinate_lines_y
  stroke grey
  stroke-width 1


// ===== Bar =====
.vectual_bars
  fill #9dfff9
  stroke gray


// Colors created with https://coolors.co
.vectual_bars0, .vectual_color_0
  fill hsl(176, 100%, 81%)
  stroke none

.vectual_bars1, .vectual_color_1
  fill hsl(346, 100%, 88%)
  stroke none

.vectual_bars2, .vectual_color_2
  fill hsl(79, 100%, 86%)
  stroke none

.vectual_bars3, .vectual_color_3
  fill hsl(28, 83%, 77%)
  stroke none

.vectual_bars4, .vectual_color_4
  fill hsl(138, 61%, 74%)
  stroke none

.vectual_bars5, .vectual_color_5
  fill hsl(23, 46%, 68%)
  stroke none

.vectual_bars6, .vectual_color_6
  fill hsl(229, 100%, 75%)
  stroke none

.vectual_bars7, .vectual_color_7
  fill hsl(63, 85%, 79%)
  stroke none

.vectual_bars8, .vectual_color_8
  fill hsl(3, 37%, 78%)
  stroke none

.vectual_bars9, .vectual_color_9
  fill hsl(99, 51%, 67%)
  stroke none

.vectual_bars10, .vectual_color_10
  fill hsl(18, 83%, 75%)
  stroke none


// ===== Line =====
.vectual_line_polyline
  fill none
  stroke-width 3
  stroke-linejoin round

.vectual_line_dot
  stroke none

.vectual_line_polyline_0
  stroke hsl(176, 100%, 81%)

.vectual_line_polyline_1
  stroke hsl(346, 100%, 88%)

.vectual_line_polyline_2
  stroke hsl(79, 100%, 86%)

.vectual_line_polyline_3
  stroke hsl(28, 83%, 77%)

.vectual_line_polyline_4
  stroke hsl(138, 61%, 74%)


// ===== Scatter =====
.vectual_scatter_dot
  fill rgb(255, 0, 0)
  stroke rgb(255, 0, 0)


// ===== Tagcloud =====
.vectual_tagcloud_text
  font-weight 500
  font-family Arial, sans-serif
  fill white


// ===== Table =====
.vectual_table
  background none
  font 200 12px/12px Arial, sans-serif
  margin 10px 0 0 0

.vectual_table th
  background rgb(150, 180, 180)
  padding 2px

.vectual_table td
  padding 2px

.vectual_table tr:nth-child(odd)
  background-color rgb(120, 120, 120)

.vectual_table tr:nth-child(even)
  background-color rgb(180, 180, 180)


// ===== Map =====

// Circles around small countries.
// Change opacity to 1 to display all circles.
.vectual .circlexx
  opacity 0
  fill #e0e0e0
  stroke #000000
  stroke-width 0.5

// Smaller circles around French DOMs and Chinese SARs. Change opacity to 1 to display all subnational circles.
.vectual .subxx
  opacity 0
  stroke-width 0.3

// Circles around small, unrecognized countries. Change opacity to 1 to display all circles.
.vectual .unxx
  opacity 0
  fill #e0e0e0
  stroke #000000
  stroke-width 0.3

// Circles around small countries, but with no permanent residents. Change opacity to 1 to display all circles.
.vectual .noxx
  opacity 0
  fill #e0e0e0
  stroke #000000
  stroke-width 0.5

// land
.vectual .landxx
  fill rgb(230, 230, 230)
  stroke rgb(50, 50, 50)
  stroke-width 0.5
  fill-rule evenodd

// Styles for coastlines of islands with no borders
.vectual .coastxx
  fill rgb(230, 230, 230)
  stroke #ffffff
  stroke-width 0.3
  fill-rule evenodd

// Styles for nations with limited recognition
.vectual .limitxx
  fill rgb(230, 230, 230)
  stroke #ffffff
  stroke-width 0
  fill-rule evenodd

// Styles for nations with no permanent population.
.vectual .antxx
  fill rgb(230, 230, 230)
  stroke #ffffff
  stroke-width 0
  fill-rule evenodd

// Ocean
.vectual .oceanxx
  opacity 1
  color blue
  fill #ffffff
  stroke #000
  stroke-width 0.5
  stroke-miterlimit 1
"""
