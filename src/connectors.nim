import os

type
    Document* = object
        text*: string
        url*: string

proc fetch*(path: string, recursive: bool = true): seq[Document] =
    result = newSeq[Document]()
    var paths = newSeq[string]()
    if recursive:
        for file in walkDirRec path:
            paths.add(file)
    else:
        for component, file in walkDir path:
            if component == PathComponent.pcFile:
                paths.add(file)
                
    for url in paths:
        let lines = readFile(url)
        result.add(Document(text: lines, url: url))
    
