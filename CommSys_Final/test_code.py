name='Konaark'
name_bin=''
for i in range(len(name)):
    name_bin+=bin(ord(name[i]))[2:]
print(name_bin)