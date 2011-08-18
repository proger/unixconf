import sys

def isoproc(text):
    charlist = []
    rl = range(len(text))
    char = 0
    while rl:
        if text[char:char + 2] == '&#':
            enti = text.index(';', char)

            isoent = text[char:enti + 1] # &#1023;
            realchar = unichr(int(isoent[2:6]))
            charlist.append(realchar)

            char = enti + 1
        else:
            charlist.append(text[char])
            char += 1
        rl = range(char, len(text))

    return u''.join(charlist).encode('utf-8')

print isoproc(sys.stdin.read())
