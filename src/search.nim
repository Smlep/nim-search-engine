import indexing
import sequtils
import tables

type
    FoundDocument* = object
        url*: string
        metadatas*: Table[string, string]

proc intersection(documents: seq[FoundDocument], other: seq[FoundDocument]): seq[FoundDocument] =
    var otherUrls = other.map(proc(fd: FoundDocument): string= fd.url)
    for document in documents:
        if document.url in otherUrls:
            result.add(document)

proc contains(documents: seq[FoundDocument], document: FoundDocument): bool =
    result = document.url in documents.map(proc(fd: FoundDocument): string= fd.url)

proc union(documents: seq[FoundDocument], other: seq[FoundDocument]): seq[FoundDocument] =
    result = documents
    for document in other:
        if not (document in result):
            result.add(document)

proc search*(index: Index, word: string): seq[FoundDocument] = 
    if not index.wordToDids.hasKey(word):
        return @[]
    var dids : seq[int] = index.wordToDids[word]
    for did in dids:
        result.add(FoundDocument(url: index.didToUrl[did], metadatas: index.didToMetadatas[did]))

proc searchAllOf*(index: Index, words: seq[string]): seq[FoundDocument] =
    for word in words:
        result = result.intersection(index.search(word))

proc searchOneOf*(index: Index, words: seq[string]): seq[FoundDocument] =
    for word in words:
        result = result.union(index.search(word))
