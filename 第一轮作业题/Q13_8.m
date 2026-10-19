startLine=1;
startStation='河南工业大学';
endLine=8;
endStation='鲁庙';
stationTable={...
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
gap={one,diff(eight)};
allStations=stationTable{1};
for j=1:numel(stationTable{2})
    if(~any(strcmp(allStations,stationTable{2}{j})))
        allStations{end+1}=stationTable{2}{j};
    end
end
n=numel(allStations);
roads=inf(n);
roads(1:n+1:end)=0;
for k=1:2
    [~,index]=ismember(stationTable{k},allStations);
    for j=1:numel(index)-1
        u=index(j);
        v=index(j+1);
        roads(u,v)=gap{k}(j);
        roads(v,u)=gap{k}(j);
    end
end
lines=[startLine,endLine];
stops={startStation,endStation};
ids=zeros(1,2);
for k=1:2
    which=find([1,8]==lines(k));
    available=stationTable{which};
    stop=stops{k};
    selected=find(strcmp(available,stop));
    ids(k)=find(strcmp(allStations,available{selected}));
end
startID=ids(1);
endID=ids(2);
dist=inf(n,1);
dist(startID)=0;
previous=zeros(n,1);
waiting=startID;
inQueue=false(n,1);
inQueue(startID)=true;
front=1;
while front<=numel(waiting)
    current=waiting(front);
    front=front+1;
    inQueue(current)=false;
    neighbours=find(isfinite(roads(current,:))&roads(current,:)>0);
    for k=1:length(neighbours)
        other=neighbours(k);
        newDistance=dist(current)+roads(current,other);
        if newDistance<dist(other)
            dist(other)=newDistance;
            previous(other)=current;
            if(~inQueue(other))
                waiting(end+1)=other;
                inQueue(other)=true;
            end
        end
    end
end
km=dist(endID);
pathNumber=endID;
while pathNumber(1)~=startID
    pathNumber=[previous(pathNumber(1)),pathNumber];
end
route=allStations(pathNumber);
if km<=6+1e-9
    money=2;
elseif km<=13+1e-9
    money=3;
elseif km<=21+1e-9
    money=4;
else
    money=4+ceil((km-21-1e-9)/9);
end
fprintf('%d\n',money)
