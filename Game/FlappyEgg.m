% Define global variables
global posPipesUp;      % Position of the upper pipes
global posPipesDown;    % Position of the lower pipes
global velPipes;        % Velocity of the pipes
global posBird;         % Position of the bird
global birdLength;      % Length of the bird
global gameState;       % Game State
global posCoins;        % Position of the coins
global velCoins;        % Velocity of the coins
global coinSize;        % Size of the coins
global interval;        % Interval between the pipes
global score;           % Player's score
global gravity;         % Gravity
global velBird;         % Velocity of the bird
global posBird;         % Position of the bird
global jumping;         % Whether bird is jumping
global velJumping;      % Jumping velocity of the bird 

% Initialize parameters
gravity = 0.04;
posPipesUp = zeros(4,4);
posPipesDown = zeros(4,4);
posBird = [300 252];
posCoins = zeros(4,4);
velPipes = 0.7;
velCoins = 0.7;
velBird = 0;
velJumping = 1.5;
birdLength = 35 ;
coinSize = 30;
interval = 300;
gameState = false;
jumping = false;
score = 0;

% Creat a figure for the game window
figure('Name','Flappy Egg','KeyPressFcn',@isJumping,'CloseRequestFcn',@close);
title('Flappy Egg');   % set title for the game window
axis off;   % Hide axes

% Creat an axis
ax = axes('XLim',[0 900],'YLim',[0 504]);
    
% Hide the X and Y tick and axis lines
set(ax, 'XTickLabel', [], 'YTickLabel', []);
% Hide the menu bar
set(gcf,'Menubar','none');

% Play background music
[music,fs1] = audioread('music.mp3');
sound(music,fs1);

% Draw backgound
background = imread('background.png');  % Read the background
imagesc(background);    % Display the background
axis off;   % Hide axes


% Draw the start prompt text
startText = text(450, 252, 'Press Any Buttons to Start', 'HorizontalAlignment', 'center', 'FontSize', 20, 'FontWeight', 'bold', 'Color', 'w');

% Wait for user input to start the game
waitforbuttonpress;

gameState = true;    % Set game state to runing
   
delete(startText);  % Remove the start prompt text

%Draw the score
scoreText = text(450, 20, ['Score: ', num2str(score)], 'HorizontalAlignment', 'center', 'FontSize', 20, 'FontWeight', 'bold', 'Color', 'w');

% Draw the bird
bird = rectangle('Position',[posBird(1),posBird(2),birdLength,birdLength],'Curvature', [1, 1], 'FaceColor', [1, 1, 0.5]); 

% Generate the position of the first pipes randomly
seedPipes = randi([1,4]);
[posPipesUp(1,:),posPipesDown(1,:)] = generatePipes(seedPipes);

% Drew 4 pipes (A window can draw 4 pipes maximum)
pipes1u = rectangle('position',posPipesUp(1,:),'FaceColor',[0.8,0.6,0.3]);
pipes2u = rectangle('position',[0,0,0,0],'FaceColor',[0.8,0.6,0.3]);
pipes1d = rectangle('position',posPipesDown(1,:),'FaceColor',[0.8,0.6,0.3]);
pipes2u = rectangle('position',[0,0,0,0],'FaceColor',[0.8,0.6,0.3]);
pipes2d = rectangle('position',[0,0,0,0],'FaceColor',[0.8,0.6,0.3]);
pipes3u = rectangle('position',[0,0,0,0],'FaceColor',[0.8,0.6,0.3]);
pipes3d = rectangle('position',[0,0,0,0],'FaceColor',[0.8,0.6,0.3]);
pipes4u = rectangle('position',[0,0,0,0],'FaceColor',[0.8,0.6,0.3]);
pipes4d = rectangle('position',[0,0,0,0],'FaceColor',[0.8,0.6,0.3]);

% Draw 4 coins (coins will be generated beteen two pipes)
coins1 = rectangle('position',[0,0,0,0],'Curvature',[1,1],'FaceColor',[1,0.8,0]);
coins2 = rectangle('position',[0,0,0,0],'Curvature',[1,1],'FaceColor',[1,0.8,0]);
coins3 = rectangle('position',[0,0,0,0],'Curvature',[1,1],'FaceColor',[1,0.8,0]);
coins4 = rectangle('position',[0,0,0,0],'Curvature',[1,1],'FaceColor',[1,0.8,0]);

% initialize indices
p = 1;          % Indices of pipe
c = 1;          % Indices of coin
flagOver = 1;   % Flag of game over

% -------------------------- Main game loop ----------------------------------
while gameState 

    % Check if it's time to generate new pipes
    if posPipesUp(p,1) > (500 - velPipes) && posPipesUp(p,1) <= 500
        
        p = mod(p,4) + 1;           % Cycle through pipe indices
        
        % Generate the position of the pth pipe randomly
        seedPipes = randi([1,4]);   
        [posPipesUp(p,:),posPipesDown(p,:)] = generatePipes(seedPipes);
        
        % Draw the new pipe
        if p == 1
            pipes1u = rectangle('position',posPipesUp(p,:),'FaceColor',[0.8,0.6,0.3]);
            pipes1d = rectangle('position',posPipesDown(p,:),'FaceColor',[0.8,0.6,0.3]);
        elseif p == 2
            pipes2u = rectangle('position',posPipesUp(p,:),'FaceColor',[0.8,0.6,0.3]);
            pipes2d = rectangle('position',posPipesDown(p,:),'FaceColor',[0.8,0.6,0.3]);
        elseif p == 3
            pipes3u = rectangle('position',posPipesUp(p,:),'FaceColor',[0.8,0.6,0.3]);
            pipes3d = rectangle('position',posPipesDown(p,:),'FaceColor',[0.8,0.6,0.3]);
        else
            pipes4u = rectangle('position',posPipesUp(p,:),'FaceColor',[0.8,0.6,0.3]);
            pipes4d = rectangle('position',posPipesDown(p,:),'FaceColor',[0.8,0.6,0.3]);
        end 
    end
    
    % Check if it's time to generate new coins
    if posPipesUp(p,1) <= 500 + interval/2 && posPipesUp(p,1) > (500 - velPipes + interval/2)
       
        c = mod(c,4) + 1;                   % Cycle through coin indices
        
        % Generate the position of the cth coin randomly
        posCoins(c,:) = generatecoins();    
        
        % Draw the new coin
        if c == 1
            coins1 = rectangle('Position',posCoins(c,:),'Curvature',[1,1],'FaceColor',[1,0.8,0]);
        elseif c == 2
            coins2 = rectangle('Position',posCoins(c,:),'Curvature',[1,1],'FaceColor',[1,0.8,0]);
        elseif c == 3
            coins3 = rectangle('Position',posCoins(c,:),'Curvature',[1,1],'FaceColor',[1,0.8,0]);
        else
            coins4 = rectangle('Position',posCoins(c,:),'Curvature',[1,1],'FaceColor',[1,0.8,0]);
        end
    end
    

    % Move the pipes
    for j = 1 : size(posPipesUp,1)
        posPipesUp(j,1) = posPipesUp(j,1) - velPipes;
        posPipesDown(j,1) = posPipesDown(j,1) - velPipes;
    end

    % Move the coins
    for m = 1 : size(posCoins,1) 
        posCoins(m,1) = posCoins(m,1) - velCoins;
    end
   
    % Update pipe positions
    set(pipes1u,'position',posPipesUp(1,:));
    set(pipes1d,'position',posPipesDown(1,:));
    set(pipes2u,'position',posPipesUp(2,:));
    set(pipes2d,'position',posPipesDown(2,:));
    set(pipes3u,'position',posPipesUp(3,:));
    set(pipes3d,'position',posPipesDown(3,:));
    set(pipes4u,'position',posPipesUp(4,:));
    set(pipes4d,'position',posPipesDown(4,:));
    
    % Update coin positions
    set(coins1,'position',posCoins(1,:));
    set(coins2,'position',posCoins(2,:));
    set(coins3,'position',posCoins(3,:));
    set(coins4,'position',posCoins(4,:));
   
    % Handle bird's jumping
    if jumping
        velBird = velJumping;
        jumping = false;
    end

    velBird = velBird - gravity;    % Apply gravity to bird
    
    % Update the bird's position
    posBird(2) = posBird(2) - velBird; 
    set(bird,'Position',[posBird(1),posBird(2),birdLength,birdLength]);
    
    pointSystem();      % Update the score
    checkCollision();   % Check for collisions 
    
    % Update the score
    set(scoreText,'String',['Score ',num2str(score)]);
    uistack(scoreText, 'top');  % Bring score text to the front

    % Gradully increase the velocity of pipes coins, and jumping
    velPipes = velPipes + 0.00001;
    velCoins = velCoins + 0.00001;
    
    if velJumping <= 1.8         % The maximum velocity of jumping is 1.8
        velJumping = velJumping + 0.00001;
    end
   
    % Pause for a short moment 
    pause(0.00000001);
end

% Clean up after the game ends
delete(scoreText);

% Draw game over text
gameOverText = text(450, 252, 'Loser', 'HorizontalAlignment', 'center', 'FontSize', 30, 'FontWeight', 'bold', 'Color', 'r');
finalScoreText = text(450, 200, ['Final Score: ', num2str(score)], 'HorizontalAlignment', 'center', 'FontSize', 20, 'FontWeight', 'bold', 'Color', 'w');
RQText = text(450, 150, 'Press R to Restart or Q to Quit', 'HorizontalAlignment', 'center', 'FontSize', 15, 'FontWeight', 'bold', 'Color', 'w');

% Detect the key to restart or quit the game
while flagOver

    waitforbuttonpress;
    key = get(gcf,'CurrentKey');

    if strcmp(key,'r')      
        clear sound;            % clear sound
        delete(gcf);            % Delete current figure
        run("FlappyEgg.m");     % Restart the game
        flagOver = 0;           % Exit loop
    end

    if strcmp(key,'q')
        clear sound;
        delete(gcf);            % Quit the game
        flagOver = 0;           % Exit loop
    end
end

%------------------------------ Function ----------------------------------

% Function to generate new pipes randomly (preset the value for the positions of four pipes)
function [posPipes1,posPipes2] = generatePipes(seed)
    switch seed
        case 1
            posPipes1 = [900,0,120,40];
            posPipes2 = [900,150,120,354];
        case 2
            posPipes1 = [900,0,120,140];
            posPipes2 = [900,250,120,254];
        case 3
            posPipes1 = [900,0,120,240];
            posPipes2 = [900,350,120,154];
        case 4
            posPipes1 = [900,0,120,340];
            posPipes2 = [900,450,120,54];
    end
end

% Function to generate new coins randomly
function [posCoins] = generatecoins()
    global coinSize;
    posCoins = [900,randi([10,450]),coinSize,coinSize];
end

% Function to handle bird jumping
function isJumping(~,event)     %KeyPressFcn return two argument 'src' and 'event'
    global jumping;
    %event is a data structure which contians Key
    if strcmp(event.Key,'space')
        jumping = true;
    end
end

% Function to check for collision
function checkCollision()
    global gameState
    global velBird
    global posPipesUp
    global posPipesDown
    global posBird
    global birdLength


    for i = 1 : 4
        % Check for collision with upper pipes
        if posBird(1) + birdLength >= posPipesUp(i, 1) && ...
           posBird(1) <= posPipesUp(i, 1) + posPipesUp(i, 3) && ...
           posBird(2) <= posPipesUp(i, 2) + posPipesUp(i, 4)
            gameState = false;
            [hit,fs3] = audioread('hit.mp3');
            sound(hit,fs3);
        end
        % Check for collision with lower pipes
        if posBird(1) + birdLength >= posPipesDown(i, 1) && ...
           posBird(1) <= posPipesDown(i, 1) + posPipesDown(i, 3) && ...
           posBird(2) + birdLength >= posPipesDown(i, 2)
            gameState = false;
            [hit,fs3] = audioread('hit.mp3');
            sound(hit,fs3);
        end
        
        % Check if the bird hits the ground
        if posBird(2) > 504
            gameState = false;
            [drop,fs5] = audioread('drop.mp3');
            sound(drop,fs5);
            velBird = 0;
        end
    end
end

% Function to handle scoring
function pointSystem()
    global score;
    global posBird;
    global posPipesUp
    global birdLength;
    global velPipes;
    global posCoins;
    global coinSize;

    for i = 1 : 4
        % Check if the bird collects a coin
        if posBird(1) + birdLength >= posCoins(i, 1) && ...
           posBird(1) <= posCoins(i, 1) + coinSize && ...
           posBird(2) + birdLength >= posCoins(i, 2) && ...
           posBird(2) <= posCoins(i, 2) + coinSize
            score = score + 1;
            posCoins(i,:) = [0, 0, 0, 0]; 
            [point,fs2] = audioread('point.mp3');
            sound(point,fs2);
        end

        % Check if the bird passes through a pipe
        if posBird(1) > (posPipesUp(i,1) + posPipesUp(i,3) - velPipes) && posBird(1) <= posPipesUp(i,1) + posPipesUp(i,3)
            score = score + 1;
            [point,fs2] = audioread('point.mp3');
            sound(point,fs2);
        
        end
    end
end

% Function to handle the figure close request
function close(scr,~)
    global gameState;

    % Show  a dialog based on the game state
    if gameState
     choice = questdlg('YOU AER A COWARD','Close Request','Yes','No','No');
    else
     choice = questdlg('YOU ARE A LOSER', 'Close Request','Yes','No','No');
    end
    switch choice
        case 'Yes'
            delete(scr);    % Close the figure
            clear sound;    % Stop any playing sound
        case 'No'
            return;         % return
    end
end

        