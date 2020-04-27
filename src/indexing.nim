import marshal
import os
import sets
import streams
import tables

import processing

type
    Posting* = object
        word: string
        urls*: HashSet[string]

    Index* = object
        urlToDid*: Table[string, int]
        wordToDids*: Table[string, seq[int]]

proc indexDocs*(documents: seq[TokenizedDocument]): seq[Posting] =
    result = @[]
    for document in documents:
        for word in document.words:
            # This is slow should be optimized
            var found = false
            for posting in result.mitems:
                if posting.word == word:
                    posting.urls.incl(document.url)
                    found = true
                    break
            if not found:
                result.add(Posting(word: word, urls: toHashSet([document.url])))

proc buildReversedIndex*(postings: seq[Posting]): Index =
    result = Index()
    var id = 0
    for posting in postings:
        for url in posting.urls:
            if not (url in result.urlToDid):
                result.urlToDid[url] = id
                id += 1

    for posting in postings:
        result.wordToDids[posting.word] = @[]
        for url in posting.urls:
            result.wordToDids[posting.word].add(result.urlToDid[url])

proc save*(index: Index, path: string) =
    writeFile(path, $$index)
    
proc loadIndex*(path: string) : Index =
    if not fileExists(path):
        quit("File " & path & " does not exist")
    var indexStr: string = readFile(path)
    result = to[Index](indexStr)