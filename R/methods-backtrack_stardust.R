# ==========================================================================
# comparation after filtering; add or remove classes for stardust_classes
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
setMethod("backtrack_stardust", 
          signature = setMissing("backtrack_stardust",
                                 x = "mcnebula"),
          function(x){
            .get_info("backtrack_stardust", "no args found",
                      "\n\tget filtered classes")
            set <- dplyr::filter(backtrack(mcn_dataset(x))[[ "stardust_classes" ]],
                                 !rel.index %in% stardust_classes(x)[[ "rel.index" ]])
            stat <- table(set$rel.index)
            df <- merge(data.frame(rel.index = as.integer(names(stat)),
                                   features_number = as.integer(stat)),
                        dplyr::select(classification(x),
                                      rel.index, class.name, description),
                        by = "rel.index", all.x = T)
            tibble::as_tibble(df)
          })
setMethod("backtrack_stardust", 
          signature = setMissing("backtrack_stardust",
                                 x = "mcnebula",
                                 class.name = "character",
                                 remove = "ANY"),
          function(x, class.name, remove){
            if (missing(remove))
              remove <- F
            rel.index <-
              dplyr::filter(classification(x),
                            class.name %in% !!class.name)[[ "rel.index" ]]
            backtrack_stardust(x, rel.index = rel.index, remove = remove)
          })
setMethod("backtrack_stardust", 
          signature = setMissing("backtrack_stardust",
                                 x = "mcnebula",
                                 rel.index = "numeric",
                                 remove = "ANY"),
          function(x, rel.index, remove){
            if (missing(remove))
              remove <- F
            else if (!is.logical(remove))
              stop( "`remove` must be logical or as missing as `FALSE`" )
            .get_info("backtrack_stardust", paste0("remove == ", remove))
            if (is.null(stardust_classes(x))) {
              stop(paste0("is.null(stardust_classes(x)) == T. ",
                          "use `create_stardust_classes(x)` previously."))
            }
            if (remove) {
              reference(mcn_dataset(x))[[ "stardust_classes" ]] <- 
                dplyr::filter(stardust_classes(x), !rel.index %in% !!rel.index)
            } else {
              if (is.null(backtrack(mcn_dataset(x))[[ "stardust_classes" ]]))
                stop( "nothing in `backtrack(mcn_dataset(x))`" )
              set <- dplyr::filter(backtrack(mcn_dataset(x))[[ "stardust_classes" ]],
                                   rel.index %in% !!rel.index)
              if (nrow(set) == 0)
                stop( "no any record for specified classes in `backtrack(mcn_dataset(x))`" )
              reference(mcn_dataset(x))[[ "stardust_classes" ]] <- 
                dplyr::distinct(dplyr::bind_rows(stardust_classes(x), set))
            }
            return(x)
          })