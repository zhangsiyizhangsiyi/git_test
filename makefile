#目标:依赖
#	命令
#
#	wildcard
#	patsubst
#
#	$@ $< $^
#	
#	两类模式，伪目标

src=$(wildcard *.c)
obj=$(patsubst %.c , %.o , $(src))


a.out:$(obj)
	gcc $^ -o $@

$(obj):%.o:%.c
	gcc -c $< -o $@
clean:
	-rm -rf $(obj) a.out
ALL:a.out

.PHONY: clean ALL
