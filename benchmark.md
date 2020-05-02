# Performance evaluation on different versions

## Dataset

The dataset contains 159 Mb, divided in 33049 files, these files contain news from a few years ago in plain text format.

## Evolutions

### Commit hash: 3665f0

See [README](https://github.com/Smlep/nim-search-engine/blob/3665f0dd60f355a06f9fd57a7c0c6f7b50a45150/README.md) from this commit to see the current state.

Indexing time: 3439,50s user 10,83s system 43% cpu 2:13:08,08 total

Search time:
- president: 2,89s user 0,23s system 99% cpu 3,135 total
- bleu: 3,33s user 0,22s system 98% cpu 3,596 total
- un deux trois quatre: 3,26s user 0,36s system 97% cpu 3,733 total
- un deux trois quatre --all-of: 3,44s user 0,29s system 99% cpu 3,762 total
- unknownword: 3,07s user 0,21s system 99% cpu 3,304 total

Current evaluation is done on only one sample, so results are not precise and should be approximated.