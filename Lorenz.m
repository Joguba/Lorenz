rho=28;
sigma=10;
beta=8/3;
eps = 0.000001; %Constants
t = 1:.01:5; %Time vector
datn=10; %Number of points to consider
dm=35; %Randomness range of starting points
tic
for n=1:datn
    initV=dm*(.5-rand(1,3)); %Creates a random starting position from 0 to 10 in each field (x,y,z).
    options = odeset('RelTol',eps,'AbsTol',[eps eps eps/10]); %Sets options for Diff. Eq
    [~,dat] = ode45(@(t,dat) F(t, dat, sigma, rho, beta), t, initV, options); %Solves Diff. Eq
    lorenzdata(n).x=dat(:,1);
    lorenzdata(n).y=dat(:,2);
    lorenzdata(n).z=dat(:,3); %Assigns proper data
    lorenzdata(n).ldat=animatedline('Color',rand(1,3)); %Dynamically creates animated lines inside the Lorenz data
end
view(3)
xlim([1.65*-abs(max(lorenzdata(1).x)),1.65*abs(max(lorenzdata(1).x))])
ylim([1.65*-abs(max(lorenzdata(1).y)),1.65*abs(max(lorenzdata(1).y))])
zlim([1.65*-abs(max(lorenzdata(1).z)),1.65*abs(max(lorenzdata(1).z))])
for n=1:length(t)
    for l=1:datn %These two for loops animated each line
        addpoints(lorenzdata(l).ldat,lorenzdata(l).x(n),lorenzdata(l).y(n),lorenzdata(l).z(n)); %Plots
        drawnow; %Draws plot
    end
    view(-37.5+n,30)
    f(n)=getframe;
end

filename = 'Lorenz.gif';
for n=1:2:length(f)
    frame=f(n);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    % Write to the GIF File
    if n == 1
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append');
    end
end

function dx = F(t, dat, sigma, rho, beta)
dx = zeros(3,1);
dx(1) = sigma*(dat(2) - dat(1));
dx(2) = dat(1)*(rho - dat(3)) - dat(2);
dx(3) = dat(1)*dat(2) - beta*dat(3);
return
end