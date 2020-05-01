proc newlineDisplay*(urls: seq[string]) =
    for url in urls:
        echo url

proc onelineDisplay*(urls: seq[string], sep: string = " ") =
    for url in urls:
        stdout.write url
        stdout.write sep