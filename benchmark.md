# Performance evaluation on different versions

## Dataset

The dataset contains 159 Mb, divided in 33049 files, these files contain news from a few years ago in plain text format.

## Evolutions

### Commit hash: 3665f0

See [README](https://github.com/Smlep/nim-search-engine/blob/3665f0dd60f355a06f9fd57a7c0c6f7b50a45150/README.md) from this commit to see the current state.

Indexing time: 3407,48s user 8,53s system 99% cpu 57:07,22 total

Search time:
- president: 2,78s user 0,22s system 97% cpu 3,072 total
- bleu: 2,78s user 0,21s system 99% cpu 2,994 total
- un deux trois quatre: 3,07s user 0,29s system 99% cpu 3,370 total
- un deux trois quatre --all-of: 2,96s user 0,22s system 99% cpu 3,198 total
- unknownword: 2,76s user 0,21s system 99% cpu 2,976 total

Current evaluation is done on only one sample, so results are not precise and should be approximated.

### Commit hash: 3be5fca

Added metadatas, with only 3 simple metadatas yet: number of chars, size of file and number of words

Indexing time: 3252,95s user 6,65s system 99% cpu 54:28,08 total

Index file size: 199M

Search time:
- president: 7,19s user 0,45s system 99% cpu 7,650 total
- bleu: 5,14s user 0,37s system 99% cpu 5,516 total
- un deux trois quatre: 130,74s user 0,64s system 99% cpu 2:11,45 total
- un deux trois quatre --all-of: 129,06s user 0,58s system 99% cpu 2:09,67 total
- unknownword: 5,00s user 0,37s system 99% cpu 5,388 total

Nimprof shows that for the first search (president):
- 57% of time is spent loading index, mostly spent in `marshal`, converting the string to object.
- 42% of time is spent searching.