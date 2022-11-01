# ==========================================================================
# draw all nodes (with annotation) for a specified child-nebula
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#' @aliases draw_nodes
#'
#' @title ...
#'
#' @description ...
#'
#' @details ...
#'
#' @name draw_nodes-methods
#'
#' @order 1
NULL
#> NULL

#' @exportMethod draw_nodes
#' @description \code{draw_nodes()}: get the function for generating
#' default parameters for the method
#' \code{draw_nodes}.
#' @rdname draw_nodes-methods
setMethod("draw_nodes", 
          signature = setMissing("draw_nodes",
                                 x = "missing"),
          function(){
            function(x) {
              if (!is.null(nebula_index(x)[[ "tracer_color" ]])) {
                nodes_color <- nebula_index(x)[[ "tracer_color" ]]
              } else {
                nodes_color <- "#FFF9F2"
              }
              list(nodes_color = nodes_color,
                   add_id_text = T,
                   add_structure = T,
                   add_ppcp = T,
                   add_ration = T
              )
            }
          })
#' @exportMethod draw_nodes
#' @description \code{draw_nodes(x, ...)}: use the default parameters whatever 'missing'
#' while performing the method \code{draw_nodes}.
#' @rdname draw_nodes-methods
setMethod("draw_nodes", 
          signature = c(x = "mcnebula", nebula_name = "character"),
          function(x, nebula_name, nodes_color, add_id_text, 
                   add_structure, add_ppcp, add_ration){
            reCallMethod("draw_nodes",
                         .fresh_param(draw_nodes()(x)))
          })
#' @importFrom svglite svglite
#' @importFrom grid pushViewport
#' @importFrom grid viewport
#' @importFrom grid popViewport
#' @importFrom pbapply pblapply
#' @importFrom tibble as_tibble
#' @importFrom rsvg rsvg_svg
#' @exportMethod draw_nodes
#'
#' @aliases draw_nodes
#'
#' @title ...
#'
#' @description ...
#'
#' @details ...
#'
#' @param x ...
#' @param nebula_name ...
#' @param nodes_color ...
#' @param add_id_text ...
#' @param add_structure ...
#' @param add_ppcp ...
#' @param add_ration ...
#'
# @inheritParams rdname
#'
#' @return ...
#'
# @seealso ...
#'
#' @rdname draw_nodes-methods
#'
#' @examples
#' \dontrun{
#' draw_nodes(...)
#' }
setMethod("draw_nodes", 
          signature = c(x = "mcnebula", nebula_name = "character",
                        nodes_color = "character",
                        add_id_text = "logical",
                        add_structure = "logical",
                        add_ppcp = "logical",
                        add_ration = "logical"),
          function(x, nebula_name, nodes_color, add_id_text, 
                   add_structure, add_ppcp, add_ration){
            if (add_ppcp) {
              if (length(ppcp_data(child_nebulae(x))) == 0)
                x <- set_ppcp_data(x)
            }
            if (add_ration) {
              if (length(ration_data(child_nebulae(x))) == 0)
                x <- set_ration_data(x)
            }
            if (add_structure) {
              if (length(ppcp_data(child_nebulae(x))) == 0)
                x <- draw_structures(x, nebula_name)
            }
            .features_id <-
              `[[`(tibble::as_tibble(tbl_graph(child_nebulae(x))[[nebula_name]]),
                   "name")
            .features_id <-
              unlist(lapply(.features_id,
                            function(id){
                              if (is.null(nodes_ggset(child_nebulae(x))[[id]]))
                                id
                            }))
            if (is.null(.features_id)) {
              return(x)
            }
            ggsets <- ggset_activate_nodes(x, .features_id, nodes_color,
                                     add_ppcp, add_ration)
            nodes_ggset(child_nebulae(x)) <-
              c(nodes_ggset(child_nebulae(x)), ggsets)
            path <- paste0(export_path(x), "/tmp/nodes")
            .check_path(path)
            .message_info("draw_nodes", "ggplot -> svg -> grob")
            grImport2:::setPrefix("")
            nodes_grob <- 
              pbapply::pbsapply(names(ggsets), simplify = F,
                                function(id){
                                  file <- paste0(path, "/", id, ".svg")
                                  svglite::svglite(file, bg = "transparent")
                                  ggset <- modify_rm_legend(ggsets[[ id ]])
                                  ggset <- modify_set_margin(ggset)
                                  print(call_command(ggset))
                                  if (add_structure) {
                                    vp <- grid::viewport(width = 0.8, height = 0.8)
                                    grid::pushViewport(vp)
                                    show_structure(x, id)
                                    grid::popViewport()
                                  }
                                  if (add_id_text) {
                                    label <- paste0("ID: ", id)
                                    grid::grid.draw(.grob_node_text(label))
                                  }
                                  dev.off()
                                  rsvg::rsvg_svg(file, file)
                                  .cairosvg_to_grob(file)
                                })
            nodes_grob(child_nebulae(x)) <- 
              c(nodes_grob(child_nebulae(x)), nodes_grob)
            return(x)
          })
#' @exportMethod show_node
#' @description \code{show_node()}: get the default parameters for the method
#' \code{show_node}.
#' @rdname draw_nodes-methods
setMethod("show_node", 
          signature = setMissing("show_node",
                                 x = "missing"),
          function(){
            list(panel_viewport =
                 grid::viewport(0, 0.5, 0.4, 1, just = c("left", "centre")),
               legend_viewport =
                 grid::viewport(0.4, 0.5, 0.6, 1, just = c("left", "centre"))
            )
          })
#' @exportMethod show_node
#'
#' @aliases show_node
#'
#' @title ...
#'
#' @description ...
#' @description \code{show_node(x, ...)}: use the default parameters whatever 'missing'
#' while performing the method \code{show_node}.
#'
#' @details ...
#'
#' @param x ...
#' @param .features_id ...
#' @param panel_viewport ...
#' @param legend_viewport ...
#'
# @inheritParams rdname
#'
#' @return ...
#'
# @seealso ...
#'
#' @rdname draw_nodes-methods
#'
#' @examples
#' \dontrun{
#' show_node(...)
#' }
setMethod("show_node", 
          signature = c(x = "ANY", .features_id = "character"),
          function(x, .features_id, panel_viewport, legend_viewport){
            args <- .fresh_param(show_node())
            args$.features_id <- .features_id
            do.call(.show_node, args)
          })
.show_node <-
  function(x, .features_id, panel_viewport, legend_viewport){
    grob <- nodes_grob(child_nebulae(x))[[.features_id]]
    if (is.null(grob))
      stop("the node of `.features_id` has not been drawn")
    .message_info_viewport("BEGIN")
    if (!is.null(panel_viewport)) {
      .check_class(panel_viewport, "viewport", "grid::viewport")
      grid::pushViewport(panel_viewport)
      upper <- T
    } else {
      upper <- F
    }
    .message_info_viewport()
    grid::grid.draw(grob)
    if (upper) {
      grid::upViewport()
    } else {
      return(message(""))
    }
    if (!is.null(legend_viewport)) {
      .check_class(legend_viewport, "viewport", "grid::viewport")
      .message_info_viewport()
      grid::pushViewport(legend_viewport)
      p <- call_command(nodes_ggset(child_nebulae(x))[[.features_id]])
      grid::grid.draw(.get_legend(p))
    }
    .message_info_viewport("END")
  }
#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname draw_nodes-methods
#' @export 
ggset_activate_nodes <- 
  function(x, .features_id, nodes_color = "#FFF9F2",
           add_ppcp = T, add_ration = T){
    if (add_ppcp) {
      .check_data(child_nebulae(x), list(ppcp_data = "set_ppcp_data"))
    }
    nodes_color <- .as_dic(nodes_color, .features_id, "#FFF9F2")
    set <- .prepare_data_for_nodes(x, .features_id, add_ppcp)
    ggsets <-
      sapply(.features_id, simplify = F,
             function(id) {
               names <- paste0(set[[id]]$rel.index)
               pal <- .as_dic(palette_col(x), names,
                              fill = F, as.list = F, na.rm = T)
               labels <- .as_dic(paste0("Bar: ", names, ": ", set[[id]]$class.name),
                                 names, fill = F, as.list = F)
               new_ggset(new_command(ggplot, set[[id]]),
                         .command_node_nuclear(nodes_color[[id]]),
                         .command_node_border(),
                         .command_node_radial_bar(),
                         .command_node_ylim(),
                         .command_node_polar(),
                         .command_node_fill(pal, labels),
                         new_command(theme_void),
                         .command_node_theme()
               )
             })
    if (add_ration) {
      .check_data(child_nebulae(x), list(ration_data = "set_ration_data"))
      axis.len <- vapply(set, function(df) tail(df$seq, n = 1), 1) + 1
      set <- .prepare_data_for_ration(x, .features_id, axis.len)
      group <- unique(sample_metadata(x)$group)
      pal.ex <- .as_dic(palette_stat(x), group,
                        fill = F, as.list = F, na.rm = T)
      labels.ex <- .as_dic(paste0("Ring: group: ", group), group,
                           fill = F, as.list = F)
      ggsets <-
        sapply(.features_id, simplify = F,
               function(id) {
                 if (is.null(set[[id]]))
                   return(ggsets[[id]])
                 ggset <- add_layers(ggsets[[id]],
                                     .command_node_ration(set[[id]]),
                                     new_command(labs, fill = "Classes / Groups"))
                 scale <- command_args(layers(ggset)$scale_fill_manual)
                 command_args(layers(ggset)$scale_fill_manual)$values <- 
                   c(pal.ex, c(" " = "white"), scale$values)
                 command_args(layers(ggset)$scale_fill_manual)$labels <- 
                   c(scale$labels, labels.ex)
                 ggset
               })
    }
    ggsets
  }
#' @importFrom dplyr mutate
.prepare_data_for_nodes <- 
  function(x, .features_id, add_ppcp = T){
    df <- data.frame(rel.index = -1L, pp.value = 0L, seq = 1:3)
    if (add_ppcp) {
      set <- ppcp_data(child_nebulae(x))
      set <- sapply(.features_id, simplify = F,
                    function(id) {
                      if (is.null(set[[id]]))
                        df
                      else
                        set[[id]]
                    })
    } else {
      set <- sapply(.features_id, function(id) df, simplify = F)
    }
    set
  }
.prepare_data_for_ration <- 
  function(x, .features_id, axis.len){
    set <- ration_data(child_nebulae(x))
    sapply(.features_id, simplify = F,
           function(id) {
             if (is.null(set[[id]]))
               return()
             df <- set[[id]]
             max <- cumsum(df$value)
             min <- c(0, max[-length(max)])
             factor <- axis.len[[id]] / max(max)
             df$x <- (min + df$value / 2) * factor
             df$width <- df$value * factor
             df
           })
  }
#' @aliases set_ppcp_data
#'
#' @title ...
#'
#' @description ...
#'
#' @details ...
#'
#' @name set_ppcp_data-methods
#'
#' @order 1
NULL
#> NULL

#' @exportMethod set_ppcp_data
#' @description \code{set_ppcp_data()}: get the function for generating
#' default parameters for the method
#' \code{set_ppcp_data}.
#' @rdname set_ppcp_data-methods
setMethod("set_ppcp_data", 
          signature = setMissing("set_ppcp_data"),
          function(){
            function(x){
              list(classes = names(tbl_graph(child_nebulae(x))))
            }
          })
#' @importFrom dplyr filter
#' @importFrom dplyr mutate
#' @exportMethod set_ppcp_data
#' @description \code{set_ppcp_data(x, ...)}: use the default parameters whatever 'missing'
#' while performing the method \code{set_ppcp_data}.
#' @rdname set_ppcp_data-methods
setMethod("set_ppcp_data", 
          signature = c(x = "mcnebula"),
          function(x, classes){
            reCallMethod("set_ppcp_data",
                         .fresh_param(set_ppcp_data()(x)))
          })
#' @exportMethod set_ppcp_data
#'
#' @title ...
#'
#' @description ...
#'
#' @param x ...
#' @param classes ...
#'
#' @rdname set_ppcp_data-methods
#'
#' @examples
#' \dontrun{
#' set_ppcp_data(...)
#' }
setMethod("set_ppcp_data", 
          signature = c(x = "mcnebula", classes = "character"),
          function(x, classes){
            ppcp_data <-
              suppressMessages(latest(filter_ppcp(x, dplyr::filter,
                                                  class.name %in% classes)))
            ppcp_data <- dplyr::select(ppcp_data, rel.index, class.name,
                                       pp.value, .features_id)
            ppcp_data(child_nebulae(x)) <-
              lapply(split(ppcp_data, ~ .features_id),
                     function(df) {
                       dplyr::mutate(df, seq = 1:nrow(df))
                     })
            return(x)
          })
#' @aliases set_ration_data
#'
#' @title ...
#'
#' @description ...
#'
#' @details ...
#'
#' @name set_ration_data-methods
#'
#' @order 1
NULL
#> NULL

#' @importFrom tidyr gather
#' @importFrom tibble as_tibble
#' @importFrom dplyr group_by
#' @importFrom dplyr summarise
#' @importFrom dplyr ungroup
#' @exportMethod set_ration_data
#' @description \code{set_ration_data()}: get the default parameters for the method
#' \code{set_ration_data}.
#' @rdname set_ration_data-methods
setMethod("set_ration_data", 
          signature = setMissing("set_ration_data"),
          function(){
            list(mean = T)
          })
#' @exportMethod set_ration_data
#' @description \code{set_ration_data(x, ...)}: use the default parameters whatever 'missing'
#' while performing the method \code{set_ration_data}.
#' @rdname set_ration_data-methods
setMethod("set_ration_data", 
          signature = c(x = "mcnebula"),
          function(x, mean){
            reCallMethod("set_ration_data",
                         .fresh_param(set_ration_data()))
          })
#' @exportMethod set_ration_data
#'
#' @title ...
#'
#' @description ...
#'
#' @param x ...
#' @param mean ...
#'
#' @rdname set_ration_data-methods
#'
#' @examples
#' \dontrun{
#' set_ration_data(...)
#' }
setMethod("set_ration_data", 
          signature = c(x = "mcnebula", mean = "logical"),
          function(x, mean){
            .check_data(x, list(features_quantification = "features_quantification",
                                sample_metadata = "sample_metadata"), "(x) <-")
            ration_data <-
              tidyr::gather(features_quantification(x),
                            key = "sample", value = "value", -.features_id)
            ration_data <-
              tibble::as_tibble(merge(ration_data, sample_metadata(x),
                                      by = "sample", all.x = T))
            if (mean) {
              ration_data <-
                dplyr::summarise(dplyr::group_by(ration_data, .features_id, group),
                                 value = mean(value, na.rm = T))
              ration_data <- dplyr::ungroup(ration_data)
            }
            ration_data(child_nebulae(x)) <- 
              split(ration_data, ~.features_id)
            return(x)
          })