beginLine=1;
endLine=8;
beginStop='河南工业大学';
endStop='鲁庙';
[answer,km,route]=metro_fare_relax(beginLine,beginStop,endLine,endStop);
disp(answer)

function [fare,distance,path]=metro_fare_relax(firstLine,firstStop,lastLine,lastStop)
[A,s,t,stationNames]=metro_network(firstLine,firstStop,lastLine,lastStop);
[from,to]=find(isfinite(A)&A>0);
n=size(A,1);
lengthTo=inf(1,n);
lengthTo(s)=0;
parent=zeros(1,n);
for round=1:n-1
    changed=false;
    for edge=1:numel(from)
        u=from(edge);
        v=to(edge);
        proposed=lengthTo(u)+A(u,v);
        if proposed<lengthTo(v)
            lengthTo(v)=proposed;
            parent(v)=u;
            changed=true;
        end
    end
    if(~changed)
        break
    end
end
distance=lengthTo(t);
fare=metro_price(distance);
route=t;
while route(1)~=s
    route=[parent(route(1)),route];
end
path=stationNames(route);
end

function [A,source,destination,names]=metro_network(line1,station1,line2,station2)
[stations,lengths]=metro_data;
names=stations{1};
for j=1:numel(stations{2})
    if(~any(strcmp(names,stations{2}{j})))
        names{end+1}=stations{2}{j};
    end
end
n=numel(names);
A=inf(n);
A(1:n+1:end)=0;
for k=1:2
    [~,index]=ismember(stations{k},names);
    for j=1:numel(index)-1
        u=index(j);
        v=index(j+1);
        A(u,v)=lengths{k}(j);
        A(v,u)=lengths{k}(j);
    end
end
lines=[line1,line2];
stops={station1,station2};
ids=zeros(1,2);
for k=1:2
    which=find([1,8]==lines(k));
    available=stations{which};
    stop=stops{k};
    selected=find(strcmp(available,stop));
    ids(k)=find(strcmp(names,available{selected}));
end
source=ids(1);
destination=ids(2);
end

function fare=metro_price(distance)
if distance<=6+1e-9
    fare=2;
elseif distance<=13+1e-9
    fare=3;
elseif distance<=21+1e-9
    fare=4;
else
    fare=4+ceil((distance-21-1e-9)/9);
end
end

function [stations,lengths]=metro_data
stations={...
    {'河南工业大学','郑大科技园','郑州大学','梧桐街','兰寨','铁炉',...
    '市民中心','西流湖','西三环','秦岭路','五一公园','碧沙岗',...
    '绿城广场','医学院','郑州火车站','二七广场','人民路','紫荆山',...
    '燕庄','民航路','会展中心','黄河南路','农业南路','东风南路',...
    '郑州东站','博学路','市体育中心','龙子湖','文苑北路','河南大学新区'},...
    {'天健湖','轻工业大学','祥营','郑州大学','银屏路','冬青街',...
    '南流','大学科技园','五龙口','同乐','省中医院','白庙','东风路',...
    '枣庄','小营','龙湖中环南','郑大一附院东区','高铁公园','畅和街',...
    '郑州东站','圃田西','圃田','省社科院','福泽路','李湖桥',...
    '龙王庙','绿博园','鲁庙'}};
one=[1.1,1,1.5,1.2,1.7,1.7,1.5,1.6,1.4,0.943,0.993,1.4,...
    0.979,1.2,1.1,0.961,0.925,2,0.914,1.1,2,1,1.3,1.1,...
    1.6,2.5,2.2,1.8,1.4];
eight=[13.595438,16.030528,17.734366,19.238141,21.140270,...
    22.362984,23.976292,26.334812,27.196445,29.480017,30.616241,...
    32.383819,33.564687,34.878649,37.274434,39.145539,41.548121,...
    42.986715,44.360851,46.665229,49.394316,52.253526,55.941448,...
    57.822166,58.992166,60.867306,63.298423,65.025526];
lengths={one,diff(eight)};
end
