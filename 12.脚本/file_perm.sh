#!/bin/bash
# Program:
#       Let user input a filename and judge the parameters of it.
# History:
# 2018/07/06    test    Second release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

echo -n "Please input a filename and we will show its parameters\n"
read -p "filename: " filename
test -e ${fileanme} || echo "Filename does not exist" && 
test

# 几个错误：
# 1. 如果是带有特殊符号的echo，应该是echo -e，而不是echo -n， 
# 2. 在判断文件名是否存在的时候用的方式不对，test...||...&&方式肯定不对，
#    自己写到这也发现了，可是怎么改不知道，
#    这个问题应该划分为两步：
#    1)首先对用户输入进行校验，如果是输入为空怎么办
#      这个问题应该是转化为对filename 这个字符串的判断，利用字符串不存在
#      返回true的参数，结合&&就可以搞定。所以应该是 
#      test -z ${filename} && echo "You MUST input a filename." && exit 0
#    2)第二步确认用户输入有内容了再来判断是否存在对应文件名
#      这个时候为了要避免用到test...||...&&所以要用到反相判断，连续用两个&&
#      test ! -e ${filename} && echo "The filename '${filename}' DO NOT exist" && exit 0
# 3. 判断文件类型没有什么好说的，利用一个&&，然后对filetype变量进行赋值，哪个
#    为真最后就输出哪个，关键是这种思路，只用一个&&的思路，以及用变量来赋值   
# 4. 在进行权限判断的时候，要注意对权限变量的累加，这也是个技巧

利用test写几个例子。首先，判断一下，让使用者输入一个文件名，我们判断：
1. 这个文件是否存在，如果不存在则给予一个“Filename does not exist”的信息，
并中断程序。
2.如果这个文件存在，则判断他是文件或目录，结果输出"Filename is regular file"
或者"Filename is directory"
3.判断一下，执行者的身份对这个文件或目录所拥有的权限，并输出权限信息
（提示：注意利用test 与&& 还有||）

# 完整答案
[dmtsai@study bin]$ vim file_perm.sh
#!/bin/bash
# Program:
#   User input a filename, program will check the flowing:
#   1.) exist? 2.) file/directory? 3.) file permissions 
# History:
# 2015/07/16    VBird   First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 1. 讓使用者輸入檔名，並且判斷使用者是否真的有輸入字串？
echo -e "Please input a filename, I will check the filename's type and permission. \n\n"
read -p "Input a filename : " filename
test -z ${filename} && echo "You MUST input a filename." && exit 0
# 2. 判斷檔案是否存在？若不存在則顯示訊息並結束腳本
test ! -e ${filename} && echo "The filename '${filename}' DO NOT exist" && exit 0
# 3. 開始判斷檔案類型與屬性
test -f ${filename} && filetype="regulare file"
test -d ${filename} && filetype="directory"
test -r ${filename} && perm="readable"
test -w ${filename} && perm="${perm} writable"
test -x ${filename} && perm="${perm} executable"
# 4. 開始輸出資訊！
echo "The filename: ${filename} is a ${filetype}"
echo "And the permissions for you are : ${perm}"

#### 总结：
# 这个test的范例写的还是好差，没有一点点清晰的思路，先做什么后做什么，包括
# 从程序的完备性上来讲，对错误输入也没有判断，怎么样来展示权限也没有思路，
# 并不懂得用&&，以及当想要在一句话里展示更多权限时，用变量累加的方式
----------------------------
2018/8/9 12.3.1
#!/bin/bash
# Description:
#		xxxx
# History:
# test	8/9/2018	First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

read -p "Please input a filename: " filename
test -z filename && echo "there is no filename" && exit 0
test ! -e filename && echo "Filename does not exist" && exit 0

test -f filename && echo -e "Filename is regular file \n"
test -d filename && echo -e "filename is directory \n"

test -r filenmae && "This file is readable"
test -w filename && "This file is writable"
test -x filename && "This filename is executable"

# 错误总结：
# 1. Program 的地方写错了， 不是description,而是Program
# Program:
#   User input a filename, program will check the flowing:
#   1.) exist? 2.) file/directory? 3.) file permissions 
# 2. History 先写时间再写作者
# History:
# 2015/07/16    VBird   First release
# 3. 让使用者输入文件名这块，之前还可以再加一些说明性文字，用echo
# echo -e "Please input a filename, I will check the filename's type and permission. \n\n"
# 4. *** 在引用变量的时候要加特殊符号${}， 这次通篇都没有加
# 5. ** 在echo中引用变量的时候，需要用单引号把变量括起来（在服务器上写第四遍的时候发现的）
# 5. 在书写文件类型和文件权限的时候，还是要用更优雅的方式，而不是通通都输出字符串，而且在权限的
# 后半句，也没有写echo
# test -f ${filename} && filetype="regular file"
# test -d ${filename} && filetype="directory"
# test -r ${filename} && perm="readable"
# test -w ${filename} && perm="${perm} writable"
# test -x ${filename} && perm="${perm} executable"
# 6. 最后还要输出一下总结信息
# echo "The filename: ${filename} is a ${filetype}"
# echo "And the permission for you are: ${perm}"
###总的来说这次要比上次写的好很多，最大的错误就是变量没有写成特殊符号了。然后就是可以自定义一些变量
###比如filetype，perm之类的，并且最后以变量的形式展示出来。上次写的变量的累加其实并不准确，他其实就是
###对变量重新进行赋值，其中用到了之前变量的值而已。

#####还要补充两点注意：
#####1.一个是变量名不要写错，这个错误很低级
#####2.写文件名的时候光写文件名是不够的，除非这个文件就在脚本所在目录，不然要把路径也带上