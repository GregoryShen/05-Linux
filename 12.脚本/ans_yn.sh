题目：
1. 当执行一个程序的时候，这个程序会让使用者选择Y或N
2. 如果使用者输入Y或y时，就显示 “OK，continue”
3. 如果使用者输入n或N时，就显示“oh，interrupt”
4. 如果不是Y/y/N/n之内的其他字符，就显示 I don\'t know what your choice is
(利用中括号，&&和 ||)

#!/bin/bash
# Program:
#	User input a character and the program will give correspond result
# History:
# 2018/8/9 		test	First release

read -p "Please input Y/N: " yn
[ -z "${yn}" ] && echo "You MUST input a character" && exit 0
[ "${yn}" == "Y" ] || [ "${yn}" == "y" ] && echo "OK，continue"
[ "${yn}" == "N" ] || [ "${yn}" == "n" ] && echo "Oh, interrupt"
[ "${yn}" != "Y" or "${yn}" != "y" ] && [ "${yn}" != "N" or "${yn}" != "n" ] &&
echo "I don't know what your choice is"

#总结：
# 1. 当条件中存在多个条件时，可以使用条件的联合写法，但是写错了，不是or， 是-o
# 2. 逻辑的全面性也是有问题的，如果不是YyNn的其他字符，那都判断成不识别，
# 这里就不需要再写判断条件了，包括空值也不用在这判断了，直接归到最后的echo里

正确的答案为：
[dmtsai@study bin]$ vim ans_yn.sh
#!/bin/bash
# Program:
# 	This program shows the user's choice
# History:
# 2015/07/16	VBird	First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

read -p "Please input (Y/N): " yn
[ "${yn}" == "Y" -o "${yn}" == "y" ] && echo "OK, continue" && exit 0
[ "${yn}" == "N" -o "${yn}" == "n" ] && echo "Oh, interrupt!" && exit 0
echo "I don't know what your choice is" && exit 0