hold on
leap = [31 30 31 30 31 30 29 31 30 31 30 31];
nonleap = [31 30 31 30 31 30 28 31 30 31 30 31];

if year ~= 8
    months = nonleap;
else
    months = leap;
end

inm_t = 1;
inm = months(inm_t);
in_label = 9;
vline(0,'k','8')
while inm<frames
    vline(inm,'k',num2str(in_label))
    inm_t = inm_t + 1;
    inm = sum(months(1:inm_t));
    in_label = in_label + 1;
    
    if in_label==13
        in_label = 1;
    end
end

clear leap nonleap months inm_t inm in_label;
hold off