function dat = make_phasor(L,sigma)

rng(2);

delt = 0.005; % time step length in secs
start = 0; % starting position of the hand
nReps = 2; % number of base periods to track
nstep = ceil(50/delt); % number of time steps
Nreps = 20;
sigma = sigma*sqrt(delt);

% Single joint reaching movements:
G = 0.14;        % Viscous Constant: Ns/m; originally 0.14
I = 0.1;         % Inertia Kgm2; originally 0.1
tau = 0.066;    % Muscle time constant, s; originally 0.066

% sum-of-sines target movement
freqs = 0.05*primes(45);
freqX = freqs(1:2:end)'; % frequencies used in the simulation
freqY = freqs(2:2:end)';
amp = 0.015*ones(1,length(freqX));
phase = 2*pi*rand(length(freqX),2)-pi; % phases of sum of sines
target(1,:,:) = amp*sin(freqX*2*pi*(0:delt:nstep*delt-delt) + repmat(phase(:,1),1,nstep));
phase = 2*pi*rand(length(freqX),2)-pi;
target(2,:,:) = amp*sin(freqY*2*pi*(0:delt:nstep*delt-delt) + repmat(phase(:,2),1,nstep));
target = squeeze(sum(target,2));

% create state space model in discrete time
A = [0 1 0
    0 -G/I 1/I
    0 0 -1/tau];
B = [0 0 1/tau]';

z = size(A,1)+1;
Ad = expm(A*delt);
order = size(Ad,1);
Ad = [Ad zeros(order)
      zeros(order) Ad];

Bd = delt*B;
Bd = [Bd zeros(order,1)
      zeros(order,1) Bd];

%state vector
x = zeros(2*order,Nreps,nstep);
hand = zeros(2,Nreps,nstep);
x([1 4],:,1) = hand(:,:,1) - repmat(target(:,1),[1 Nreps]); % x position
u = zeros(size(Bd,2),Nreps,nstep); % movement commands

%simulate trajectory
for i = 2:nstep
    u(:,:,i) = -L*x(:,:,i-1);
    x(:,:,i) = Ad*x(:,:,i-1) + Bd*(u(:,:,i)+sigma*randn(1,Nreps));
    
    % set absolute hand position
    hand(:,:,i) = hand(:,:,i-1) + (x([1 4],:,i) - x([1 4],:,i-1));
    x([1 4],:,i) = hand(:,:,i) - repmat(target(:,i),[1 Nreps]);
end

% compute fourier transforms
e = 2/delt;
delay = 0.4/delt; % modeling sensorimotor delay
start = e+delay+1;
stop = (40/delt);

traj = hand(:,:,(e+1):(e+1)+stop);
traj(:,Nreps+1,:) = target(:,start:start+stop);
traj_avg = mean(traj,3);
traj_fft = fft(traj - repmat(traj_avg,[1 1 length(traj)]),[],3);

idx = find(abs(traj_fft(1,Nreps+1,:))>1);
idx = idx(idx<2000);
idy = find(abs(traj_fft(2,Nreps+1,:))>1);
idy = idy(idy<2000);

ratio = traj_fft(1,1:Nreps,idx)./repmat(traj_fft(1,Nreps+1,idx),[1 Nreps]);
ratio(2,:,:) = traj_fft(2,1:Nreps,idy)./repmat(traj_fft(2,Nreps+1,idy),[1 Nreps]);
ratio(3,:,:) = traj_fft(2,1:Nreps,idx)./repmat(traj_fft(1,Nreps+1,idx),[1 Nreps]);
ratio(4,:,:) = traj_fft(1,1:Nreps,idy)./repmat(traj_fft(2,Nreps+1,idy),[1 Nreps]);

% dat.ratio = ratio([2 5 11 17 23 31 41]);
dat.x = squeeze(ratio(1,:,:));
dat.y = squeeze(ratio(2,:,:));
dat.xy = squeeze(ratio(3,:,:));
dat.yx = squeeze(ratio(4,:,:));
