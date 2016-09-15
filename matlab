tic;
chengshu =  input('chengshu = ');
huadian = input('huadian = ');
sxf = 0.0003;

n = size( closeprice,1 );
emaprice20 = ema(closeprice,20);
emaprice12 = ema(closeprice,12);
emaprice26 = ema(closeprice,26);
DIFF = zeros(n,1);
DEA = zeros(n,1);
MACD = zeros(n,1);
opensign = zeros(n,1);
pcsign = zeros(n,1);
m = zeros(n,1);
money = zeros(n,1);
lots = 1;
beginday = 1;
endday = n;


for i = 1:n
    DIFF(i,1) = emaprice12(i,1) - emaprice26(i,1);
end
for i = 2:n
    DEA(i,1) = DEA(i-1,1)*0.8+DIFF(i,1)*0.2;
end
for i = 1:n
    MACD(i,1) = 2*(DIFF(i,1)-DEA(i,1)); 
end

for i = 2:n
    if ( DEA(i,1) > DEA(i-1,1) ) && ( emaprice20(i,1) > emaprice20(i-1,1) ) && ( m(i,1)~=1 )
        opensign(i,1) = 1;
        m (i:n,1) = 1;
    end
    
    if ( DEA(i,1) < DEA(i-1,1) ) && ( emaprice20(i,1) < emaprice20(i-1,1) ) && ( m(i,1)~=-1 )
        opensign(i,1) = -1;
        m (i:n,1) = -1;
    end
end
% plot (DEA); 
% hold on;
% plot (emaprice10);
openppp = closeprice.*opensign;
pcprice = closeprice.*pcsign;
n = size(closeprice,1);

lr = zeros(n,1);
for i = 2:n
    lr(i,1) = lr(i-1)+m(i-1)*(closeprice(i)-closeprice(i-1))*chengshu-abs(m(i)-m(i-1))*(closeprice(i)*sxf+huadian)*chengshu;
    MR(i,1) = m(i-1)*(closeprice(i)-closeprice(i-1))*chengshu-abs(m(i)-m(i-1))*(closeprice(i)*sxf+huadian)*chengshu;
end
zlr = lr(n,1);
huiche = 0 ;
for i = 1:n
    for j = i:n
        huiche = max(( lr(i,1) - lr(j,1) ),huiche);
    end
end
duiying = zeros(size(opensign));

for i = 1:n 
    if opensign(i,1)~=0
        for j = i+1 :n
            if opensign(j,1)~=0
                duiying(i,1) = j;
                break
            end
        end
     end
end
everylots = zeros(size(opensign));
for i = 1:n
    if duiying(i,1)~=0
    everylots(i,1) = (closeprice(duiying(i,1),1)-closeprice(i,1))*chengshu*opensign(i,1);
    end
end
ax1 = subplot(2,1,1);
    plot (lr);
hold on;
ax2 = subplot(2,1,2);
    bar(everylots);
linkaxes ([ax1,ax2],'x');
sharp = sqrt(252)*mean (MR)/std(MR);
%夏普比
a = sum(everylots>0);
b = sum(everylots<0);
number = a+b;
shenglv = a/number;
toc;
