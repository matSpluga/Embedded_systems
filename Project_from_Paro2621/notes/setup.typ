#import "@preview/zebraw:0.6.1": *

#let stroke = black + 1pt
#let std_radius = 4pt

// colors
#let std_gray = luma(245)
#let dark_red = red.darken(30%).transparentize(20%) // Creates a nice, professional dark red
#let dark_blue = blue.darken(30%).transparentize(20%) // Creates a nice, professional dark red

// ---- dark red bkgnd box ----
#let redBox(testo) = align(center)[
  #block(
    fill: dark_red,      
    width: 90%,          
    inset: 12pt,         
    radius: std_radius,
    [
      #set text(fill: white) 
      #align(left)[*`[!]`* #testo]     
    ] 
  )
]


// ---- dark blue bkgnd box ----
#let blueBox(testo) = align(center)[
  #block(
    fill: dark_blue,      
    width: 90%,          
    inset: 12pt,         
    radius: std_radius,
    [
      #set text(fill: white) 
      #align(left)[_*`[Note]`*_ #testo]     
    ] 
  )
]


// ---- long citation gray quote box ---- 
#let grayQuote(quote_text, author) = align(center)[
  #block(
    fill: std_gray,      
    width: 90%,          
    inset: 12pt,         
    radius: std_radius,  
    [
      // Using #emph instead of underscores fixes the markdown clash
      #align(left)[#emph["#quote_text"]] 
      #align(right)[--- *#author*] 
    ]
  )
]

// ---- simple block schemes ----
// Import diagram directly for cleaner configuration
#import "@preview/fletcher:0.5.8": diagram, node, edge

#let phase_node(pos, label) = node(
  pos,
  box(width: 9em, align(center)[#label])
)

#let my_diagram = diagram.with(
    node-stroke: stroke,
    node-fill: std_gray, 
    node-corner-radius: std_radius,
)

#let phase_edge = edge