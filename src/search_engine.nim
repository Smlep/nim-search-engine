import connectors
import indexing
import os
import parseopt
import processing
import search
import sequtils
import tables

proc computeIndex(path: string, savePath: string) =
  let docs = fetch(path)
  var processors: seq[TextProcessor] = @[]
  processors.add(Normalizer())

  var tokendocs: seq[TokenizedDocument] = docs.map(proc(d: Document): TokenizedDocument = analyze(d, processors))

  var indexed = indexDocs(tokendocs)

  var reversedIndex = buildReversedIndex(indexed)

  reversedIndex.save(savePath)

proc loadAndSearch(indexPath: string, words: seq[string], allOf: bool) =

  var loaded = loadIndex(indexPath)
  
  if allOf:
    echo loaded.searchAllOf(words)
  else:
    echo loaded.searchOneOf(words)


proc usage() =
  echo("usage: [mode] [modeArgs]")
  echo("[mode]: {index, search}")
  echo("To index files, allowing faster searching:")
  echo("index filesPath savePath")
  echo("To search words in the indexed files:")
  echo("search savePath word1 word2 word3")
  echo("search available options:")
  quit("--all-of: searches files containing all words instead of one of the words")

proc main() =
  if paramCount() < 1:
    usage()

  var p = initOptParser()
  var allOf = false
  var arguments = newSeq[string]()
  while true:
    p.next()
    case p.kind
    of cmdEnd: break
    of cmdShortOption, cmdLongOption:
      if p.val == "":
        if p.key == "all-of":
          allOf = true
      else:
        discard
    of cmdArgument:
      arguments.add(p.key)


  if arguments.len < 1 or not (arguments[0] in ["index", "search"]):
    usage()

  if arguments[0] == "index":
    if arguments.len < 3:
      usage()
    computeIndex(arguments[1], arguments[2])

  if arguments[0] == "search":
    if arguments.len < 3:
      usage()
    loadAndSearch(arguments[1], arguments[2..^1], allOf)

main()