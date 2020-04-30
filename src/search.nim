import indexing
import sets
import sequtils
import tables

proc search*(index: Index, word: string) : seq[string] = 
    if not index.wordToDids.hasKey(word):
        return @[]
    var dids : seq[int] = index.wordToDids[word]
    for did in dids:
        result.add(index.didToUrl[did])

proc searchAllOf*(index: Index, words: seq[string]) : seq[string] =
    var searches : seq[HashSet[string]]
    for word in words:
        searches.add(toHashSet(index.search(word)))

    var setResult = searches[0]
    for search in searches[1..^1]:
        setResult = setResult.intersection(search)
    result = setResult.toSeq()

proc searchOneOf*(index: Index, words: seq[string]) : seq[string] =
    var searches : HashSet[string]
    for word in words:
        searches.incl(toHashSet(index.search(word)))
    result = searches.toSeq()