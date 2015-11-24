function coef_Fisher = calcul_fisher_Nclasses(X,T)

%% Calcul des coefficients de Fisher
classes = unique(T);
coef_Fisher=[];
for i=1:size(X,2)
    f=0;
    for k1=1:length(classes)
        for k2=k1+1:length(classes)
            if (k1~=k2)
             	f = f + (mean(X(T==classes(k1),i))-mean(X(T==classes(k2),i)))^2/(std(X(T==classes(k1),i)) + std(X(T==classes(k2),i)));
            end
        end
    end
    coef_Fisher=[coef_Fisher;f];
end