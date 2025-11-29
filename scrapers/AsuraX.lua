--------------------------------------
-- @name    AsuraComic 
-- @url     https://asuracomic.net
-- @author  kain
-- @license MIT
--------------------------------------




----- IMPORTS -----
Html = require("html")
Headless = require('headless')
Time = require("time")
--- END IMPORTS ---




----- VARIABLES -----
Browser = Headless.browser()
Page = Browser:page()
Base = "https://asuracomic.net"
Delay = 1 -- seconds
--- END VARIABLES ---



----- MAIN -----

--- Searches for manga with given query.
-- @param query Query to search for
-- @return Table of tables with the following fields: name, url
function SearchManga(query)
    local url = Base .. "/series?page=1&name=" .. query
    Page:navigate(url)
    Time.sleep(Delay)

    local mangas = {}

    for i, v in ipairs(Page:elements(".grid.grid-cols-2.sm\\:grid-cols-2.md\\:grid-cols-5.gap-3.p-4 > a")) do
        local pgz = v:element(".block.text-\\[13\\.3px\\].font-bold")
        local manga = { url = v:attribute('href'), name = pgz:inner_text() }
        mangas[i + 1] = manga
    end

    return mangas
end


--- Gets the list of all manga chapters.
-- @param mangaURL URL of the manga
-- @return Table of tables with the following fields: name, url
function MangaChapters(mangaURL)
    Page:navigate(mangaURL)
    Time.sleep(Delay)

    local chapters = {}
    local ii = 0
    for _, v in ipairs(Page:elements(".pl-4.pr-2.pb-4.overflow-y-auto.scrollbar-thumb-themecolor.scrollbar-track-transparent.scrollbar-thin.mr-3.max-h-\\[20rem\\].space-y-2\\.5 > a")) do
-- @string.sub(v:inner_text(), 8, 2)
        local n = tonumber(ii)  
        ii = ii + 1
        local elem = Html.parse(v:html())
        local link = v

        local chapter = { url = link:attr("href"), name = link:inner_text():text() }

        if n ~= nil then
            chapters[n] = chapter
        end
    end

    return chapters
end


--- Gets the list of all pages of a chapter.
-- @param chapterURL URL of the chapter
-- @return Table of tables with the following fields: url, index
function ChapterPages(chapterURL)
    Page:navigate(chapterURL)
    Time.sleep(Delay)

    local pages = {}
    for i, v in ipairs(Page:elements(".py-8.-mx-5.md\\:mx-0.flex.flex-col.items-center.justify-center > img")) do
        local p = { index = i, url = v:attribute("src") }
        pages[i + 1] = p
    end

    return pages
end

--- END MAIN ---




----- HELPERS -----
--- END HELPERS ---

-- ex: ts=4 sw=4 et filetype=lua
