// typst watch main.typ

// --- libraries and settings ---
#set page(paper: "a4")
#set text(size: 9pt)

// --- [!] copy at the beginning of each chapter [!] ---
#import "/setup.typ": *

#show link: set text(fill: blue)
#show link: underline
#set par(justify: true)

// --- VARIABLES & STYLING ---
#let stroke = black + 1pt
#let std_radius = 4pt

// colors
#let std_gray = luma(245)
#let dark_red = red.darken(30%).transparentize(20%) 
#let dark_blue = blue.darken(30%).transparentize(20%) 

// --- OUTLINE STYLING ---
// Add space above "Parts" and make them bold in the TOC
#show outline.entry.where(level: 1): it => {
  v(1.5em, weak: true)
  strong(it)
}

#show heading: it => {
  // Define colors based on the heading level
  let bg-color = none
  if it.level == 2 {
    bg-color = luma(195) // A darker gray for "="
  } else if it.level == 3 {
    bg-color = luma(220) // A lighter gray for "=="
  }

  // If it's level 1 or 2, wrap it in a background block
  if bg-color != none {
    block(
      width: 100%,      // Make the background span the whole page width
      fill: bg-color,   // Apply the chosen gray
      inset: 6pt,       // Add some padding inside the box
      radius: 4pt,      // (Optional) slightly round the corners
      it                // Print the actual heading text
    )
  } else {
    // For level 3 (===) and beyond, just print it normally
    it
  }
}

// ---- main ----
#set align(center)
#title(link("https://2025.aulaweb.unige.it/course/section.php?id=1919")[Embedded Systems])
#set align(left)

Repository: #link("https://codeberg.org/Paro2621/Embedded_System", [Codeberg])

// Use auto-indent so nested lessons shift to the right
#outline(indent: auto) 

#pagebreak()

// PART 1: LESSONS
// #heading(level: 1, numbering: none)[Lessons]
// #set heading(offset: 1) 

#include "chapters/10_Lesson1.typ"
#include "chapters/20_Lesson2.typ"
#include "chapters/30_Lesson3.typ"
#include "chapters/40_Lesson4.typ"
#include "chapters/41_interrupt_demo.typ"
#include "chapters/50_Lesson5.typ"
#include "chapters/51_uart_demo.typ"
#include "chapters/60_spi.typ"
#include "chapters/70_adc.typ"

#pagebreak()

// PART 2: ASSIGNMENTS
// #set heading(offset: 0) 
// #heading(level: 1, numbering: none)[Assignments]
// #set heading(offset: 1) 

#include "chapters/assignments/00_toolsRequired.typ"
// #include "chapters/assignments/10_assig1.typ" 
// #include "chapters/assignments/20_assig2.typ"