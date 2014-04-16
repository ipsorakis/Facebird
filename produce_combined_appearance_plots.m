function produce_combined_appearance_plots(x,y,OUTPUT_STRUCT)%,co_membership_distributions)
%figure
%plot_progression_3d_matrix(Chist,x,y,'k')
hold on
plot_progression_output_struct(OUTPUT_STRUCT,'W',x,y,'b')
%plot(Xhist(x,:),'g')
%plot(Xhist(y,:),'r')

%if exist('Whist_null','var')
%plot_progression_output_struct(OUTPUT_STRUCT,'Wnull',x,y,'r')
%end


title(strcat('DAILY appearances of birds i:',num2str(x),' and j:',num2str(y)));
%legend('co-membership','co-occurences within dt',strcat('appearances of:',num2str(x)),strcat('appearances of:',num2str(y)),'null co-occurences');
legend('co-occurences','null co-occurences');
hold off
% if nargin>6
%     figure
%     subplot(2,1,1)
%     hold on
%     title('position in co-membership distribution')
%     bar(0:length(co_membership_frequency)-1,co_membership_frequency)
%     do_simple_p_test(co_membership_frequency,C(x,y));
%     hold off
%     subplot(2,1,2)
%     hold on
%     title('position in total co-occurences distribution')
%     bar(0:length(cummulative_cooccurences_frequency)-1,cummulative_cooccurences_frequency)
%     do_simple_p_test(cummulative_cooccurences_frequency,Wsum(x,y));
%     hold off
% end

end