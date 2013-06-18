import os
import sys

name = os.path.splitext(sys.argv[1])[0]

input = open(sys.argv[1])

target = "@[\n"

weight = 0

for line in input :
    weight = 0
    data = "    @["
    for char in line.split() :
        weight += int(char)
        data += "@" + str(weight) + ","
    data += "],\n"
    target += data

target += "];\n"

input.close()

output = open("../Milkboy/" + name + ".h", "wt")

output.write(target)
output.write("\n")
output.close()

print "reorg " + sys.argv[1] + " done!"
