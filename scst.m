lambda = normrnd(10,3,4,1)

mu = normrnd(39, 2, 4, 1)

T=90

%random direction ratios(without normalisation)
mat = vec2mat(rand(12,1),4)

%direction wise lambdas
ldirat = transpose((mat./[(sum(mat));(sum(mat));(sum(mat))]) * diag(convert2vector(lambda)))
mdirat = transpose((mat./[(sum(mat));(sum(mat));(sum(mat))]) * diag(convert2vector(mu)))


queue = [100,100,100,100,100,100,100,100,100,100,100,100]

con = [ -1,0,0,0,1,1,1,1,0,1,1,0;
        0,-1,0,1,0,0,1,1,1,1,1,0;
        0,0,-1,1,0,0,0,0,0,0,1,0;
        0,1,1,-1,0,0,1,1,0,1,1,0;
        1,0,0,0,-1,0,1,1,0,1,1,1;
        1,0,0,0,0,-1,0,1,0,0,0,0;
        1,1,0,1,1,0,-1,0,0,0,1,1;
        1,1,0,1,1,1,0,-1,0,1,0,0;
        0,1,0,0,0,0,0,0,-1,1,0,0;
        1,1,0,1,1,0,0,1,1,-1,0,0;
        1,1,1,1,1,0,1,0,0,0,-1,0;
        0,0,0,0,1,0,1,0,0,0,0,-1 ]

%generate data matrix
nMax=12; %number of rows
M=rand(nMax,1e4); %the data

%cell array of matrices with row combinations
select=cell(2^nMax-nMax-1,1); %ignore singletons, empty set

%for loop to generate the row selections
idx=0;
safe=[]
for i=2:4
    %new=[]
    %I is the matrix of row selections
    I1=nchoosek(1:nMax,i);
    I=[[]]
    disp(I1)
    for j=1:size(I1,1) 
        if(quadr(I1(j,:),con) > 0)
            idx=idx+1;
            safe{idx}= I1(j,:)
        end
    end
    %disp(I)
    %idx=idx+1;
    %safe{idx}= I
end

dirctn = struct(...
    'row',         {'wr','wf','wl','er','ef','el','nr','nf','nl','sr','sf','sl'}, ...
    'qln', num2cell(queue), ...
    'green',       {T/4,T/4,T/4,T/4,T/4,T/4,T/4,T/4,T/4,T/4,T/4,T/4}, ...
    'red',       {3*T/4,3*T/4,3*T/4,3*T/4,3*T/4,3*T/4,3*T/4,3*T/4,3*T/4,3*T/4,3*T/4,3*T/4} );

queue_cylce = zeros(20,12)
simple_cycle = zeros(20,12)
for i=1:12
    simple_cycle(1,i) = queue(i)
    queue_cycle(1,i) = queue(i)
end

for k=2:20
    phasediv=optcmlist(dirctn,safe)
    phaseratio=[]

    for i=1:size(phasediv,2)
        temp=0
        for j=1:size(phasediv{i})
            temp=temp+dirctn(phasediv{i}(j)).qln
        end
        phaseratio=[phaseratio temp]
    end

    for i=1:size(phasediv,2)
        ptemp=(phaseratio(i)./sum(phaseratio))
        for j=1:size(phasediv{i},2)
            %disp("hhha")
            dirctn(phasediv{i}(j)).green=ptemp*T
            dirctn(phasediv{i}(j)).red=(1-ptemp)*T
        end
    end
    
    for i=1:12
        y = ((i-1)./3)+1
        y=floor(y)
        z = mod(i-1,3)+1
        p = ldirat(y,z)
        q = mdirat(y,z)
        temp2 = simple_cycle(k-1,i) + p*T - (q*T)/4
        temp = dirctn(i).qln + p*T - q*dirctn(i).green
        if (temp < 0)
            %q = (dirctn(i).qln + p*T)/dirctn(i).green
            dirctn(i).qln = 0
            queue_cycle(k,i)=0
        else
            dirctn(i).qln = dirctn(i).qln + p*T - q*dirctn(i).green
            queue_cycle(k,i) = dirctn(i).qln
        end
        simple_cycle(k,i) = simple_cycle(k-1,i) + p*T - (q*T)/4
        if(temp2 < 0)
            simple_cycle(k,i)=0
        end
    end
    
    mat = vec2mat(rand(12,1),4)

%direction wise lambdas
    ldirat = transpose((mat./[(sum(mat));(sum(mat));(sum(mat))]) * diag(convert2vector(lambda)))
    mdirat = transpose((mat./[(sum(mat));(sum(mat));(sum(mat))]) * diag(convert2vector(mu)))
end

our_approach = zeros(1,20)
simple_approach = zeros(1,20)

ans=0

for i=1:20
    for j=1:12
        our_approach(1,i) = our_approach(1,i)+queue_cycle(i,j)
        simple_approach(1,i) = simple_approach(1,i)+simple_cycle(i,j)
    end
    if(our_approach(1,i)>simple_approach(1,i))
        ans = ans+1
    end
end

final  = zeros(20,2)
for i=1:20
    final(i,1) = our_approach(1,i)
    final(i,2) = simple_approach(1,i)
end
r = [1,1,1;2,2,2]
