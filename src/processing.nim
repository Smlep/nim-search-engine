import connectors
import strutils
import unicode
import unidecode

type
    TextProcessor* = ref object of RootObj
    
    Normalizer* = ref object of TextProcessor

    TokenizedDocument* = object
        words*: seq[string]
        url*: string

# watch out: 'eval' relies on dynamic binding
method process(t: TextProcessor, word: string): string {.base.} =
  # override this base method
  quit "to override!"

method process*(n: Normalizer, word: string): string =
    result = word.toLower()
    result = result.unidecode()
    

proc analyze*(document: Document, textProcessors: seq[TextProcessor]): TokenizedDocument =
    var words: seq[string]
    for word in split(document.text, ' '):
        var processedWord = word
        for textProcessor in textProcessors:
            processedWord = textProcessor.process(processedWord)
        words.add(processedWord)

    result = TokenizedDocument(words: words, url: document.url)