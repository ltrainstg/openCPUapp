#' Plot github stats
#'
#' Plots the total number of forks and stars for all repositories of
#' a user or organization.
#'
#' @param id name of the github user or organization. Default: "Hadley"
#' @param type either "users" (default) or "orgs"
#' @param max maximum number of repositories to plot. Default: 20, max: 100
#' @author Scott Chamberlain, Jeroen Ooms
#' @import ggplot2 curl jsonlite reshape2
#' @export
#' @examples \dontrun{
#' gitstats(max = 10)
#' gitstats(max = 40)
#' gitstats(id = "jeroen", max = 30)
#' gitstats(id = "ropensci", type = "orgs", max = 70)
#' }
gitstats <- function (id = "hadley", type = c("users", "orgs"), max = 20) {

	type <- match.arg(type, choices=c('users','orgs'))
	max <- min(max, 100)

	#call github API using jsonlite
	url <- file.path("https://api.github.com", type, id, "repos")
	url <- paste0(url, "?type=owner&sort=pushed&per_page=100")
	out <- jsonlite::fromJSON(url, flatten = TRUE)

	#resort factor)
	out <- out[order(out$watchers, decreasing = TRUE)[seq_len(max)],
	           c("name", "watchers", "forks", "open_issues")]
	out$name <- factor(out$name, levels = rev(out$name))

	#reshape to "long" dataframe"
	names(out) <- c("Repo", "Stars", "Forks", "Issues")
	out2 <- reshape2::melt(out, id = 1)

	#create ggplot object
	time <- format(Sys.time(), tz = 'UTC', usetz = TRUE)
	ggplot(out2, aes(Repo, value)) + geom_bar(stat="identity") + coord_flip() +
		facet_wrap(~variable, scales = "free_x") + xlab("") + ylab("") +
    ggtitle(sprintf("Github stats from: '%s' (%s)", id, time))

}


#' @export
new_fun <- function (id = "hadley", type = c("users", "orgs"), max = 20) {

  type <- match.arg(type, choices=c('users','orgs'))
  max <- min(max, 100)

  #call github API using jsonlite
  url <- file.path("https://api.github.com", type, id, "repos")
  url <- paste0(url, "?type=owner&sort=pushed&per_page=100")
  out <- jsonlite::fromJSON(url, flatten = TRUE)

  #resort factor)
  out <- out[order(out$watchers, decreasing = TRUE)[seq_len(max)],
             c("name", "watchers", "forks", "open_issues")]
  out$name <- factor(out$name, levels = rev(out$name))

  #reshape to "long" dataframe"
  names(out) <- c("Repo", "Stars", "Forks", "Issues")
  out2 <- reshape2::melt(out, id = 1)

  #create ggplot object
  time <- format(Sys.time(), tz = 'UTC', usetz = TRUE)
  ggplot(out2, aes(Repo, value)) + geom_bar(stat="identity") + coord_flip() +
    facet_wrap(~variable, scales = "free_x") + xlab("") + ylab("") +
    ggtitle(sprintf("Github stats from: '%s' (%s)", id, time))

}

#' @export
hello <- function(myname){

  if(myname == ""){
    stop("NAME!")
  }

  library(officer)

  my_pres <- read_pptx()
  my_pres <- add_slide(my_pres,
                       layout = "Two Content", master = "Office Theme")
  print(my_pres, 'temp.pptx')

  l <- list(
    message = paste("Sup", myname, "! This is", getwd())
  )


  return(l)

}
