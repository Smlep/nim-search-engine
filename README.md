# Nim search engine
A simple search engine for local files with indexing implementation in [nim](https://nim-lang.org/).

This search engine works in two times, first you have to build an index, then search through the indexed files.

## Usage

### Compile project

With [nim](https://nim-lang.org/) installed, run
```
nimble install
```

### Index

Running
```
./search_engine index filesPath indexPath
```

indexes all files located in filesPath (recursively) and saves the index in indexPath.

### Search

Once an index file is built, search can be done with
```
./search_engine search [--all-of] [--one-line] indexPath word1 word2 word3... 
```

The indexPath must be the one built through the `index` command.

Default search mode is **one of** (**OR**), meaning a document only has to contain one of the words to appear in the search results.

Setting the `--all-of` option switch search to **all of** mode (**AND**), meaning the the engine is looking for documents containing all of the given words.

Setting `--one-line` option updates results displaying to a one line display, with every elements separated with a whitespace.

### Example
```
$ nimble install
Installing search_engine@0.1.0
Building search_engine/search_engine using c backend
Answer:    Success: search_engine installed successfully.

$ ./search_engine index tests/files myindex

$ ./search_engine search myindex lorem
tests/files/file2
tests/files/lorem
```

## Improvements

- [ ] Incrementing indexing, handling of document generations
- [X] Metadata handling
- [ ] Add and delete document to existing index
- [ ] Words positions handling
- [ ] Evaluate and improve performances
- [ ] Parallelize search to greatly improve performances

## Disclaimer

This is beginner's nim code, feel free to open discussions about what wasn't done in a nice way, or what could be reformatted to fit nim's style.

Evolution of performances can be found [here](benchmark.md).