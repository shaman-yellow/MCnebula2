# ==========================================================================
# visualize the nebula and annotate it with multiple attributes
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#' @aliases annotate_nebula
#'
#' @title ...
#'
#' @description ...
#'
#' @details ...
#'
#' @name annotate_nebula-methods
#'
#' @order 1
NULL
#> NULL

#' @importFrom dplyr select
#' @importFrom gridExtra arrangeGrob
#' @exportMethod annotate_nebula
#'
#' @aliases annotate_nebula
#'
#' @title ...
#'
#' @description ...
#'
#' @details ...
#'
#' @param x ...
#' @param nebula_name ...
#'
# @inheritParams rdname
#'
#' @return ...
#'
#' @seealso \code{\link{draw_nodes}}, \code{\link{draw_structures}}...
#'
#' @rdname annotate_nebula-methods
#'
#' @examples
#' \dontrun{
#' annotate_nebula(...)
#' }
setMethod("annotate_nebula", 
          signature = c(x = "ANY", nebula_name = "character"),
          function(x, nebula_name){
            .message_info_formal("MCnebula2", "annotate_nebula")
            data <- layout_ggraph(child_nebulae(x))[[nebula_name]]
            data <- dplyr::select(data, x, y,
                                  .features_id = name, size = tani.score)
            .features_id <- data$.features_id
            x <- draw_structures(x, nebula_name)
            x <- draw_nodes(x, nebula_name)
            nodes_grob <- nodes_grob(child_nebulae(x))
            nodes_grob <- lapply(.features_id,
                                 function(id) {
                                   gridExtra::arrangeGrob(nodes_grob[[id]])
                                 })
            ggset <- ggset(child_nebulae(x))[[ nebula_name ]]
            layers(ggset)[[ "ggraph::geom_node_point" ]] <- NULL
            ggset_annotate(child_nebulae(x))[[ nebula_name ]] <- 
              add_layers(modify_annotate_child(ggset),
                         .command_node_annotate(data, nodes_grob))
            return(x)
          })