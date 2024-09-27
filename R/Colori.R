
# Navbar (just for referenc e) ----------------------------------------------
nav_foot_backg <- "#BDD5E1" # "#e7d8da" #  "#e3eff7"
nav_backg: "#3881a5" # #23749b" # "#b78a92"
 

# Colori --------------------------------------------------------------------
gold <- "#77501a"
pacificharbour_shades <- c( "#d4e6f3","#b8d6eb", "#9cc6e3", "#80b6db",  "#72aed8", "#5b8bac", "#39576c",  "#16222b")

pacificharbour  <- "#72aed8"
japyew <- "#d89c72"
triad_verde <- "#d8cf71"
triad_rosso <- "#d8717b"

bluMEFprinc <- "#2D337C" # "#2D337CFF" (alpha = 1) OR rgb(45/255, 51/255, 124/255, 1)
bluMEFsec <- "#455A8B" # "#455A8BFF" (alpha = 1) OR rgb(69/255, 90/255, 139/255, 1)
bluMEFsec_light <- "#455A8B99"
bluMEFsec_extralight <- "#455A8B33" #  (alpha = .2) OR rgb(69/255, 90/255, 139/255, .2)

gialloMEF_dark <- "#715115"
gialloMEFprinc <- "#BD8723" # "#BD8723FF" (alpha = 1) OR rgb(189/255, 135/255, 35/255, 1)
gialloMEF_light <- "#d7b77b" # "#BD8723FF" (alpha = 1) OR rgb(189/255, 135/255, 35/255, 0.4)
gialloMEF_extralight <- "#f1e7d3" # "#BD8723FF" (alpha = 1) OR rgb(189/255, 135/255, 35/255, 0.2)

bordeaux_dark <- "#51242c" # "#854442FF" (alpha = 1) OR rgb(133/255, 68/255, 66/255, 1)
bordeaux <- "#873c4a" # "#854442FF" (alpha = 1) OR rgb(133/255, 68/255, 66/255, 1)
bordeaux_light <- "#b78a92" #"#85444299"
bordeaux_extralight <- "#e7d8da" #" "#e6cdcc"

viola <- "#2D337C"
viola_light <- "#8e94d6" #"#85444299"
viola_extralight <- "#d9dbf1" #" "#e6cdcc"

verde_dark <- "#245048"
verde <- "#3c8678" # "#285E60FF" (alpha = 1) OR rgb(40/255, 94/255, 96/255, 1)
verde_light <- "#8ab6ae" # "#285E60FF" (alpha = 1) OR rgb(40/255, 94/255, 96/255, 1)
verde_extralight <- "#d8e6e4"
verdino <- "#a6bd23"

marrone_dark  <- "#5d2b15"
marrone <- "#9b4923" # "#866445FF" (alpha = 1) OR rgb(134/255, 100/255, 69/255, 1)
marrone_light <- "#c3917b"
marrone_extralight <- "#ebdad3"

grigio_scuro <- "#4c4c4c" # "#A6A6A6FF" (alpha = 1) OR rgb(166/255, 166/255, 166/255, 1)
grigio <- "#A6A6A6"
grigioSfondo <- "#F2F2F2" # "#F2F2F2FF" (alpha = 1) OR rgb(242/255, 242/255, 242/255, 1)


arancio_dark  <- "#8e550a"
arancio <- "#bd710e" # "#866445FF" (alpha = 1) OR rgb(134/255, 100/255, 69/255, 1)
arancio_light <- "#f0a441"
arancio_extralight <- "#fbe8cf"

rv_dark <-"#7c1c2d" 
compl_gr <- "#1c7c6b"
rosso_val <- "#9b2339"
rv_light <-"#d02e4c"
rv_lighter <-"#e28293"
 
rv_marr <-"#9b4923"

# col2rgb( "#854442")
rv_blue <- "#23749b" # "#4f90af"
rv_green <- "#239b49" 
rv_light_green <- "#749b23"
rv_teal <- "#239b85"
rv_purple <- "#49239b" 
rv_gold <- "#9b6723" # "#af854f"
compl <-  "#9b2356" # "#af4f78"
rv_blue <-"#23399b"

# Color palettes -------------------------------------------------------------- 

#palette_g20 <- c("#455A8B", "#854442", "#285E60", "#BD8723", "#866445", "#A6A6A6")
#mycolors_gradient <- c("#ccf6fa", "#80e8f3", "#33d9eb", "#00d0e6", "#0092a1")

#                   fat gold  |Romaine Green| Blue ColaD |directoire Blue| Bourgeois  | Aztec Turquoise | Fulvous
mycolors_contrast <- c("#9b2339", "#E7B800","#239b85", "#85239b", "#9b8523","#23399b", "#d8e600", "#0084e6","#399B23",  "#e60066" , "#00d8e6",  "#005ca1", "#e68000")
#theme_col <-  c("#00d7e6", "#0065e6",  "#10069f")  
three_col <- c("#d8e600", "#e68000",  "#e60c00")     
two_col <- c( "#009E73","#E69F00")

two_col_contrast <- c( "#399B23",  "#e60066" )


blu_contrast <- c(
  "#0f7184", 
  "#56adbf",
  "#5bd6ef",
  "#025b6d",
  "#b5f2ff",
  "#1b5884",
  "#72aed8",
  "#98c8ea",
  "#5097c9",
  "#3a7aa8",
  "#0286e5",
  "#c6e7ff",
  "#013d68"
  )
  
# # -- Add custom fonts & make custom theme for ggplot2 -----
# # -- da google
# sysfonts::font_add_google(name = "Roboto Condensed", family =  "Condensed")
# sysfonts::font_add(family = "Roboto Condensed", regular =  "~/Applications/Roboto_Condensed/RobotoCondensed#-Regular.ttf")
# # -- da web
# sysfonts::font_add(family = "Inconsolata", regular = "~/Applications/Inconsolata/static/Inconsolata_Expanded#.ttf")
# sysfonts::font_families()
# 
# # install.packages("extrafont")
# library(extrafont)
# # -- quali ho nel sistema
# fonts()
# # -- Import all the .ttf files from your system
 
# Themes -----------------------------------------------------------------------------------
# #Define gppr_theme() function
# 
# theme_cohesion <- function(){ 
#   font <- "Roboto"   #assign font family up front
#   #theme_minimal() %+replace%    #replace elements we want to change
#   theme(
#     panel.background = element_rect(fill = NA),
#     panel.border = element_rect(fill = NA, color = "grey75"),
#     axis.ticks = element_line(color = "grey85"),
#     # inclinato
#     axis.text.x = element_text(angle = 45, hjust = 1),# size = 9,
#     # axis.text.y = element_text(size = 9, face = "bold"),  
#     panel.grid.major = element_line(color = "grey95", size = 0.2),
#     panel.grid.minor = element_line(color = "grey95", size = 0.2),
#     #strip.text = element_text(face = "bold"),
#     #plot.title = element_text(face = "bold" ),
#     #since the legend often requires manual tweaking based on plot content, don't define it here
#     #legend.position = "bottom",
#     # Bold legend titles
#     legend.title = element_text(face = "bold"),
#     # legend.title = element_blank(), # to remove it
#     legend.key = element_blank()
#   )
# }
# 
# # ggplot theme
# theme_edb <- function(base_size = 9, base_family = "Clear Sans Light") {
#   update_geom_defaults("label", list(family = "Clear Sans Light"))
#   update_geom_defaults("text", list(family = "Clear Sans Light"))
#   ret <- theme_bw(base_size, base_family) + 
#     theme(panel.background = element_rect(fill = "#ffffff", colour = NA),
#           axis.title.y = element_text(margin = margin(r = 10)),
#           axis.title.x = element_text(margin = margin(t = 10)),
#           title = element_text(vjust = 1.2, family = "Clear Sans", face = "bold"),
#           plot.subtitle = element_text(family = "Clear Sans Light"),
#           plot.caption = element_text(family = "Clear Sans Light",
#                                       size = rel(0.8), colour = "grey70"),
#           panel.border = element_blank(), 
#           axis.line = element_blank(),
#           axis.ticks = element_blank(),
#           legend.position = "bottom", 
#           legend.title = element_text(size = rel(0.8)),
#           axis.title = element_text(size = rel(0.8), family = "Clear Sans", face = "bold"),
#           strip.text = element_text(size = rel(1), family = "Clear Sans", face = "bold"),
#           strip.background = element_rect(fill = "#ffffff", colour = NA),
#           panel.spacing.y = unit(1.5, "lines"),
#           legend.key = element_blank(),
#           legend.spacing = unit(0.2, "lines"))
#   
#   ret
# }
# 
