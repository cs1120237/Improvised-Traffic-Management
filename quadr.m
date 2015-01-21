function omat = quadr(vec,mat)
omat=true
pairs=nchoosek(vec,2)
for i=1:size(pairs,1)
    disp(mat(pairs(i,2),pairs(i,1)))
    if((mat(pairs(i,1),pairs(i,2))~=0) | (mat(pairs(i,2),pairs(i,1))~=0))
        omat=false
        disp(pairs)
    end
end
%disp(ans)
end % end of quadratic



function ans = optcmlist(wtvec,inmat)
cmat=inmat
%function calculates the discriminant
[maxVal maxInd] = max(wtvec)
curvec=cmat{maxInd}
%cmat=cmat(cmat~=curvec)
for i=1:size(curvec,2)
    for j=1:size(cmat,2)
        cmat{j}=cmat{j}(cmat{j}~=curvec(i))
    end
end
ans=cmat
end
