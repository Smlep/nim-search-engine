import connectors
import indexing
import os
import parseopt
import processing
import results
import search
import sequtils

proc computeIndex(path: string, savePath: string, addToIndex: string) =
  let docs = fetch(path)
  var processors: seq[TextProcessor] = @[]
  processors.add(Normalizer())

  var tokendocs: seq[TokenizedDocument] = docs.map(proc(d: Document): TokenizedDocument = analyze(d, processors))

  var indexed = indexDocs(tokendocs)

  var reversedIndex: Index

  if addToIndex != "":
    var oldIndex = loadIndex(addToIndex)
    reversedIndex = oldIndex.buildReversedIndex(indexed)
  else:
    reversedIndex = buildReversedIndex(postings=indexed)

  reversedIndex.save(savePath)

proc loadAndSearch(indexPath: string, words: seq[string], allOf: bool): seq[string] =

  var loaded = loadIndex(indexPath)
  
  if allOf:
    result = loaded.searchAllOf(words)
  else:
    result = loaded.searchOneOf(words)



proc usage() =
  echo("usage: [mode] [modeArgs]")
  echo("[mode]: {index, search}")
  echo("To index files, allowing faster searching:")
  echo("index filesPath savePath")
  echo("indexing available options:")
  echo("--add-to:filepath: add indexed files to an already existing index saved at filepath")
  echo("To search words in the indexed files:")
  echo("search savePath word1 word2 word3")
  echo("search available options:")
  echo("--all-of: searches files containing all words instead of one of the words")
  quit("--one-line: display results one line separated with whitespaces, instead of newlines")


proc main() =
  if paramCount() < 1:
    usage()

  var p = initOptParser()
  # Should the research be an and
  var allOf = false
  # Should all results be displayed on one line
  var oneLine = false
  # Should indexing be added to an existing file
  var addToIndex = ""
  var arguments = newSeq[string]()
  while true:
    p.next()
    case p.kind
    of cmdEnd: break
    of cmdShortOption, cmdLongOption:
      if p.val == "":
        if p.key == "all-of":
          allOf = true
        if p.key == "one-line":
          oneLine = true
      else:
        if p.key == "add-to":
          addToIndex = p.val

    of cmdArgument:
      arguments.add(p.key)


  if arguments.len < 1 or not (arguments[0] in ["index", "search"]):
    usage()

  if arguments[0] == "index":
    if arguments.len < 3:
      usage()
    computeIndex(arguments[1], arguments[2], addToIndex)

  if arguments[0] == "search":
    if arguments.len < 3:
      usage()
    var results = loadAndSearch(arguments[1], arguments[2..^1], allOf)
    if oneLine:
      oneLineDisplay(results)
    else:
      newlineDisplay(results)

main()