import connectors
import indexing
import os
import processing
import search
import sequtils

let docs = fetch("tests/files")
var processors: seq[TextProcessor] = @[]
processors.add(Normalizer())

var tokendocs: seq[TokenizedDocument] = docs.map(proc(d: Document): TokenizedDocument = analyze(d, processors))

var indexed = indexDocs(tokendocs)

var reversedIndex =  buildReversedIndex(indexed)

reversedIndex.save("indexed1")

var loaded = loadIndex("indexed1")

echo loaded.searchOneOf(@[paramStr(1), paramStr(2)])