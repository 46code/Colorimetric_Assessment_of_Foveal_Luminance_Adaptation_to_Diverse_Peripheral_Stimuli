function [] = jabplot(jab_male,jab_female,jab_20_30,jab_30_40,jab_40,jab_all)
    
    %% Gender based plot: jab_male, jab_female
    % first order
    figure; % J plot
    % Male subplot
    subplot(1,2,1); 
    plot(jab_male{1}(:,1),'w');hold on;
    plot(jab_male{3}(:,1),'r');
    plot(jab_male{5}(:,1),'g');
    plot(jab_male{7}(:,1),'b');
    plot(jab_male{9}(:,1),'y');
    plot(jab_male{11}(:,1),'m');
    plot(jab_male{13}(:,1),'c'); hold off;
    xlabel('No of Stimuli')
    ylabel('J*')
    legend(['White','Red ','Green','Blue','Yellow','Magenta','Cyan'],'Location', 'best', 'Box', 'off')
    title('Male')
    % Female subplot
    subplot(1,2,2);
    plot(jab_female{1}(:,1),'w');hold on;
    plot(jab_female{3}(:,1),'r');
    plot(jab_female{5}(:,1),'g');
    plot(jab_female{7}(:,1),'b');
    plot(jab_female{9}(:,1),'y');
    plot(jab_female{11}(:,1),'m');
    plot(jab_female{13}(:,1),'c'); hold off;
    xlabel('No of Stimuli')
    ylabel('J*')
    legend(['White','Red ','Green','Blue','Yellow','Magenta','Cyan'],'Location', 'best', 'Box', 'off')
    title('Female')

    figure; % ab plot
    % Male subplot
    subplot(1,2,1); 
    scatter(jab_male{1}(:,2),jab_male{1}(:,3),'w');hold on;
    scatter(jab_male{3}(:,2),jab_male{3}(:,3),'r');
    scatter(jab_male{5}(:,2),jab_male{5}(:,3),'g');
    scatter(jab_male{7}(:,2),jab_male{7}(:,3),'b');
    scatter(jab_male{9}(:,2),jab_male{9}(:,3),'y');
    scatter(jab_male{11}(:,2),jab_male{11}(:,3),'m');
    scatter(jab_male{13}(:,2),jab_male{13}(:,3),'c'); hold off;
    xlabel('a*')
    ylabel('b*')
    legend(['White','Red ','Green','Blue','Yellow','Magenta','Cyan'],'Location', 'best', 'Box', 'off')
    title('Male')
    % Female subplot
    subplot(1,2,2);
    scatter(jab_female{1}(:,2),jab_female{1}(:,3),'w');hold on;
    scatter(jab_female{3}(:,2),jab_female{3}(:,3),'r');
    scatter(jab_female{5}(:,2),jab_female{5}(:,3),'g');
    scatter(jab_female{7}(:,2),jab_female{7}(:,3),'b');
    scatter(jab_female{9}(:,2),jab_female{9}(:,3),'y');
    scatter(jab_female{11}(:,2),jab_female{11}(:,3),'m');
    scatter(jab_female{13}(:,2),jab_female{13}(:,3),'c'); hold off;
    xlabel('a*')
    ylabel('b*')
    legend(['White','Red ','Green','Blue','Yellow','Magenta','Cyan'],'Location', 'best', 'Box', 'off')
    title('Female')

    figure; % plot deltaE
    % Male subplot
    subplot(1,2,1); 
    plot(jab_male{1}(:,4),'w');hold on;
    plot(jab_male{3}(:,4),'r');
    plot(jab_male{5}(:,4),'g');
    plot(jab_male{7}(:,4),'b');
    plot(jab_male{9}(:,4),'y');
    plot(jab_male{11}(:,4),'m');
    plot(jab_male{13}(:,4),'c'); hold off;
    xlabel('No of Stimuli')
    ylabel('\DeltaE*')
    legend(['White','Red ','Green','Blue','Yellow','Magenta','Cyan'],'Location', 'best', 'Box', 'off')
    title('Male')
    % Female subplot
    subplot(1,2,2);
    plot(jab_female{1}(:,4),'w');hold on;
    plot(jab_female{3}(:,4),'r');
    plot(jab_female{5}(:,4),'g');
    plot(jab_female{7}(:,4),'b');
    plot(jab_female{9}(:,4),'y');
    plot(jab_female{11}(:,4),'m');
    plot(jab_female{13}(:,4),'c'); hold off;
    xlabel('No of Stimuli')
    ylabel('\DeltaE*')
    legend(['White','Red ','Green','Blue','Yellow','Magenta','Cyan'],'Location', 'best', 'Box', 'off')
    title('Female')


    figure; % plot CAM16-UCS
    % Male subplot
    subplot(1,2,1); 
    scatter3(jab_male{1}(:,2),jab_male{1}(:,3),jab_male{1}(:,1),'w');hold on;
    scatter3(jab_male{3}(:,2),jab_male{3}(:,3),jab_male{3}(:,1),'r');
    scatter3(jab_male{5}(:,2),jab_male{5}(:,3),jab_male{5}(:,1),'g');
    scatter3(jab_male{7}(:,2),jab_male{7}(:,3),jab_male{7}(:,1),'b');
    scatter3(jab_male{9}(:,2),jab_male{9}(:,3),jab_male{9}(:,1),'y');
    scatter3(jab_male{11}(:,2),jab_male{11}(:,3),jab_male{11}(:,1),'m');
    scatter3(jab_male{13}(:,2),jab_male{13}(:,3),jab_male{13}(:,1),'c'); hold off;
    xlabel('a*')
    ylabel('b*')
    zlabel('J*')
    legend(['White','Red ','Green','Blue','Yellow','Magenta','Cyan'],'Location', 'best', 'Box', 'off')
    title('Male')
    % Female subplot
    subplot(1,2,2);
    scatter3(jab_female{1}(:,2),jab_female{1}(:,3),jab_female{1}(:,1),'w');hold on;
    scatter3(jab_female{3}(:,2),jab_female{3}(:,3),jab_female{3}(:,1),'r');
    scatter3(jab_female{5}(:,2),jab_female{5}(:,3),jab_female{5}(:,1),'g');
    scatter3(jab_female{7}(:,2),jab_female{7}(:,3),jab_female{7}(:,1),'b');
    scatter3(jab_female{9}(:,2),jab_female{9}(:,3),jab_female{9}(:,1),'y');
    scatter3(jab_female{11}(:,2),jab_female{11}(:,3),jab_female{11}(:,1),'m');
    scatter3(jab_female{13}(:,2),jab_female{13}(:,3),jab_female{13}(:,1),'c'); hold off;
    xlabel('a*')
    ylabel('b*')
    zlabel('J*')
    legend(['White','Red ','Green','Blue','Yellow','Magenta','Cyan'],'Location', 'best', 'Box', 'off')
    title('Female')

    
    % second order plot
    figure; % J plot
    % Male subplot
    subplot(1,2,1); 
    plot(jab_male{2}(:,1),'w');hold on;
    plot(jab_male{4}(:,1),'r');
    plot(jab_male{6}(:,1),'g');
    plot(jab_male{8}(:,1),'b');
    plot(jab_male{10}(:,1),'y');
    plot(jab_male{12}(:,1),'m');
    plot(jab_male{14}(:,1),'c'); hold off;
    xlabel('No of Stimuli')
    ylabel('J*')
    legend(['White','Red ','Green','Blue','Yellow','Magenta','Cyan'],'Location', 'best', 'Box', 'off')
    title('Male')
    % Female subplot
    subplot(1,2,2);
    plot(jab_female{2}(:,1),'w');hold on;
    plot(jab_female{4}(:,1),'r');
    plot(jab_female{6}(:,1),'g');
    plot(jab_female{8}(:,1),'b');
    plot(jab_female{10}(:,1),'y');
    plot(jab_female{12}(:,1),'m');
    plot(jab_female{14}(:,1),'c'); hold off;
    xlabel('No of Stimuli')
    ylabel('J*')
    legend(['White','Red ','Green','Blue','Yellow','Magenta','Cyan'],'Location', 'best', 'Box', 'off')
    title('Female')

    figure; % ab plot
    % Male subplot
    subplot(1,2,1); 
    scatter(jab_male{2}(:,2),jab_male{2}(:,3),'w');hold on;
    scatter(jab_male{4}(:,2),jab_male{4}(:,3),'r');
    scatter(jab_male{6}(:,2),jab_male{6}(:,3),'g');
    scatter(jab_male{8}(:,2),jab_male{8}(:,3),'b');
    scatter(jab_male{10}(:,2),jab_male{10}(:,3),'y');
    scatter(jab_male{12}(:,2),jab_male{12}(:,3),'m');
    scatter(jab_male{14}(:,2),jab_male{14}(:,3),'c'); hold off;
    xlabel('a*')
    ylabel('b*')
    legend(['White','Red ','Green','Blue','Yellow','Magenta','Cyan'],'Location', 'best', 'Box', 'off')
    title('Male')
    % Female subplot
    subplot(1,2,2);
    scatter(jab_female{2}(:,2),jab_female{2}(:,3),'w');hold on;
    scatter(jab_female{4}(:,2),jab_female{4}(:,3),'r');
    scatter(jab_female{6}(:,2),jab_female{6}(:,3),'g');
    scatter(jab_female{8}(:,2),jab_female{8}(:,3),'b');
    scatter(jab_female{10}(:,2),jab_female{10}(:,3),'y');
    scatter(jab_female{12}(:,2),jab_female{12}(:,3),'m');
    scatter(jab_female{14}(:,2),jab_female{14}(:,3),'c'); hold off;
    xlabel('a*')
    ylabel('b*')
    legend(['White','Red ','Green','Blue','Yellow','Magenta','Cyan'],'Location', 'best', 'Box', 'off')
    title('Female')

    figure; % plot deltaE
    % Male subplot
    subplot(1,2,1); 
    plot(jab_male{2}(:,4),'w');hold on;
    plot(jab_male{4}(:,4),'r');
    plot(jab_male{6}(:,4),'g');
    plot(jab_male{8}(:,4),'b');
    plot(jab_male{10}(:,4),'y');
    plot(jab_male{12}(:,4),'m');
    plot(jab_male{14}(:,4),'c'); hold off;
    xlabel('No of Stimuli')
    ylabel('\DeltaE*')
    legend(['White','Red ','Green','Blue','Yellow','Magenta','Cyan'],'Location', 'best', 'Box', 'off')
    title('Male')
    % Female subplot
    subplot(1,2,2);
    plot(jab_female{2}(:,4),'w');hold on;
    plot(jab_female{4}(:,4),'r');
    plot(jab_female{6}(:,4),'g');
    plot(jab_female{8}(:,4),'b');
    plot(jab_female{10}(:,4),'y');
    plot(jab_female{12}(:,4),'m');
    plot(jab_female{14}(:,4),'c'); hold off;
    xlabel('No of Stimuli')
    ylabel('\DeltaE*')
    legend(['White','Red ','Green','Blue','Yellow','Magenta','Cyan'],'Location', 'best', 'Box', 'off')
    title('Female')


    figure; % plot CAM16-UCS
    % Male subplot
    subplot(1,2,1); 
    scatter3(jab_male{2}(:,2),jab_male{2}(:,3),jab_male{2}(:,1),'w');hold on;
    scatter3(jab_male{4}(:,2),jab_male{4}(:,3),jab_male{4}(:,1),'r');
    scatter3(jab_male{6}(:,2),jab_male{6}(:,3),jab_male{6}(:,1),'g');
    scatter3(jab_male{8}(:,2),jab_male{8}(:,3),jab_male{8}(:,1),'b');
    scatter3(jab_male{10}(:,2),jab_male{10}(:,3),jab_male{10}(:,1),'y');
    scatter3(jab_male{12}(:,2),jab_male{12}(:,3),jab_male{12}(:,1),'m');
    scatter3(jab_male{14}(:,2),jab_male{14}(:,3),jab_male{14}(:,1),'c'); hold off;
    xlabel('a*')
    ylabel('b*')
    zlabel('J*')
    legend(['White','Red ','Green','Blue','Yellow','Magenta','Cyan'],'Location', 'best', 'Box', 'off')
    title('Male')
    % Female subplot
    subplot(1,2,2);
    scatter3(jab_female{2}(:,2),jab_female{2}(:,3),jab_female{2}(:,1),'w');hold on;
    scatter3(jab_female{4}(:,2),jab_female{4}(:,3),jab_female{4}(:,1),'r');
    scatter3(jab_female{6}(:,2),jab_female{6}(:,3),jab_female{6}(:,1),'g');
    scatter3(jab_female{8}(:,2),jab_female{8}(:,3),jab_female{8}(:,1),'b');
    scatter3(jab_female{10}(:,2),jab_female{10}(:,3),jab_female{10}(:,1),'y');
    scatter3(jab_female{12}(:,2),jab_female{12}(:,3),jab_female{12}(:,1),'m');
    scatter3(jab_female{14}(:,2),jab_female{14}(:,3),jab_female{14}(:,1),'c'); hold off;
    xlabel('a*')
    ylabel('b*')
    zlabel('J*')
    legend(['White','Red ','Green','Blue','Yellow','Magenta','Cyan'],'Location', 'best', 'Box', 'off')
    title('Female')
    %% Age based plot: jab_20_30, jab_30_40, jab_40
    

end