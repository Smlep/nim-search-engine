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
        didToUrl*: seq[string]
        didToMetadatas*: seq[Table[string, string]]
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

proc buildReversedIndex*(index: Index = Index(), postings: seq[Posting], metadatas: Table[string, Table[string, string]]): Index =
    result = index

    # The most of indexing computation time is spent here
    # This is the method which seems to give the fastest search,
    # but indexing ends up being really slow
    for posting in postings:
        result.wordToDids[posting.word] = @[]
        for url in posting.urls:
            var pos = result.didToUrl.find(url)
            if pos == -1:
                result.didToUrl.add(url)
                result.didToMetadatas.add(metadatas[url])
                pos = result.didToUrl.len - 1
            result.wordToDids[posting.word].add(pos)


proc save*(index: Index, path: string) =
    writeFile(path, $$index)
    
proc loadIndex*(path: string) : Index =
    if not fileExists(path):
        quit("File " & path & " does not exist")
    var indexStr: string = readFile(path)
    result = to[Index](indexStr)
