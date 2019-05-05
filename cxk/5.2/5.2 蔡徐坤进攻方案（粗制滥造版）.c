进攻方 A B C
防守方 X Y Z

前提条件：球被攻方A掌控
下面是一种情况的战略（若想适用于各种情况，可先用简单比较法判断出谁最靠近球，得到distance_MAX）
if(CBall2OppNumDist(X)<20 && CBall2OppNumDist(Y)>20 && CBall2OppNumDist(Z)>20)仅敌方X一人靠近球
{
    Get_point(X);获得X的位置
    Get_point(B);获得B的位置
    Get_point(C);获得C的位置
    if(B_to_X_distance<C_to_X_distance)
    {
        B上前去堵X，使B_to_X_distance=0；//B与X贴身时，两点距离可能不为0.本指令只是想实现B堵住X的状态
        C跟在A旁边，保持距离15cm内；
    }
    else C上去堵，B留守A身边等待被当肉盾；
}
设计的思路是：每当一位抢球者或阻挡者出现时，都派一名队友将其挡住，限制其行动.
             争取到时间，让持球者A突入对方球场内部.
             B当肉盾；A前进，遇到新障碍；C当肉盾，B解除肉盾位置；B跟上A，成为肉盾替补.
             B和C有且仅有一人成为肉盾，另一个人追随在A身边

虽然我代码写得像狗屎一样，不过只要你能理解我意思就好啦.毕竟....代码主力不是我哈，哈哈哈哈哈哈

if(CBall2OppNumDist(X)<20 && CBall2OppNumDist(Y)<20 && CBall2OppNumDist(Z)>20)两个人来堵了,防守方Z空闲
{
    获取位置；
    if(Z_to_B_distance<Z_to_A_distance)Z离B更近
    {
        if(B_to_Goal_distance>A_to_Goal_distance)传球给A（挑射）//谁离门框进给谁
        if(B_to_Goal_distance<A_to_Goal_distance)
        {
            if(Z_to_B_distance<5)传球给A(挑射)//Z已经堵住B了，不能传给B
            else 传球给B（挑）
        }

    }
}

if(CBall2OppNumDist(X)<20 && CBall2OppNumDist(Y)<20 && CBall2OppNumDist(Z)<20)三人来堵
{
    获取位置；
    if(两个堵正面，一个堵背面)
    {
        if(A有转身空间)
        {
            带球旋转，传球

        }

        if(A无转身空间)队员插入包围圈中，A转向队员，平射传球
    }
    if(一个堵正面，两个堵背面)
    {
        if(A有移动空间)绕开正面围堵者
        if(A没有移动空间)队员插入包围圈中，A转向队员，平射传球
    }
    if(三个堵正面)
    {
        if(A有挑射空间)和队友配合，远距离传球，一击入魂（对方球门仅有一个守门员，好对付）
        if(A无挑射空间)后退，制造空间，挑射，和队友配合，远距离传球
    }
}

关于如何判断射门条件这方面我还没想好，所以暂时先考虑怎么打入敌方内部    
好吧，今天的战术十分粗略，很多都不完善
但给了我一点点上手的感觉了~
明天继续呐~


