function [prog prog_null_mean prog_null_std] = plot_progression_output_struct(OUTPUT_STRUCT,adjacency_used,x,y,color,skip_inactive_areas)

if ~exist('color','var')
    color = 'b';
end

if ~exist('plot_inactive_areas','var')
    skip_inactive_areas = false;
end

[prog prog_null_mean prog_null_std] = get_progression_output_struct(OUTPUT_STRUCT,adjacency_used,x,y);

if skip_inactive_areas
   inactive = sum([prog prog_null_mean prog_null_std],2)==0;
   prog(inactive) = [];
   prog_null_mean(inactive) = [];
   prog_null_std(inactive) = [];
end

if strcmp(adjacency_used,'W')
    hold on
    plot(prog,color);
    errorbar(prog_null_mean,prog_null_std,'r');
    %errorarea(prog_null_mean,prog_null_std)
    hold off
    title(strcat('DAILY appearances of birds i:',num2str(x),' and j:',num2str(y)));
    legend('co-occurences','null co-occurences');
else
    plot(prog,color);
end

for n=1:length(prog)
    pval(n)=normpdf(prog(n),prog_null_mean(n),prog_null_std(n));
end
figure
semilogy(pval)