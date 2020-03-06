#
# python3 hex2bin <input file>
# generate input file
# $cat <list file>.lst | grep <instruction> | awk '{print $2, $3}' >> <file>
#
import sys

#
# start main program
#
def main():
	if len(sys.argv) <= 1:
		print ("python3 hex2bin <input file>")
		sys.exit()
	
	isnts=[]
	s = ""
	# try to open write file
	try:
		fd = open(sys.argv[1], "r")
	except:
		print ("Could not open read file \"", sys.argv[1],"\"")
		sys.exit()	
	
	# repeat read line from file
	print("inst.\t\thex\t\topcode   func")
	for line in fd:
		# each line format Hexcode instruction
		# XXXXX ccc
		l = line.strip().split(' ')
		# ignore unused data line
		if l[0]== 'file':
			continue
		# ignore repeat data 	
		if l[1] in isnts:
			continue
		isnts.append(l[1])
		# convert hex value to binary value with leading pad zero
		v = bin(int(l[0], 16)).format(32)[2:].zfill(32)
		# write to a string buffer
		s += l[1] + "\t\t" + l[0] + "\t" + str(v[26:32]) + " " + v[0:6] + " " + str(v) + "\n" 
	# output the string buffer
	print(s)
	# try to close write file
	try:
		fd.close
	except:
		pass	

#
# end main progam
#
if __name__ == '__main__':
	main()
	
'''
l = sys.argv[1].strip().split(' ')
print(l)

opcode = bin(int(l[0], 16)).format(32)[2:8]
funccode = bin(int(l[0], 16)).format(32)[29:34]

print(l[1] + "op code:" + opcode + ",func code:" + funccode)
'''