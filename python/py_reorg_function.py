# import os
# import sys
# 
# name = os.path.splitext(sys.argv[1])[0]
# 
# input = open(sys.argv[1])
# 
# target = "@[\n"
# 
# weight = 0
# 
# for line in input :
#     weight = 0
#     data = "    @["
#     for char in line.split() :
#         weight += int(char)
#         data += "@" + str(weight) + ","
#     data += "],\n"
#     target += data
# 
# target += "];\n"
# 
# input.close()
# 
# output = open("../Milkboy/" + name + ".h", "wt")
# 
# output.write(target)
# output.write("\n")
# output.close()
# 
# print "reorg " + sys.argv[1] + " done!"

import os

def reorg(f) :
    input = open(f)

    titles = []

    stages = []

    stage = 0

    for line in input :
        words = line.split()

        if words[0][0] == '#' :
            continue

        for i in range(0, len(words)) :
            if i == 0 :
                titles.append(words[i])
            else :
                if i > len(stages) :
                    stages.append([])
                stages[i - 1].append(int(words[i]))

        stage += 1

    # calc weight level
    for stage in stages :
        weight = 0
        for i in range(0, len(stage)) :
            weight += stage[i]
            stage[i] = weight
        stage.append(weight)

    # prepare output string
    txt = "@[\n"

    for s in stages :
        txt += "    @["
        for w in s :
            txt += ("@" + str(w) + ",").rjust(7, ' ')
        txt += "],\n"

    txt += "];\n"

    name = os.path.splitext(f)[0]

    output = open("../Milkboy/" + name + ".h", "wt")

    output.write(txt)

    output.close()

reorg("data_function_item.txt")
reorg("data_function_step.txt")
