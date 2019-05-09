1) 每个语句结尾的分号（;）是可选的，但如果同一行有多个语句最好用；分开
2) lua中的一行（多个）语句叫Chunk.
3) 一个连接外部Chunk的方式是使用dofile函数，dofile函数加载文件并执行它.
4) 全局变量不需要声明，给一个变量赋值后即创建了这个全局变量，访问一个没有初始化的全局变量也不会出错，只不过得到的结果是：nil，当且仅当一个变量不等于nil时，这个变量存在。
5) 注释：单行注释:--       多行注释：--[[ --]]
6) Lua是**动态类型语言**，变量不要定义类型。Lua中有8个基本类型分别为：`nil`、`boolean`、`number`、`string`、`userdata`、`function`、`thread`和`table`。函数`type`可以测试给定变量或者值的类型。
7) Booleans 类型：两个取值`false`和`true`。但要注意Lua中所有的值都可以作为条件。在控制结构的条件中除了false和nil为假，其他值都为真。所以Lua认为**0和空串都是真**。
8) Lua中字符串是不可以修改的，你可以创建一个新的变量存放你要的字符串,可以使用单引号或者双引号表示字符串.
9) 和 tonumber() 将字符串转换为数字 对应的将字符串转换为数字的函数 tostring() 
10) 函数可以存储在变量中，可以作为函数的参数，也可以作为函数的返回值。
11) 表达式：
12) 二元运算符：+ - * / ^ (加减乘除幂)
13) 一元运算符：- (负值)
14) 关系运算符  <  >  <=  >=  ==  ~=
15) 逻辑运算符 and or not
16) 一个很实用的技巧：如果x为false或者nil则给x赋初始值v :    `x = x or v`  等价于  `if not x then   x = v   end`
17) 三元运算符可以这样实现：`(a and b) or c`
18) 连接运算符 `..`  字符串连接，如果操作数为**数字**，Lua将**数字**转成**字符串**。
19) 构造器是创建和初始化表的表达式。表是Lua特有的功能强大的东西。最简单的构造函数是{}，用来创建一个空表，并直接初始化。
20) 赋值语句，Lua可以对多个变量同时赋值。遇到赋值语句Lua会先计算右边所有的值然后再执行赋值操作。`x, y = y, x  <==>  swap 'x' for 'y'`。多变量赋值常用来交换变量或者接受某个函数的多返回值。
21) 局部变量需要显式声明：`local i = 0`。同时应该尽可能的**使用局部变量**，有两个好处：1. **避免命名冲突** 2. 访问局部变量的速度比全局变量**更快**.
22) 控制结构语句： 
    ```lua
    --[[**if语句**]]
    if conditions then
        then-part
    end;
    if conditions then
        then-part
    else
        else-part
    end;
    if conditions then
        then-part
    elseif conditions then
        elseif-part
    .. --->多个elseif
    else
        else-part
    end;
    --[[**while语句**]]
    while condition do
        statements;
    end  
    --[[**repeat-until语句**]]   
    repeat
        statements;
    until conditions;
    --[[**数值for循环**]]
    for var=exp1,exp2,exp3 do
        loop-part
    end
    --[[**范型for循环**]]
    -- print all keys of table 't'
    for k in pairs(t) do print(k) end
    --[[ **** ]]
    ```
23) 第5章 函数
24) Lua层的变量命名规范
[命名规范](https://wuzhiwei.net/lua_style_guide/)
