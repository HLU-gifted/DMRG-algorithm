
m = [60,80,100];
c = {'k','k-.','k--','k:'};
t_steps = 50; N = 200;
ms = zeros(t_steps,2,4);
for r = 1:length(m)
    load(strcat('m',int2str(m(r)),'r10_9JHDz.mat'))
    for k = 1:t_steps+1        
        %mags = (1/N)*sum(Sxprof(:,k));
        %mags = (1/N)*sum(Szprof(:,k));
        mags = (1/N)*sum(Syprof(:,k));
        ms(k,1:2,r) = [(k-1),mags];
    end
    subplot(3,1,3), plot(ms(:,1,r),ms(:,2,r),c{r},'LineWidth',1)
    hold on
end




