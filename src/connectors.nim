import os
import tables

type
    Document* = object
        text*: string
        url*: string
        metadatas*: Table[string, string]

proc computeMetadatas(path: string, lines: string): Table[string, string] =
    result["chars_count"] = $len(lines)
    result["file_size"] = $getFileSize(path) & "b"

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
        result.add(Document(text: lines, url: url, metadatas: computeMetadatas(url, lines)))
    
