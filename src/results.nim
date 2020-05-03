import search
import tables

proc newlineDisplay*(fds: seq[FoundDocument]) =
    for fd in fds:
        echo fd.url

proc onelineDisplay*(fds: seq[FoundDocument], sep: string = " ") =
    for fd in fds:
        stdout.write fd.url
        stdout.write sep

proc metadatasDisplay*(fds: seq[FoundDocument]) =
    for fd in fds:
        echo fd.url, " "
        echo "metadatas: "
        for key, value in fd.metadatas.pairs:
            echo "  ", key, ": ", value
        echo ""