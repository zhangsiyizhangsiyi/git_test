一个规则，两个函数，三个变量，两种模式，伪目标

目标:依赖
	命令

wildcard \ patsubst

$@ , $^ , $<

%.o:%.c \ $(obj):%.o:%.c

.PHONY:ALL clean

src = $(wildcard *.c)
obj = $(patsubst %.o,%.c,$(src))
res = $(patsubst %,%.o,$(obj))

ALL:$(res)

%.o:%.c
	gcc -c $< -o $@
%:%.o
	gcc $< -o $@

clean:
	-rm -rf $(res) $(obj)
.PHONY: clean ALL
