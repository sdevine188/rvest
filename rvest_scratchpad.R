library(tidyverse)
library(rvest)
library(magrittr)
# library(keyboardSimulator)

# https://blog.rstudio.com/2014/11/24/rvest-easy-web-scraping-with-r/

# css selectors
# https://www.w3schools.com/cssref/css_selectors.asp

# crate html doc as string
# note: you can right-click a chrome browser page and click "Inspect view page source" then copy/paste into r as string
# the keyboardSimulator package and readClipboard() can be useful for this
doc <- '<div class = "style">
                <input id = "a" value = "123"></input>
                        <div class = "inner_div" id = "c">
                                <input id = "d" value = "test"></input>
                                <p> test p 1</p>
                                <input id = "e" value = "test2"></input>
                                <fake_tag id = "f" value = "test3"></fake_tag>
                                <input id = "g" value = "test4"></input>
                        </div>
                <fake_tag id = "f" value = "test3"></fake_tag>
                <input id = "b" class = "test_class"></input>
                <input id = "b" class = "test_class2"></input>
                <input id = "b" class = "fake_class"></input>
                <p> test p 2</p>
                <table style="width:100%">
                          <tr>
                        <th>Firstname</th>
                        <th>Lastname</th> 
                        <th>Age</th>
                        </tr>
                        <tr>
                        <td>Jill</td>
                        <td>Smith</td> 
                        <td>50</td>
                        </tr>
                        <tr>
                        <td>Eve</td>
                        <td>Jackson</td> 
                        <td>94</td>
                        </tr>
                </table>
        </div>'

# convert doc to html_page
html_page <- read_html(doc)
html_page

# get tag
html_page %>% html_nodes(css = "div")
html_page %>% html_nodes(css = "input")

# get specific subset of a list of nodes using magrittr's extract
html_page %>% html_nodes(css = "input") %>% extract(2:4)
html_page %>% html_nodes(css = "input") %>% extract(c(2, 5))

# get class
html_page %>% html_nodes(css = ".test_class")

# get id
html_page %>% html_nodes(css = "#b")

# get combinations
html_page %>% html_nodes(css = "div #a")
html_page %>% html_nodes(css = "div #d")
html_page %>% html_nodes(css = "div #a")

# get different kinds of nodes by sepaerting with comma
html_page %>% html_nodes(css = "p, input")

# select all input where parent is div
html_page %>% html_nodes(css = "div > input")

# select all input where parent is div with class = "inner_div"
html_page %>% html_nodes(css = "div .inner_div > input")

# select all input placed immediately following p
html_page %>% html_nodes(css = "p + input")

# select all input that are preceded anywhere by a p (not need to be immediately preceding)
html_page %>% html_nodes(css = "p ~ input")

# select all inputs that have a class 
html_page %>% html_nodes(css = "input[class]")

# select all inputs that have specific class value
html_page %>% html_nodes(css = "input[class = 'test_class2']")

# select all inputs that have attribute containing string "test"
# doesn't work for some reason
# html_page %>% html_nodes(css = "[class ~= 'test']")
# html_page %>% html_nodes(css = "input[class |= 'test']")

# select all inputs containing substring "test"
html_page %>% html_nodes(css = "input[class *= 'test']")

# select input whose class attribute begins with "test"
html_page %>% html_nodes(css = "input[class ^= 'test']")

# select input whose class attribute ends with "test"
html_page %>% html_nodes(css = "input[class $= '2']")

# select input which are nth input of parent
html_page %>% html_nodes(css = "input:nth-of-type(2)")
html_page %>% html_nodes(css = "input:nth-of-type(3)")
html_page %>% html_nodes(css = "input:nth-of-type(4)")

# select nth child
html_page %>% html_nodes(css = "input:nth-child(2)")
html_page %>% html_nodes(css = "input:nth-child(3)")
html_page %>% html_nodes(css = "input:nth-child(4)")

# select elements that are not a match
html_page %>% html_nodes(css = ":not(input)")
html_page %>% html_nodes(css = ":not(input[class])")
html_page %>% html_nodes(css = ":not(input[id])")
html_page %>% html_nodes(css = ":not(p)")



##################################################################


# get html_attr
html_page %>% html_nodes(css = "input[id = a]") %>% html_attr("value")


##################################################################


# get html_text
html_page %>% html_nodes(css = "p") %>% html_text()


#####################################################################


# get html_table
html_page %>% html_nodes(css = "table") %>% html_table()


######################################################################
######################################################################
######################################################################


# get brad pitt's movies from imdb

# get website html
url <- "https://www.imdb.com/name/nm0000093/"
html <- read_html(x = url)
html

# parse for movies
html %>% html_nodes(css = "div[class = 'filmo-category-section'] div[id *= 'actor'] b") %>% html_text()


######################################################################
######################################################################
######################################################################


# for websites with dynamically loaded html, use selenium in python
# which can just copy all dynamically-loaded html as text with driver.page_source
# then you can load the raw html into r for further analysis

# note the example_raw_html_df.csv was produced using selenium_scratchpad.py
# saved at'C:\\Users\\Stephen\\Desktop\\Python\\selenium'

# load a raw_html_df pulled by selenium in python
raw_html_df <- read_csv("example_raw_html_df.csv")
raw_html_df %>% glimpse()

# read html
html_page <- read_html(raw_html_df %>% pull(raw_html))

# inspect
html_page
html_page %>% html_nodes(css = "h3 a[class = 'l']") %>% html_attr("href")
